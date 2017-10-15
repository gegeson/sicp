#lang debug racket
(require sicp)
(require racket/trace)
;7:14->7:20
(define (count-pairs x)
  (define encountered nil)
  (define (check-enc x)
      (if (memq x encountered)
          #t
        (begin (set! encountered (cons x encountered)) #f)
        )
    )
  (define (count-proc x)
    (cond
      [(not (pair? x)) 0]
      [(check-enc x) 0]
      [else
       (+ (count-proc (car x)) (count-proc (cdr x)) 1)
       ]
      )
    )
  (count-proc x)
  )


(define a1 (cons 'a 'a))
(define a2 (cons a1 a1))
(define a3 (cons 'a a2))
(define a4 (cons a2 a2))
(count-pairs a1)
(count-pairs a2)
(count-pairs a3)
(count-pairs a4)
(newline)
(define a5 (cons a2 a1))
(count-pairs a5)
(newline)
(define a6 (cons a1 nil))
(define a7 (cons a6 a1))
(count-pairs a7)
(newline)
(define a8 (cons 'a (cons 'b (cons 'c nil))))
(count-pairs a8)
