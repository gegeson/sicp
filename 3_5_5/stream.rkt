#lang racket
(require sicp)
(require (prefix-in strm: racket/stream))

(define-syntax cons-stream
  (syntax-rules ()
    ((_ a b) (strm:stream-cons a b))))
(define stream-car strm:stream-first)
(define stream-cdr strm:stream-rest)
(define stream-null? strm:stream-empty?)
(define the-empty-stream strm:empty-stream)


;; form ex 3.50
(define (stream-map proc . argstreams)
  (if (stream-null? (car argstreams))
      the-empty-stream
      (cons-stream
       (apply proc (map stream-car argstreams))
       (apply stream-map
              (cons proc (map stream-cdr argstreams))))))

(define (stream-enumerate-interval low high)
  (if (> low high)
      the-empty-stream
      (cons-stream
       low
       (stream-enumerate-interval (+ low 1) high))))

(define (stream-filter pred stream)
  (cond ((stream-null? stream) the-empty-stream)
        ((pred (stream-car stream))
         (cons-stream (stream-car stream)
                      (stream-filter pred
                                     (stream-cdr stream))))
        (else (stream-filter pred (stream-cdr stream)))))

(define (stream-for-each proc s)
  (if (stream-null? s)
      'done
      (begin (proc (stream-car s))
             (stream-for-each proc (stream-cdr s)))))

(define (display-stream s)
  (stream-for-each display-line s))

(define (display-line x)
  (newline)
  (display x))

(define (list->stream sequence)
  (if (null? sequence)
      the-empty-stream
      (cons-stream (car sequence)
                   (list->stream (cdr sequence)))))

(define (stream-ref s n)
 (if (= n 0)
     (stream-car s)
     (stream-ref (stream-cdr s) (- n 1))))

(define (display-s s from to)
    (map (lambda (i) (display (stream-ref s i)) (newline))
                     (enumerate-interval from to)))

(define (enumerate-interval low high)
 (if (> low high)
     nil
     (cons low (enumerate-interval (+ low 1) high))))

(define (add-streams s1 s2) (stream-map + s1 s2))

(define (scale-stream stream factor)
  (stream-map (lambda (x) (* x factor)) stream))

(define ones (cons-stream 1 ones))

(define integers
  (cons-stream 1 (add-streams ones integers)))

  (define (stream-head s n)
    (define (iter s n)
      (if (<= n 0)
        'done
        (begin
          (display (stream-car s))
          (newline)
          (iter (stream-cdr s) (- n 1)))))
    (iter s n))

(provide (all-defined-out))
