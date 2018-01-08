#lang racket/load
; ようわからんが(require sicp)を入れると動かなくなる。外すと動く
; (require sicp)
(require (prefix-in strm: racket/stream))
(require "3_5_4/stream.rkt")
; 11:12->11:33
; +5m
;
; dy = f(y)dt … 1.
;
; integral dy = integral f(y)dt
;
; y = integral f(y)*dt … 2.
;
; 1. と 2. の計算をそれぞれ
;
; (define y (integral dy y0 dt))
; (define dy (stream-map f y))
;
; で表現したい、ということかな。
;
; で、改善版がこれ

(define (integral delayed-integrand initial-value dt)
  (define int
    (cons-stream initial-value
                 (let ((integrand (force delayed-integrand)))
                   (add-streams (scale-stream integrand dt)
                                int))))
  int)

(define (solve f y0 dt)
  (define y (integral (delay dy) y0 dt))
  (define dy (stream-map f y))
  y)

(display (stream-ref (solve (lambda (x) x) 1 0.001) 1000))
