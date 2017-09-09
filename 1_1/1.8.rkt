#lang racket
;14:48->15:14
;15:16->15:21
(require sicp)

(define (square x) (* x x))

(define (improve_cube x y)
      (printf (format "guess = ~a" y))
     (newline)
     (printf (format "x = ~a" x))
     (newline)
  (/ (+ (/ x (square y)) (* 2 y)) 3))
(define (good-enough?2 pre_guess guess x)
  (printf (format "pre_guess = ~a, guess = ~a, guess/1000 = ~a" pre_guess guess (/ guess 1000)))
  (newline)
(< (abs (- guess pre_guess)) (/ guess 1000)))

(define (cube-iter pre_guess guess x) (if (good-enough?2 pre_guess guess x)
  guess
  (cube-iter guess (improve_cube x guess) x)))

(define (cube x) (cube-iter 1.0 (improve_cube x 1.0) x))
(display (cube 8.0))
(newline)
(display (cube 3.0))
(newline)
