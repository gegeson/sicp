; 21:36->21:41
#lang racket
(require sicp)
(require racket/trace)
(define (equal? lst1 lst2)
  (cond
    ((or (null? lst1) (null? lst2)) #t)
    ((not (pair? lst1)) (eq? lst1 lst2))
    (else
     (and (equal? (car lst1) (car lst2))
          (equal? (cdr lst1) (cdr lst2)))
     )
    )
  )

(display (equal? '(1 2 3) '(1 2 3)))
(newline)
(display (equal? '(1 2 1) '(1 2 3)))
(newline)
(display (equal? '(3 2 3) '(1 2 3)))
(newline)
(display (equal? '(this is a list) '(this is a list)))
(newline)
(display (equal? '(this is a list) '(this (is a) list)))
(newline)
(display (equal? '(this (is a) list) '(this (is a) list)))
(newline)
(display (equal? '((this (is (a))) (list)) '((this (is (a))) (list))))
(newline)
