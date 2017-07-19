#lang racket
(require racket/trace)
;22:44->22:48
(define (sum term a next b)
  (if (> a b)
    0
    (+ (term a)
       (sum term (next a) next b))
    )
  )
(define (pi-sum a b)
  (define (pi-term x)
  (/ 1.0 (* x (+ x 2))))
  (define (pi-next x)
  (+ x 4))
(sum pi-term a pi-next b))
(define (pi-sum2 a b)
  (define (pi-term x)
  (/ 1.0 (* x (+ x 2))))
  (define (pi-next x)
  (+ x 4))
(sum2 pi-term a pi-next b))

(define (sum2 term a next b)
  (define (iter a result)
    (if (> a b)
        result
    (iter (next a) (+ (term a) result))))
  (iter a 0))

(display (* 8 (pi-sum 1 1000)))
(newline)
(display (* 8 (pi-sum2 1 1000)))
