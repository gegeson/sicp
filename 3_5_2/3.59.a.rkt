#lang racket/load
(require sicp)
(require (prefix-in strm: racket/stream))
(require "3_5_2/stream.rkt")
; 13:39->13:47

(define ones (cons-stream 1 ones))

(define twos (cons-stream 2 twos))

(define integers
  (cons-stream 1 (add-streams ones integers)))

(define (quotient-streams s1 s2)
  (stream-map / s1 s2))

(define (integrate-series sa)
  (quotient-streams sa integers))

(define (stream-head s n)
  (define (iter s n)
    (if (<= n 0)
      'done
      (begin
        (display (stream-car s))
        (display ", ")
        (iter (stream-cdr s) (- n 1)))))
  (iter s n))

(stream-head (integrate-series ones) 10)
(newline)
(stream-head (integrate-series twos) 10)
