#lang racket
(require sicp)
(require racket/trace)

(define (square n) (* n n))
;; fast-prime?

(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder (square (expmod base (/ exp 2) m))
                    m))
        (else
         (remainder (* base (expmod base (- exp 1) m))
                    m))))

(define (fermat-test n)
  (define (try-it a)
    (= (expmod a n n) a))
  (try-it (+ 1 (random (- n 1)))))

(define (fast-prime? n times)
  (cond ((= times 0) true)
        ((fermat-test n) (fast-prime? n (- times 1)))
        (else false)))

;561, 1105, 1729, 2465, 2821, 6601

(define (carm-test-iter n a)
  (cond ((= n a) true)
        (else
          (and (= (expmod a n n) a) (carm-test-iter n (+ a 1)))
         )
      )
  )
(define (carm-test n)
  (carm-test-iter n 0)
  )
;(trace carm-test-iter)
(display (carm-test 561))
(newline)
(display (carm-test 13))
(newline)
(display (carm-test 14))
(newline)
(display (carm-test 1105))
(newline)
(display (carm-test 1729))
(newline)
(display (carm-test 2465))
(newline)
(display (carm-test 2821))
(newline)
(display (carm-test 6601))
(newline)
