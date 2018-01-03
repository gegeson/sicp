#lang racket/load
(require sicp)
(require (prefix-in strm: racket/stream))
(require "3_5_2/stream.rkt")
; 22:13->22:22

(define (add-streams s1 s2) (stream-map + s1 s2))

(define ones (cons-stream 1 ones))

(define integers
  (cons-stream 1 (add-streams ones integers)))

(define (mul-streams s1 s2)
  (stream-map * s1 s2))

(define factorials
  (cons-stream 1 (mul-streams factorials (stream-cdr integers))))

;factorials      1   2!   3!
;integers    1   2   3    4
;factorials  1   2!  3!   4!
(display-s factorials 0 6)
; 合ってる。
