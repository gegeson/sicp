; 23:08->23:21
これまた手も足も出なかったのでコピペ&解説
blockは、cellが真ならばループを続け、
cellが偽になれば値を返しループを終え、即座にcellを真に設定し、
その次に進む、という処理。
つまり、blockは、
他のプロセスがclear!するまでは自分がその先を進めない壁であると同時に、
blockを超えてからclear!に着くまでは他のプロセスが割り込めない壁でもある。

セマフォが
「'acquire を受け取れるのはcountがn以下の時だけであり、
'release によってのみ解放される、
という性質を持つ」
のは今回も同じ。
上に書いた性質を持つblockとclear!を、
mutexを使うバージョンにおける
(mutex 'acquire)及び(mutex 'release)
と同じように配置してやればいいだけのこと。

う〜〜〜ん、すごい。これは思い付かない。

(define (test-and-set! cell)
  (if (car cell)
    #t
    (begin (set-car! cell #t) #f)))


(define (make-semaphore n)
 (let ((cell (list false)))
  (define (process-acquire)
   (define (block)              ;;cellが偽になるまでループして待つ.
     (if (test-and-set! cell)
         (block)))
   (block)
   (if (n > 0)
       (set! n (- n 1))         ;; n が 0 を超えていれば通過できる.
       (begin (clear! cell) (process-acquire)))
                                ;;cellをクリアしてprocess-acquire
   (clear! cell))               ;;でループして待つ.
  (define (process-release)
   (define (block)
     (if (test-and-set! cell)
         (block)))
   (block)
   (set! n (+ n 1))
   (clear! cell))
  (define (dispatch m)
   (cond ((eq? m 'acquire) (process-acquire))
         ((eq? m 'release) (process-release))
         (else (error "Unknown request TEST-AND-SET!" dispatch))))
 dispatch))
