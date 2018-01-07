#lang racket/load
(require sicp)
(require (prefix-in strm: racket/stream))
(require "3_5_3/stream.rkt")
; 13:45->13:55
; (stream-fileter
;  (lambda (pair) (prime? (+ (car pair) (cadr pair))))
;  int-pairs)

; これはs1が無限の場合ダメ
(define (stream-append s1 s2)
  (if (stream-null? s1)
    s2
    (cons-stream (stream-car s1)
                 (stream-append (stream-cdr s1) s2))))

(define (interleave s1 s2)
  (if (stream-null? s1)
    s2
    (cons-stream (stream-car s1)
                 (interleave s2 (stream-cdr s1)))))

(define (pairs s t)
(cons-stream
 (list (stream-car s) (stream-car t))
 (interleave
  (stream-map (lambda (x) (list (stream-car s) x))
              (stream-cdr t))
  (pairs (stream-cdr s) (stream-cdr t)))))
