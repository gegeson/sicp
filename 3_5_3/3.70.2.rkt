#lang racket/load
(require sicp)
(require (prefix-in strm: racket/stream))
(require "3_5_3/stream.rkt")
; 解けなかったので復習
; 11:37->11:46

(define (merge-weighted s1 s2 w)
  (cond ((stream-null? s1) s2)
        ((stream-null? s2) s1)
        (else
         (let ((s1car (stream-car s1))
               (s2car (stream-car s2)))
           (let ((w1 (w s1car))
                 (w2 (w s2car)))
             (cond ((<= w1 w2)
                    (cons-stream s1car (merge-weighted (stream-cdr s1) s2 w)))
               (else
                (cons-stream s2car (merge-weighted s1 (stream-cdr s2) w)))))))))


; pairsの領域Bnと領域Cnは常に和に関して整列済みだからこの方法（マージ）が使える、ということに今気付いた。
(define (pairs-weighted s t w)
  (cons-stream
   (list (stream-car s) (stream-car t))
   (merge-weighted
    (stream-map (lambda (x) (list (stream-car s) x))
                (stream-cdr t))
    (pairs-weighted (stream-cdr s) (stream-cdr t) w) w)
   )
  )

  (define (stream-head s n)
  (define (iter s n)
    (if (<= n 0)
      'done
      (begin
        (display (stream-car s))
        (newline)
        (iter (stream-cdr s) (- n 1)))))
  (iter s n))


(define (sum-pair p)
  (+ (car p) (cadr p)))

(stream-head (pairs-weighted integers integers sum-pair) 15)
