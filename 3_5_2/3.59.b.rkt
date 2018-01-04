#lang racket/load
(require sicp)
(require (prefix-in strm: racket/stream))
(require "3_5_2/stream.rkt")
; 13:48->13:57
; ----------------
; ここから準備
; ----------------
(define ones (cons-stream 1 ones))

(define nega-ones (cons-stream -1 nega-ones))

(define integers
  (cons-stream 1 (add-streams ones integers)))

(define (mul-streams s1 s2)
  (stream-map * s1 s2))

(define (quotient-streams s1 s2)
  (stream-map / s1 s2))

(define (integrate-series sa)
  (quotient-streams sa integers))

(define exp-series
  (cons-stream 1 (integrate-series exp-series)))
  ; ----------------
  ; ここまで準備
  ; ----------------
; 誘導どおりに書くとこうだけど…循環定義になって無理なんじゃない？
; と思ったら普通にできた……無限ストリーム凄えええええええええええええ
(define cosine-series
  (cons-stream 1 (integrate-series (mul-streams nega-ones sine-series))))

(define sine-series
  (cons-stream 0 (integrate-series cosine-series)))

(define (stream-head s n)
  (define (iter s n)
    (if (<= n 0)
      'done
      (begin
        (display (stream-car s))
        (display ", ")
        (iter (stream-cdr s) (- n 1)))))
  (iter s n))

(stream-head exp-series 10)
(newline)
(stream-head cosine-series 10)
(newline)
(stream-head sine-series 10)
(newline)
