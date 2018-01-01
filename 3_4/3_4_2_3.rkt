; 20:44->20:52
; 21:38->21:54
make-serializerは、
関数を受け取り、受け取った関数が何らかの引数を受け取った時、
mutexによる獲得と解放をする関数を返すように関数を加工する。

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
