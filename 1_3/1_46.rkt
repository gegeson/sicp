#lang racket
(require racket/trace)
; 14:58->15:24

;; Newton's method


(define (deriv g)
  (lambda (x)
    (/ (- (g (+ x dx)) (g x))
       dx)))
(define dx 0.00001)

(define (square x) (* x x))

(define (cube x) (* x x x))

;: ((deriv cube) 5)
;
;(define (newton-transform g)
;  (lambda (x)
;    (- x (/ (g x) ((deriv g) x)))))
;
;(define (newtons-method g guess)
;  (fixed-point (newton-transform g) guess))
;
(define tolerance 0.00001)
;
;(define (sqrt1 x)
;  (newtons-method (lambda (y) (- (square y) x))
;                  1.0))

;(define (fixed-point f first-guess)
;  (define (close-enough? v1 v2)
;    (< (abs (- v1 v2)) tolerance))
;  (define (try guess)
;    (let ((next (f guess)))
;      (if (close-enough? guess next)
;          next
;          (try next))))
;  (try first-guess))

  (define (average x y)
    (/ (+ x y) 2))

(define (average-damp f)
  (lambda (x) (average x (f x))))

(define (iterative-improve judge improve)
  (define iterative-improve-iter
    (lambda (guess)
            (cond
              ((judge guess (improve guess)) guess)
              (else
               (iterative-improve-iter (improve guess))
               )
              )
            ))
  (trace iterative-improve-iter)
  iterative-improve-iter
  )

(define (fixed-point2 f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  ((iterative-improve close-enough? f) first-guess))

;
;(define (fixed-point-of-transform g transform guess)
;  (fixed-point (transform g) guess))

(define (fixed-point-of-transform2 g transform guess)
  (fixed-point2 (transform g) guess))

(define (sqrt2_2 x)
  (fixed-point-of-transform2 (lambda (y) (/ x y))
                            average-damp
                            1.0))

(display (sqrt2_2 2.0))
(newline)
(define (sqrt1_2 x)
  (define (improve guess)
    (average guess (/ x guess)))
  (define (good-enough?2 pre_guess guess)
    (< (abs (- guess pre_guess)) (/ guess 1000)))
  ((iterative-improve good-enough?2 improve) 1.5))

(display (sqrt1_2 2.0))
(newline)
(display (fixed-point2 cos 1.0))
(newline)
(display (fixed-point2 (lambda (y) (+ (sin y) (cos y)))
             1.0))
