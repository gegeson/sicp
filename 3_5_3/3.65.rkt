#lang racket/load
(require sicp)
(require (prefix-in strm: racket/stream))
(require "3_5_3/stream.rkt")
; 13:01 -> 13:15
(define (partial-sums s)
  (cons-stream (stream-car s)
               (add-streams (stream-cdr s) (partial-sums s))))

(define (pi-summands n)
 (cons-stream (/ 1.0 n)
               (stream-map - (pi-summands (+ n 2)))))

(define (log2 n)
  (cons-stream (/ 1.0 n)
               (stream-map - (log2 (+ n 1)))))

(define log2-stream
  (partial-sums (log2 1)))

; テスト用

(define (stream-head s n)
 (define (iter s n)
   (if (<= n 0)
     'done
     (begin
       (display (stream-car s))
       (newline)
       (iter (stream-cdr s) (- n 1)))))
 (iter s n))

(stream-head log2-stream 10)
; n = 10まで行っても
; 0.6456349206349207
; で、0.69314…の小数点以下第二位さえ一致しない

; 加速装置1
(define (square x) (* x x))

(define (euler-transform s)
  (let ((s0 (stream-ref s 0))
        (s1 (stream-ref s 1))
        (s2 (stream-ref s 2)))
    (cons-stream (- s2 (/ (square (- s2 s1))
                          (+ s0 (* -2 s1) s2)))
                 (euler-transform (stream-cdr s)))))

(display "加速装置1\n")
(stream-head (euler-transform log2-stream) 10)
; n = 10で
; 0.6930657506744464
; ちょっと近づいた

; 加速装置2
(define (make-tableau transform s)
  (cons-stream s (make-tableau transform (transform s))))

(define (accelerated-sequence transform s)
  (stream-map stream-car (make-tableau transform s)))

(display "加速装置2\n")
(stream-head (accelerated-sequence euler-transform log2-stream) 10)
; n = 10で
; 0.6931471805599454
; すごい。最後の4以外は一致している。最強
