#lang racket/load
; ようわからんが(require sicp)を入れると動かなくなる。外すと動く
; (require sicp)
; 11:49->11:55
(require (prefix-in strm: racket/stream))
(require "3_5_4/stream.rkt")

(define (integral-before integrand initial-value dt)
  (cons-stream
   initial-value
   (if (stream-null? integrand)
     the-empty-stream
     (integral-before (stream-cdr integrand)
               (+ (* dt (stream-car integrand))
                  initial-value)
               dt))))

(define (integral delayed-integrand initial-value dt)
 (cons-stream
  initial-value
  (let ((integrand (force delayed-integrand)))
    (if (stream-null? integrand)
      the-empty-stream
      (integral (stream-cdr integrand)
                (+ (* dt (stream-car integrand))
                   initial-value)
                dt)))))

(define (solve f y0 dt)
  (define y (integral (delay dy) y0 dt))
  (define dy (stream-map f y))
  y)

(display (stream-ref (solve (lambda (x) x) 1 0.0001) 10000))
