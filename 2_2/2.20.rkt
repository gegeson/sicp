#lang racket
(require racket/trace)
(define (even? n)
  (= (remainder n 2) 0)
)
(define (odd? n)
  (= (remainder n 2) 1)
  )

(define (filter lst f)
  (cond ((null? lst) '())
    ((f (car lst)) (cons (car lst) (filter (cdr lst) f)))
    (else
     (filter (cdr lst) f)
     ))
  )

(define (same-parity a . lst)
  (if (even? a)
      (cons a (filter lst even?))
      (cons a (filter lst odd?))))

(display (same-parity 1 2 3 4 5 6 7))
(newline)

(display (same-parity 2 3 4 5 6 7))
(newline)
