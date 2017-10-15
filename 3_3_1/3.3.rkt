#lang debug racket
(require sicp)
(require racket/trace)
;11m
(define x (list 'a 'b))
(define z1 (cons x x))
(define z2 (cons (list 'a 'b) (list 'a 'b)))
(define (set-to-wow! x) (set-car! (car x) 'wow) x)
(set-to-wow! z1)
(display z1)
(newline)
(set-to-wow! z2)
(newline)
(display z2)
