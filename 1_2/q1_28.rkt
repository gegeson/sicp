#lang racket
(require sicp)
(require racket/trace)
;15:01->15:47

(define (square n) (* n n))

(define (miller-rabin-test x n)
  (and (not (= x 1))
       (not (= x (- n 1)))
       (= (remainder (* x x) n) 1)))

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
        ((miller-rabin-test base m) 1)
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


;(trace expmod2)


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
(display (fermat-test2 2465))
(newline)
(display (fermat-test2 2821))
(newline)
(display (fermat-test2 6601))
(newline)
