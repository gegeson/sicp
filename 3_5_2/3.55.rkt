#lang racket/load
(require sicp)
(require (prefix-in strm: racket/stream))
(require "3_5_2/stream.rkt")
; 22:23->22:34

(define (add-streams s1 s2) (stream-map + s1 s2))

(define ones (cons-stream 1 ones))

(define integers
  (cons-stream 1 (add-streams ones integers)))

; (define (partial-sums s)
;   (cons-stream 1 (add-streams (stream-cdr s) (partial-sums s)))
;   )
; 間違えてた。ここ1じゃなくて(stream-car s)だよ。
(define (partial-sums s)
  (cons-stream (stream-car s) (add-streams (stream-cdr s) (partial-sums s)))
  )
; あくまで自分にとっては、だけど、こうやって数列を並べて書くと実装しやすい
; integers           1 2 3  4   5   6 7 8 9
; parital-sums         1 3  6  10  14
; parital-sums       1 3 6 10  15
(display-s (partial-sums integers) 0 5)
