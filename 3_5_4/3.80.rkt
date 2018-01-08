#lang racket/load
; ようわからんが(require sicp)を入れると動かなくなる。外すと動く
; (require sicp)
(require (prefix-in strm: racket/stream))
(require "3_5_4/stream.rkt")
; 14:17->14:33
; できたー
(define (integral delayed-integrand initial-value dt)
  (define int
    (cons-stream initial-value
                 (let ((integrand (force delayed-integrand)))
                   (add-streams (scale-stream integrand dt)
                                int))))
  int)

(define (RLC R L C dt)
  (define (rlc vC0 iL0)
    (define vC
      (integral (delay dvC) vC0 dt)
      )
    (define iL
      (integral (delay diL) iL0 dt)
      )
    (define dvC
      (scale-stream iL (/ -1 C))
      )
    (define diL
      (add-streams (scale-stream iL (/ (* -1 R) L))
                   (scale-stream vC (/ 1 L))))
    (stream-map cons vC iL))
  rlc)

(define RLC1 (RLC 1 1 0.2 0.1))
(stream-head (RLC1 10 0) 10)
