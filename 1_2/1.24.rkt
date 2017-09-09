#lang racket
(require sicp)
(require racket/trace)


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

(define (square x) (* x x))
;; prime?

(define (smallest-divisor n)
  (find-divisor n 2))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))))

(define (divides? a b)
  (= (remainder b a) 0))

(define (prime? n)
  (= n (smallest-divisor n)))

(define (timed-prime-test n)
    (newline)
    (display n)
    (start-prime-test n (runtime))
  )
(define (start-prime-test n start-time)
  (if (prime? n)
      (report-prime (- (runtime) start-time))
    )
  )

(define (timed-prime-test2 n)
    (newline)
    (display n)
    (start-prime-test2 n (runtime))
  )
(define (start-prime-test2 n start-time)
  (if (fast-prime? n 10)
      (report-prime (- (runtime) start-time))
    )
  )
(define (report-prime elapsed-time)
  (display "***")
  (display elapsed-time))

(timed-prime-test 1009)
(timed-prime-test 1013)
(timed-prime-test 1019)
(timed-prime-test 10007)
(timed-prime-test 10009)
(timed-prime-test 10037)
(timed-prime-test 100003)
(timed-prime-test 100019)
(timed-prime-test 100043)
(timed-prime-test 1000003)
(timed-prime-test 1000033)
(timed-prime-test 1000037)

(timed-prime-test2 1009)
(timed-prime-test2 1013)
(timed-prime-test2 1019)
(timed-prime-test2 10007)
(timed-prime-test2 10009)
(timed-prime-test2 10037)
(timed-prime-test2 100003)
(timed-prime-test2 100019)
(timed-prime-test2 100043)
(timed-prime-test2 1000003)
(timed-prime-test2 1000033)
(timed-prime-test2 1000037)
