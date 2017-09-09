#lang racket
(require racket/trace)
;14:26->14:34


(define (f g) (g 2))
(define (square x) (* x x))
;(f f)
;= (f 2)
;= (2 2)
(trace f)
;(f square)
(f f)
