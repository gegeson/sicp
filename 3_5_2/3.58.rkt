#lang racket/load
(require sicp)
(require (prefix-in strm: racket/stream))
(require "3_5_2/stream.rkt")
; 13:17->13:36
;
; 拝借
; http://www.serendip.ws/archives/1600
;; stream の最初の n 個の要素を印字する手続き
(define (stream-head s n)
  (define (iter s n)
    (if (<= n 0)
      'done
      (begin
        (display (stream-car s))
        (display ", ")
        (iter (stream-cdr s) (- n 1)))))
  (iter s n))
; expandが組み込みにあるので名前衝突回避
(define (_expand num den radix)
  (cons-stream
    (quotient (* num radix) den)
    (_expand (remainder (* num radix) den) den radix)))

; (expand 1 7 10)はどうなる？
; (expand 1 7 10)
; = (1 (expand 3 7 10))
; = (1 4 (expand 2 7 10))
; = (1 4 2 (expand 6 7 10))
; = (1 4 2 8 (expand 4 7 10))
; = (1 4 2 8 5 (expand 5 7 10))
; = (1 4 2 8 5 7 (expand 1 7 10))
; …
; = (1 4 2 8 5 7 1 4 2 8 5 7 1 …)
; 10/7の結果が示す数の循環そのもの
; 考えてみればこの計算がやっているのは割り算の筆算そのものだ。
; 当たり前か。
;
; (expand 3 8 10)は？
; (expand 3 8 10)
; = (3 (expand 6 8 10))
; = (3 7 (expand 4 8 10))
; = (3 7 5 (expand 0 8 10))
; = (3 7 5 0 (expand 0 8 10))
; …
; = (3 7 5 0 0 0 …)
; 30/8は割り切れるからこうなるということかな

(stream-head (_expand 1 7 10) 10)
(newline)
(stream-head (_expand 3 8 10) 10)
