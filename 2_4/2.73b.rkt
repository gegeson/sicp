#lang racket/load
(require sicp)
(require racket/trace)
(require "2_4/2.4.3lib.rkt")
;derivパッケージ関係はコピペ

;10:01->10:13
;10:16->10:26
;10:30->10:39

;これと同じ機能を目指す
;(define (deriv exp var)
;  (cond ((number? exp) 0)
;        ((variable? exp) (if (same-variable? exp var) 1 0))
;        ((sum? exp)
;         (make-sum (deriv (addend exp) var)
;                   (deriv (augend exp) var)))
;        ((product? exp)
;         (make-sum
;           (make-product (multiplier exp)
;                         (deriv (multiplicand exp) var))
;           (make-product (deriv (multiplier exp) var)
;                         (multiplicand exp))))
;        (else (error "unknown expression type -- DERIV" exp))))

(define (variable? x) (symbol? x))
(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

(define (install-deriv-package)
  (define (addend s) (car s))

  (define (augend s)
    (if (< (length (cdr s)) 2)
        (cadr s)
        (cons '+ (cdr s))))

  (define (multiplier p) (car p))

  (define (multiplicand p)
    (if (< (length (cdr p)) 2)
        (cadr p)
        (cons '* (cdr p))))

  (define (make-sum a1 a2)
    (cond ((=number? a1 0) a2)
          ((=number? a2 0) a1)
          ((and (number? a1) (number? a2)) (+ a1 a2))
          (else (list '+ a1 a2))))

  (define (=number? exp num)
    (and (number? exp) (= exp num)))

  (define (make-product m1 m2)
    (cond ((or (=number? m1 0) (=number? m2 0)) 0)
          ((=number? m1 1) m2)
          ((=number? m2 1) m1)
          ((and (number? m1) (number? m2)) (* m1 m2))
          (else (list '* m1 m2))))

  (define (deriv-sum exp var)
    (make-sum (deriv (addend exp) var)
              (deriv (augend exp) var))
    )
  (define (deriv-product exp var)

    (make-sum
     (make-product (multiplier exp)
                   (deriv (multiplicand exp) var))
     (make-product (deriv (multiplier exp) var)
                   (multiplicand exp)))
    )
  (put 'deriv '+ deriv-sum)
  (put 'deriv '* deriv-product)
  'done)

(define (deriv exp var)

   (cond ((number? exp) 0)
         ((variable? exp) (if (same-variable? exp var) 1 0))
         (else ((get 'deriv (operator exp)) (operands exp)
                                            var))))

(define (operator exp) (car exp))

(define (operands exp) (cdr exp))

(install-deriv-package)
(display (deriv '(* 3 x (+ 4 x)) 'x))
;=>(* 3 (+ x (+ 4 x)))
;簡約は出来てないが成功している模様。
(newline)
(display (deriv '(* x y 2 (+ x z)) 'x))
;=>(+ (* x (* y 2)) (* y (* 2 (+ x z))))
;同じく。
(newline)
(display (deriv '(* x y (+ x 3)) 'x))
;=>(+ (* x y) (* y (+ x 3)))
;問題なしかな？
