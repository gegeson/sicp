#lang racket/load
(require sicp)
(require (prefix-in strm: racket/stream))
(require "3_5_3/stream.rkt")

; 失敗作の供養

(define (<= a b)
  (or (< a b) (= a b)))

; 失敗作1
(define (triples-failed s t u)
  (let ((p (pairs t u)))
    (define (iter s p)
     (cons-stream
      (cons (stream-car s) (stream-car p))
      (interleave
       (stream-map (lambda (x) (if (<= (stream-car s) (car x))
                                 (cons (stream-car s) x)
                                 nil)) (stream-cdr p))
       (iter (stream-cdr s) (stream-cdr p)))))
    (iter s p)))

; 失敗作2
(define (triples-failed2 s t u)
  (let ((p1 (pairs s t))
        (p2 (pairs t u)))
    (define (iter p1 p2)
      (if (= (cadr (stream-car p1)) (car (stream-car p2)))
        (begin (printf "~a ~a \n"  (stream-car p1)  (stream-car p2))
        (cons-stream (cons (car (stream-car p1)) (stream-car p2))
                     (iter (stream-cdr p2) p1)
                     ))
        (iter (stream-cdr p2) p1)
        )
      )
    (iter p1 p2))
  )

; 失敗作3
; n = 6で重複する、
; n > 7で無限ループする
(define (triples-failed3 s t u)
  (let ((p1 (pairs s t))
        (p2 (pairs t u)))
    (define (iter p1 p2)
               (if (= (cadr (stream-car p1)) (car (stream-car p2)))
                        (cons-stream (cons (car (stream-car p1)) (stream-car p2))
                                     (interleave (iter p1 (stream-cdr p2))
                                                 (iter (stream-cdr p1) (stream-cdr p2))))
                 (interleave (iter p1 (stream-cdr p2))
                             (iter (stream-cdr p1) (stream-cdr p2))))

        )
    (iter p1 p2)))
