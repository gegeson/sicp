#lang racket
(require racket/trace)
;13:30->13:31
(define (square x) (* x x))
(define (inc x) (+ x 1))
(define (compose f g) (lambda (x) (f (g x))))
(display ((compose square inc) 6) )
