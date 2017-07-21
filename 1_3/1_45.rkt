#lang racket
(require racket/trace)
; 14:06->14:32
(define (square x) (* x x))
(define (inc x) (+ x 1))


(define (deriv g)
  (lambda (x)
    (/ (- (g (+ x dx)) (g x))
       dx)))
(define dx 0.00001)

(define (cube x) (* x x x))

;: ((deriv cube) 5)

(define (newton-transform g)
  (lambda (x)
    (- x (/ (g x) ((deriv g) x)))))

(define (newtons-method g guess)
  (fixed-point (newton-transform g) guess))

(define tolerance 0.00001)

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

(define (compose f g) (lambda (x) (f (g x))))
(define (repeated f n)
    (define (repeated-iter i)
        (if (= i n)
            (lambda (x) (f x))
            (compose f (repeated-iter (+ i 1)))
          )
      )
      (repeated-iter 1)
  )


(define (sqrt x)
  (fixed-point-of-transform (lambda (y) (/ x y))
                            average-damp
                            1.0))
(define (cbrt x)
  (fixed-point-of-transform (lambda (y) (/ x (* y y)))
                            average-damp
                            1.0))
(define (_4rt x)
  (fixed-point-of-transform (lambda (y) (/ x (* y y y)))
                            (repeated average-damp 2)
                            1.0))
(define (_5rt x)
  (fixed-point-of-transform (lambda (y) (/ x (* y y y y)))
                            (repeated average-damp 2)
                            1.0))
(define (_6rt x)
  (fixed-point-of-transform (lambda (y) (/ x (* y y y y y)))
                            (repeated average-damp 2)
                            1.0))
(define (_7rt x)
  (fixed-point-of-transform (lambda (y) (/ x (* y y y y y y)))
                            (repeated average-damp 2)
                            1.0))
(define (_8rt x)
  (fixed-point-of-transform (lambda (y) (/ x (* y y y y y y y)))
                            (repeated average-damp 3)
                            1.0))

(define (_9rt x)
  (fixed-point-of-transform (lambda (y) (/ x (* y y y y y y y y)))
                            (repeated average-damp 3)
                            1.0))

(define (_10rt x)
  (fixed-point-of-transform (lambda (y) (/ x (* y y y y y y y y y)))
                            (repeated average-damp 3)
                            1.0))
(define (_15rt x)
  (fixed-point-of-transform (lambda (y) (/ x (* y y y y y y y y y y y y y y)))
                            (repeated average-damp 3)
                            1.0))
(define (_16rt x)
  (fixed-point-of-transform (lambda (y) (/ x (* y y y y y y y y y y y y y y y)))
                            (repeated average-damp 4)
                            1.0))

(display (sqrt 2))
(newline)
(display (cbrt 8))
(newline)
(display (_4rt 16))
(newline)
(display (_5rt 32))
(newline)
(display (_6rt 64))
(newline)
(display (_7rt 128))
(newline)
(display (_8rt 256))
(newline)
(display (_9rt 512))
(newline)
(display (_10rt 1024))
(newline)
(display (_15rt 32768))
(newline)
(display (_16rt 65536))
;
;これらの実験結果より、
;求めるn乗根が2^m<=n<2^(m+1)の時、
;m回average-dampを繰り返せばよい、と考えられる
;この時、(truncate (log n)) == mになる

(define (fast-expt b n)
  (cond ((= n 0) 1)
        ((even? n) (square (fast-expt b (/ n 2))))
        (else (* b (fast-expt b (- n 1))))))

(define (n_rt x n)
  (fixed-point-of-transform (lambda (y) (/ x (fast-expt y (- n 1))))
                            (repeated average-damp (truncate (log n)))
                        1.0))
(display (n_rt 32768 15))
(newline)
(display (n_rt 65536 16))
(newline)
;(display (n_rt 161051 5))
;(newline)
