#lang racket/load
(require sicp)
(require (prefix-in strm: racket/stream))
(require "3_5_3/stream.rkt")
; 10:50->11:26
; 13:45->13:55
(define (average x y) (/ (+ x y) 2))

(define (square x) (* x x))

(define (sqrt-improve guess x)
  (average guess (/ x guess)))

(define (sqrt-stream x)
  (define guesses
    (cons-stream
     1.0
     (stream-map (lambda (guess) (sqrt-improve guess x))
                 guesses)))
  guesses)

; (display-stream (sqrt-stream 2))

(define (partial-sums s)
  (cons-stream (stream-car s)
               (add-streams (stream-cdr s) (partial-sums s))))


; 賢いコードだなあ。まさに無限ストリームって感じ
(define (pi-summands n)
  (cons-stream (/ 1.0 n)
                (stream-map - (pi-summands (+ n 2)))))

(define pi-stream
  (scale-stream (partial-sums (pi-summands 1)) 4))

; (display-stream pi-stream)

(define (euler-transform s)
  (let ((s0 (stream-ref s 0))
        (s1 (stream-ref s 1))
        (s2 (stream-ref s 2)))
    (cons-stream (- s2 (/ (square (- s2 s1))
                          (+ s0 (* -2 s1) s2)))
                 (euler-transform (stream-cdr s)))))

(display-stream (euler-transform pi-stream))

(define (make-tableau transform s)
  (cons-stream s (make-tableau transform (transform s))))

(define (accelerated-sequence transform s)
  (stream-map stream-car (make-tableau transform s)))

(display-stream
 (accelerated-sequence euler-transform pi-stream))

; 超加速ぱないなど

; -----------------------

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
  (stream-map (lambda (x) (list (stream-car s) x)))
  (pairs (stream-cdr s) (stream-cdr t)))))
