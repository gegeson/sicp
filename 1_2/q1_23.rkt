#lang racket
(require sicp)
(require racket/trace)
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
(define (next n)
  (if (= n 0)
    3
    (+ n 2))
  )

(define (find-divisor2 n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor2 n (next test-divisor)))))

(define (smallest-divisor2 n)
  (find-divisor2 n 2))

(define (prime?2 n)
(= n (smallest-divisor2 n)))

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
    (if (prime?2 n)
        (report-prime (- (runtime) start-time))
      )
    )
(define (report-prime elapsed-time)
  (display "***")
  (display elapsed-time))
;
(timed-prime-test 2147483647)
(timed-prime-test2 2147483647)
(timed-prime-test 92709568269121)
(timed-prime-test2 92709568269121)

; find-divisorは（condの条件3つなので）3ステップで1進む
; find-divisor2は(condの条件に加えてnextの条件4つなので)4ステップで2進む
; √nに届く値がmとすると
; 1. m*3 = 3m
; 2. m/2 * 4 = 2m
;となり、 2は3の1.5倍速い
;これは観測に一致する。
;(trace find-divisor)
;(trace find-divisor2)
;(timed-prime-test 17)
;(timed-prime-test2 17)
