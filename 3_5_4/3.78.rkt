#lang racket/load
; ようわからんが(require sicp)を入れると動かなくなる。外すと動く
; (require sicp)
; 12:30->12:41
; delayを忘れてたけど解けたと言っていいでしょう！解けたということにする。
(require (prefix-in strm: racket/stream))
(require "3_5_4/stream.rkt")

(define (integral delayed-integrand initial-value dt)
  (define int
    (cons-stream initial-value
                 (let ((integrand (force delayed-integrand)))
                   (add-streams (scale-stream integrand dt)
                                int))))
  int)
;
(define (solve f y0 dt)
  (define y (integral (delay dy) y0 dt))
  (define dy (stream-map f y))
  y)

(define (solve-2nd a b y0 dy0 dt)
  (define y
    (integral (delay dy) y0 dt)
    )
  (define dy
    (integral (delay ddy) dy0 dt)
    )
  (define ddy
    (add-streams (scale-stream dy a) (scale-stream y b)))
  y)

　(display (stream-ref (solve-2nd 0 1 1 1 0.001) 1000))
