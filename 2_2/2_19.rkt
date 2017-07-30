#lang racket
(require racket/trace)

;(define (count-change amount)
;  (cc amount 5))
;
;(define (cc amount kinds-of-coins)
;  (cond ((= amount 0) 1)
;        ((or (< amount 0) (= kinds-of-coins 0)) 0)
;        (else (+ (cc amount
;                     (- kinds-of-coins 1))
;                 (cc (- amount
;                        (first-denomination kinds-of-coins))
;                     kinds-of-coins)))))
;
;(define (first-denomination kinds-of-coins)
;  (cond ((= kinds-of-coins 1) 1)
;        ((= kinds-of-coins 2) 5)
;        ((= kinds-of-coins 3) 10)
;        ((= kinds-of-coins 4) 25)
;        ((= kinds-of-coins 5) 50)))

;; EXERCISE 2.19
;(define us-coins (list 50 25 10 5 1))
(define us-coins (list 1 5 10 25 50))

(define uk-coins (list 100 50 20 10 5 2 1 0.5))

(define coins (list 5 1))

(define first-denomination car)
(define except-first-denomination cdr)
(define no-more? null?)

(define (cc amount coin-values)
  (cond ((= amount 0) 1)
        ((or (< amount 0) (no-more? coin-values)) 0)
        (else
         (+ (cc amount
                (except-first-denomination coin-values))
            (cc (- amount
                   (first-denomination coin-values))
                coin-values)))))

;(cc 100 us-coins)
(trace cc)
(cc 7 coins)
(cc 7 (list 1 5))

10円を
(5, 1)で
=10円を(1)で→1通り
+5円を(5, 1)で→2通り

10円を(1, 5)で
=10円を(5)で→1通り
+9円を(1, 5)で→2通り
