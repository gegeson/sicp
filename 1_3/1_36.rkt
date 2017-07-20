#lang racket
(require racket/trace)

;15:32->15:42

;; Fixed points
(define (average x y)
  (/ (+ x y) 2))

(define tolerance 0.00001)

(define (close-enough? x y)
  (< (abs (- x y)) 0.001))

(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (printf (format "next = ~a" next))
      (newline)
      (if (close-enough? guess next)
          next
          (try next))))
  (try first-guess))

(define (x_x x)
  (fixed-point (lambda(x) (/ (log 1000) (log x))) 2.0))
(define (x_x2 x)
  (fixed-point (lambda(x) (average x (/ (log 1000) (log x)))) 2.0))
(define (sqrt x)
  (fixed-point (lambda (y) (average y (/ x y)))
               1.0))

(sqrt 2.0)
(x_x 1000)
(x_x2 1000)
