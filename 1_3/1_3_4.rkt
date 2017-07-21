#lang racket
(require racket/trace)
; 11:35->

;; Newton's method


(define (deriv g)
  (lambda (x)
    (/ (- (g (+ x dx)) (g x))
       dx)))
(define dx 0.00001)

(define (square x) (* x x))

(define (cube x) (* x x x))

;: ((deriv cube) 5)

(define (newton-transform g)
  (lambda (x)
    (- x (/ (g x) ((deriv g) x)))))

(define (newtons-method g guess)
  (fixed-point (newton-transform g) guess))

(define tolerance 0.00001)

(define (sqrt1 x)
  (newtons-method (lambda (y) (- (square y) x))
                  1.0))

(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
          next
          (try next))))
  (try first-guess))

  (define (average x y)
    (/ (+ x y) 2))

(define (average-damp f)
  (lambda (x) (average x (f x))))

;; Fixed point of transformed function

(define (fixed-point-of-transform g transform guess)
  (fixed-point (transform g) guess))

(define (sqrt2 x)
  (fixed-point-of-transform (lambda (y) (/ x y))
                            average-damp
                            1.0))

(define (sqrt3 x)
  (fixed-point-of-transform (lambda (y) (- (square y) x))
                            newton-transform
                            1.0))

(display (sqrt1 2.0))
(newline)
(display (sqrt2 2.0))
(newline)
(display (sqrt3 2.0))
(newline)

(define (cubic a b c)
    (lambda (x)
      (+ (cube x) (* a (square x)) (* b x) c)
    )
  )
(newtons-method (cubic 3 3 1) 1)
(define (inc x) (+ x 1))
(define double
  (lambda (f)
          (lambda (x)
                  (f (f x))
                  )))
(display (((double double) inc) 1))
(newline)
(display ((double ((double double) inc)) 1))
(newline)
;((d d) inc)
;= x->(d d x) inc
;= x->(d d inc)
;= (d (x->(inc (inc x))))
;= (x-> (x->(inc (inc x))) ((x->(inc (inc x))) x)
;= (x-> (inc (inc ((x->(inc (inc x))) x))))
;= (x-> (inc (inc (inc (inc x)))))
;4回足すことになる。
;同じ流れで、
;(d ((d d) inc))
;は、
;(d (x-> (inc (inc (inc (inc x))))))
;= x -> (x-> (inc (inc (inc (inc x)))) ((x-> (inc (inc (inc (inc x))))) x))
;= x -> (x-> (inc (inc (inc (inc x)))) ((inc (inc (inc (inc x)))) )
;= x -> (x-> (inc (inc (inc (inc (inc (inc (inc (inc x)))))))))
;= x -> (inc (inc (inc (inc (inc (inc (inc (inc x))))))))
;で、8回足すことになる。
