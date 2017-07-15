#lang racket
(require racket/trace)

;11:40->11:47
(define (cube x) (* x x x))

(define (p x) (- (* 3 x) (* 4 (cube x))))

(define (sine angle)
(if (not (> (abs angle) 0.1)) angle
(p (sine (/ angle 3.0)))))
(trace sine)
(sine 12.15)
