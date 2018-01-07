#lang racket/load
(require sicp)
(require (prefix-in strm: racket/stream))
(require "3_5_3/stream.rkt")
; 解けたけど賢い別解は思いつかなかったので復習
; 11:30->11:37
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

(define (triples s t u)
  (cons-stream
   (list (stream-car s) (stream-car t) (stream-car u))
   (interleave
    (stream-map (lambda (x)  (cons (stream-car s) x)) (stream-cdr (pairs t u)))
    (triples (stream-cdr s) (stream-cdr t) (stream-cdr u))
    )
   ))

(define (stream-head s n)
(define (iter s n)
  (if (<= n 0)
    'done
    (begin
      (display (stream-car s))
      (newline)
      (iter (stream-cdr s) (- n 1)))))
(iter s n))

(stream-head (triples integers integers integers) 10)

(define (pythagoras i j k)
  (= (+ (* i i) (* j j)) (* k k)))

(define pythagoras-stream
  (stream-filter
   (lambda (x)
           (pythagoras (car x) (cadr x) (caddr x))
           )
   (triples integers integers integers)
   )
  )

(stream-head pythagoras-stream 5)
