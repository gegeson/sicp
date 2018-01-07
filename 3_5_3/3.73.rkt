#lang racket/load
(require sicp)
(require (prefix-in strm: racket/stream))
(require "3_5_3/stream.rkt")
; 21:32->21:43

(define (integral integrand initial-value dt)
  (define int
    (cons-stream initial-value
                 (add-streams (scale-stream integrand dt)
                             int)))
  int)

(define (RC R C dt)
  (define (RCsub i v0)
    (cons-stream v0
                 (add-streams
                  (scale-stream i R)
                             (integral (scale-stream i (/ 1 C)) 0 dt))))
  Rsub)
; 多分これでいいけど、確かめ方がわからんので答え見た
; 公式解答見たら、ほぼ同じだったがintegralに渡す定数部分もv0にしてたがどういうことだろう。
; 二重に足すことになるし違う気がするな。自分の方を信じる
