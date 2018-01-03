; 23:11->23:38
#lang racket/load
(require sicp)
(require (prefix-in strm: racket/stream))
(require "3_5_2/stream.rkt")
(define integers
  (cons-stream 1 (add-streams ones integers)))

(define fibs
  (cons-stream
   0
   (cons-stream 1 (add-streams (stream-cdr fibs) fibs))))

(display-s fibs 0 10)
; fibs         0 1 1 2 3 5 8
; cdr fibs   0 1 1 2 3 5 8
; fibs     0 1 1 2 3 5 8
; nは0から始まるとすると、
; n番目のフィボナッチ数を計算するのにn-1回計算が必要になる。
; メモ化をしない場合、
; n番目の和の計算に n-1番目の計算にかかった回数 + n-2番目の計算にかかった回数
; のぶんだけの足し算が行われ、
; これはフィボナッチ数と等しくなりすなわち指数オーダーになる。
