#lang racket/load
; ようわからんが(require sicp)を入れると動かなくなる。外すと動く
; (require sicp)
; 13:45->14:05
(require (prefix-in strm: racket/stream))
(require "3_5_4/stream.rkt")

; dy に何らかの処理を施したものと
; y に何らかの処理を施したものを合流させる
; それがddy
; そしてddyを積分したものがdyになる
; 一般化するとそんな感じじゃないかな？と思う。
; y, dyに施す処理と合流をひとまとめにfとしてしまえば完成する気がする。

(define (integral delayed-integrand initial-value dt)
  (define int
    (cons-stream initial-value
                 (let ((integrand (force delayed-integrand)))
                   (add-streams (scale-stream integrand dt)
                                int))))
  int)

; dy に何らかの処理を施したものと
; y に何らかの処理を施したものを合流させる
; それがddy
; そしてddyを積分したものがdyになる
; 一般化するとそんな感じじゃないかな？と思う。
; y, dyに施す処理と合流をひとまとめにfとしてしまえば完成する気がする。

; う〜ん惜しかった。かすってはいる。
; fとしてどんなものを渡すのが適切か、というインターフェイスが見えてなかった。
(define (my-solve-2nd f y0 dy0 dt)
  (define y
    (integral (delay dy) y0 dt)
    )
  (define dy
    (integral (delay ddy) dy0 dt)
    )
  (define ddy
    (f y dy))
  y)

(define (f dy y) (add-streams (scale-stream dy 0) (scale-stream y 1)))
(display (stream-ref (my-solve-2nd f 1 1 0.001) 1000))

; 正しくはこう。
; http://uents.hatenablog.com/entry/sicp/039-ch3.5.4.md
(define (solve-2nd-ex f y0 dy0 dt)
  (define y (integral (delay dy) y0 dt))
  (define dy (integral (delay ddy) dy0 dt))
  (define ddy (stream-map f dy y))
  y)

(stream-ref
          (solve-2nd-ex (lambda (dy y) (+ (* dy 2) (* y -1)))
                        1 1 0.001) 1000)

; 上の式がmapに言い換え可能である、という視点かな、足りなかったのは
