; 21:54->22:00

プロセスAが獲得状態から解放状態に移行し、
待機していたプロセスB、プロセスCが同時に獲得しようとしている時。
まずプロセスAが開放するので、(car cell)は#f。
プロセスBが(car cell)をチェックする。これは#fである。
プロセスBが次の(begin (set-car! cell #t) #f)に進む前に、
プロセスCが(car cell)をチェックする。これも#fである。
その後、プロセスBが(begin (set-car! cell #t) #f)を実行する。
プロセスCもまた、(begin (set-car! cell #t) #f)を実行する。
これらによって、プロセスB、Cはともに自分の処理を実行する。
直列化失敗となる。

(define (make-serializer)
  (let ((mutex (make-mutex)))
    (lambda (p)
            (define (serialized-p . args)
              (mutex 'acquire)
              (let ((val (apply p args)))
                (mutex 'release)
                val))
            serialized-p)))
(define (make-mutex)
  (let ((cell (list #f)))
    (define (the-mutex m)
      (cond ((eq? m 'acquire)
             (if (test-and-set! cell)
               (the-mutex 'acquire)))
        ((eq? m 'release) (clear! cell))))
    the-mutex))

(define (clear! cell) (set-car! cell #f))

(define (test-and-set! cell)
  (if (car cell)
    #t
    (begin (set-car! cell #t) #f)))
