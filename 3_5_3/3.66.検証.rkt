#lang racket/load
(require sicp)
(require (prefix-in strm: racket/stream))
(require "3_5_3/stream.rkt")

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

(define (stream-head s n)
 (define (iter s n count)
   (if (<= n 0)
     'done
     (begin
       (printf "~a, count = ~a\n" (stream-car s) count)

       (iter (stream-cdr s) (- n 1) (+ count 1)))))
 (iter s n 1))

(stream-head (pairs integers integers) 767)
; {7 7}, count = 127
; {7 8}, count = 191
; {8 8}, count = 255
; 完璧に計算通り。
;
; {9 9}, count = 511
; {9 10}, count = 767
; {10 10}, count = 1023
; うむ。よきかな。
