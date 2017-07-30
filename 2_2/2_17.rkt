#lang racket
(require racket/trace)

(define (last-pair l)
  (if (null? (cdr l))
      (car l)
      (last-pair (cdr l))))
(display (last-pair (list 23 72 149 34)))

(newline)

(define (del_last l)
  (if (null? (cdr l))
    '()
    (cons (car l) (del_last (cdr l)))))

(define (reverse l)
  (if (null? l)
      '()
    (cons (last-pair l) (reverse (del_last l))))
  )
(define (reverse2 l)
  (define (rev_acm lst ret)
    (if (null? lst)
      ret
      (rev_acm (cdr lst) (cons (car lst) ret)))
    )
  (rev_acm l '()))
(display (reverse (list 1 4 9 16 25)))
(newline)
;(display "acm")
;(display (reverse2 (list 1 4 9 16 25)))
;(newline)
