#lang racket/load
(require sicp)
(require (prefix-in strm: racket/stream))
(require "3_5_2/stream.rkt")
; 17:28 -> 17:50
(define (scale-stream stream factor)
  (stream-map (lambda (x) (* x factor)) stream))

(define (mul-series s1 s2)
  (cons-stream (* (stream-car s1) (stream-car s2))
  (add-streams (scale-stream (stream-cdr s2) (stream-car s1))
               (mul-series (stream-cdr s1) s2))))

(define (invert-unit-series s)
  (cons-stream 1
               (scale-stream (mul-series (stream-cdr s) (invert-unit-series s)) -1)))

; ?
; （これ以外どうするの、という感覚はあるものの）
; 自信/Zero
; テストで確かめてもよくわからない。
; しょうがなくググったら合ってるっぽい……まあ確かに定義どおり書いてるだけだもんなあ
; 結果が謎いのは放置しとこう

(define ones (cons-stream 1 ones))

(define integers
 (cons-stream 1 (add-streams ones integers)))

(define (stream-head s n)
 (define (iter s n)
   (if (<= n 0)
     'done
     (begin
       (display (stream-car s))
       (display ", ")
       (iter (stream-cdr s) (- n 1)))))
 (iter s n))

(stream-head (invert-unit-series integers) 20)
