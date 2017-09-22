#lang debug racket
(require sicp)
(require racket/trace)
;20:44->
(define (make-accumulator balance)
  (lambda (value)
          (begin (set! balance (+ value balance)) balance)))
(define A (make-accumulator 5))
(display (A 10))
(newline)
(display (A 10))
(newline)
(display (A 10))
(define a 1)
