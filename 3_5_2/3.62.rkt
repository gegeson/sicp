#lang racket/load
(require sicp)
(require (prefix-in strm: racket/stream))
(require "3_5_2/stream.rkt")
; 17:51 -> 17:57

(define (scale-stream stream factor)
  (stream-map (lambda (x) (* x factor)) stream))

(define (mul-series s1 s2)
  (cons-stream (* (stream-car s1) (stream-car s2))
  (add-streams (scale-stream (stream-cdr s2) (stream-car s1))
               (mul-series (stream-cdr s1) s2))))

(define (invert-unit-series s)
  (cons-stream 1
               (scale-stream (mul-series (stream-cdr s) (invert-unit-series s)) -1)))

(define (div-series s1 s2)
  (if (zero? (stream-car (invert-unit-series s2)))
    (error "ゼロ割りは出来ませんよ〜")
    (mul-series s1 (invert-unit-series s2)))
  )

; -------------------
; tan作るための準備
; -------------------

(define ones (cons-stream 1 ones))

(define nega-ones (cons-stream -1 nega-ones))

(define integers
  (cons-stream 1 (add-streams ones integers)))

(define (quotient-streams s1 s2)
  (stream-map / s1 s2))

(define (integrate-series sa)
  (quotient-streams sa integers))

(define (mul-streams s1 s2)
 (stream-map * s1 s2))

(define cosine-series
  (cons-stream 1 (integrate-series (mul-streams nega-ones sine-series))))

(define sine-series
  (cons-stream 0 (integrate-series cosine-series)))
; -------------
; 準備ここまで
; -------------
(define tangent-series
  (div-series sine-series cosine-series))

(define (stream-head s n)
 (define (iter s n)
   (if (<= n 0)
     'done
     (begin
       (display (stream-car s))
       (display ", ")
       (iter (stream-cdr s) (- n 1)))))
 (iter s n))

(stream-head tangent-series 10)

; 0, 1, 0, 1/3, 0, 2/15, 0, 17/315, 0, 62/2835,
; 合ってる！！！
; つまり3.61.rktが合ってる証明にもなってるわけだ。やった。
