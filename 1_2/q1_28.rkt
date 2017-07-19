#lang racket
(require sicp)
(require racket/trace)
;15:01->15:47

(define (square n) (* n n))

(define (square-check-2 x n)
  (and (not (= x 1))
       (not (= x (- n 1)))
       (= (remainder (* x x) n) 1)))

(define (square-check-1 x n)
    (if (square-check-2 x n)
      0
      (remainder (* x x) n))
  )

(define (fermat-test2 n i)
  (define (try-it a)
  (let ((result (expmod a n n)))
      (cond
        ((= result 0) false)
        (else (= result a))
      )
  ))
  (if (= i n)
    true
    (and (try-it i) (fermat-test2 n (+ i 1)))))

(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (square-check-1 (expmod base (/ exp 2) m)
                    m))
        (else
         (remainder (* base (expmod base (- exp 1) m))
                    m))))


(trace expmod)
;(trace square-check-1)


(define (ftest n)
    (fermat-test2 n 2)
  )

(display (ftest 13))
(newline)
(display (ftest 14))
(newline)
(display (ftest 15))
(newline)
(display (ftest 16))
(newline)
(display (ftest 17))
(newline)
(display (ftest 561))
(newline)
(display (ftest 1105))
(newline)
(display (ftest 1729))
(newline)
(display (ftest 2465))
(newline)
(display (ftest 2821))
(newline)
(display (ftest 6601))
(newline)
