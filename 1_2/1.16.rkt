#lang racket
(require racket/trace)
;q1_16->q1_18リトライ
(define (square n)
  (* n n))
(define (even? n)
    (= (remainder n 2) 0))

;21:07->21:27

(define (fast-expt-iter a b n)
  (cond
    ((= n 0) a)
    ((even? n) (fast-expt-iter a (square b) (/ n 2)))
    (else
      (fast-expt-iter (* a b) b (- n 1))
      )
    )
  )
(define (fast-expt b n)
    (fast-expt-iter 1 b n)
  )
(display (fast-expt 2 10))


(define (double a)
  (+ a a ))
(define (halve n)
    (/ n 2)
  )

(define (fast* a b)
  (cond
    ((= b 0) 0)
    ((even? b) (double (fast* a (halve b))))
    (else (+ a (fast* a (- b 1))))
    )
  )
(trace fast*)
(newline)
(display (fast* 312 1830))

(define (fast2*-iter product a b)
    (cond
      ((= b 0) product)
      ((even? b) (fast2*-iter product (double a) (halve b)))
      (else (fast2*-iter (+ product a) a (- b 1)))
      )
  )

(define (fast2* a b)
  (fast2*-iter 0 a b))
(newline)
(trace fast2*-iter)
(fast2* 312 1830)
