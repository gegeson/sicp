; 22:00->23:00

make-mutexを使うver

むずい。ちょっと格闘したけどさっぱりわからん。
諦めてコピペ・写経。
う〜〜ん。自分の発想が掠りもしなかった事に驚く。
なるほどなあ。解説と感想を書いてみる。
そもそも、自分が考えたようにmutexをベースにして複数のプロセスを管理する、という風にはしていない。
使われているmutexは飽くまでも道具。

(define (make-mutex)
  (let ((cell (list #f)))
    (define (the-mutex m)
      (cond ((eq? m 'acquire)
             (if (test-and-set! cell)
               (the-mutex 'acquire)))
        ((eq? m 'release) (clear! cell))))
    the-mutex))

そもそも、元のmutexは、（自分が最初試した方針のように）シリアライザに渡された処理の実行には何も口を出していなくて、
ただ単に、
'acquire を受け取れるのは解放時だけであり、
解放されてない時に'acquire を受け取ると解放されるまでループして先に進めなくなる。
そして'release によってのみ解放される、
という二つの性質を持つだけである。
これを拡張して、
'acquire を受け取れるのはcountがn以下の時だけであり、
countが nより大きい時に'acquire を受け取ると解放されるまでループして先に進めなくなる。
そして'release によってのみ解放される、
という性質を持つようにしたのがセマフォ。
その上で、nを触る時に並行に操作されると困るからmutexで保護するようにしているだけで、
一つのmutexを使って複数の処理をどうこうしているわけではない

test-and-set!を使うverは3.47.2.rkt（これも手も足も出ず）

(define (make-semaphore n)
  (let ((mutex (make-mutex)))
    (define (process-acquire)
      (mutex 'acquire)
      (if (n > 0)                   ;
          (set! n (- n 1))          ;n を変更するのでmutexで保護する.
          (begin (mutex 'release) (process-acquire)))
                                    ;先に進めない時はmutexを解除
      (mutex 'release))             ;セマフォ処理が済んだ時もmutexを解除
    (define (process-release)
      (mutex 'acquire)
      (set! n (+ n 1))
      (mutex 'release))
    (define (dispatch m)
      (cond ((eq? m 'acquire) (process-acquire))
            ((eq? m 'release) (process-release))
            (else (error "Unknown request SEMAPHORE" dispatch))))
  dispatch))

(define (P semaphore)
  (semaphore 'acquire))

(define (V semaphore)
  (semaphore 'release))
