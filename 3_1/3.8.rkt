#lang debug racket
(require sicp)
(require racket/trace)
;20:49->21:04

(define f
  (let ((p_x 0) (pp_x 0))
    (lambda (x)
      (begin (set! pp_x p_x) (set! p_x x) pp_x))
  ))

(display (+ (f 0) (f 1)))
;これだけを動かすと0を出力
(newline)
;(display (+ (f 1) (f 0)))
;これだけを動かすと1を出力
