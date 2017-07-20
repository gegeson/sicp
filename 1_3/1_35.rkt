#lang racket
(require racket/trace)

;15:26->15:31

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
      (if (close-enough? guess next)
          next
          (try next))))
  (try first-guess))

;φ^2 = φ+1を変形して
;φ=1/φ+1
(define (golden)
  (fixed-point (lambda (x) (+ (/ 1 x) 1)) 1.0)
  )
(display (golden))
