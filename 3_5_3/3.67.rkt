#lang racket/load
(require sicp)
(require (prefix-in strm: racket/stream))
(require "3_5_3/stream.rkt")
; 21:30 -> 21:49

(define (interleave s1 s2)
  (if (stream-null? s1)
      s2
      (cons-stream (stream-car s1)
                   (interleave s2 (stream-cdr s1)))))

; (1, 1)│ (1, 2), (1, 3)
; ￣￣￣   ￣￣￣￣￣￣
; (2, 1)│ (2, 2), (2, 3)
; (3, 1)│ (3, 2), (3, 3)
;
; この左上の領域をA1,
; 右上の領域をB1,
; 左下の領域をC1、
; 右下の領域をD1とし、
; A1→B1のA1側の一つ→C1のA1側の一つ
; →D1のA1側の一つ→B1, C1から合間に一つずつ呼び出しつつ、D1内でを4区画に分けA1〜D1のような順序で再帰的に呼び出す
; という呼び出し方が良いんじゃないかなあと思った。（規則的かつまんべんなく呼べるという意味で）
; 実装しよう。
; どうやら思った通りの順序にはなってないけど、一応要件通りにはなってるっぽいな。よしとしよう。

(define (pairs s t)
  (cons-stream
   (list (stream-car s) (stream-car t))
   (interleave (interleave
                (stream-map (lambda (x) (list (stream-car s) x))
                            (stream-cdr t))
                (stream-map (lambda (x) (list x (stream-car t)))
                            (stream-cdr s)))
               (pairs (stream-cdr s) (stream-cdr t)))))

(define (stream-head s n)
  (define (iter s n)
    (if (<= n 0)
      'done
      (begin
        (display (stream-car s))
        (newline)
        (iter (stream-cdr s) (- n 1)))))
  (iter s n))

(stream-head (pairs integers integers) 25)
