; 22:06->22:12
#lang racket/load
(require sicp)
(require (prefix-in strm: racket/stream))
(require "3_5_2/stream.rkt")

(define (add-streams s1 s2)
  (stream-map + s1 s2))

(define s (cons-stream 1 (add-streams s s)))
;      1 2 4  8 16
;    + 1 2 4  8 16
;s =   1 2 4  8 16 32
;
; こうなると思われる。
(display-s s 0 10)
; 合ってる。
