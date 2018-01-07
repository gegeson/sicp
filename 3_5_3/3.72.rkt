#lang racket/load
(require sicp)
(require (prefix-in strm: racket/stream))
(require "3_5_3/stream.rkt")
; 20:48->20:56

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

(define (square x) (* x x))

(define (sum-square p)
  (+ (square (car p)) (square (cadr p))))

(stream-head (pairs-weighted integers integers sum-square) 15)

(define find-n
  (let ((p (pairs-weighted integers integers sum-square)))
  (define (iter p)
    (let* ((c1 (stream-car p))
           (c2 (stream-car (stream-cdr p)))
           (c3 (stream-car (stream-cdr (stream-cdr p)))))
      (if (= (sum-square c1) (sum-square c2) (sum-square c3))
        (cons-stream (list (sum-square c1) c1 c2 c3) (iter (stream-cdr p)))
        (iter (stream-cdr p))
        )))
    (iter p))
  )
; そのように書ける理由、っていうのはどのようなペアによって平方数の和が生成されてるかも併記せよ、
; ってことなのかな？そう解釈して解いた
(stream-head find-n 15)
