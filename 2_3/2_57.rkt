#lang racket
(require sicp)
(require racket/trace)
; 21:47->22:19
; 22:24->
(define (square n)
  (* n n))
(define (even? n)
    (= (remainder n 2) 0))

(define (fast-expt b n)
  (cond ((= n 0) 1)
        ((even? n) (square (fast-expt b (/ n 2))))
        (else (* b (fast-expt b (- n 1))))))


(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp)
         (if (same-variable? exp var) 1 0))
        ((sum? exp)
         (make-sum (deriv (addend exp) var)
                   (deriv (augend exp) var)))
        ((product? exp)
         (make-sum
           (make-product (multiplier exp)
                         (deriv (multiplicand exp) var))
           (make-product (deriv (multiplier exp) var)
                         (multiplicand exp))))
        ((exponentiation? exp)
          (make-product (exponent exp)
                        (make-product
                         (make-exponentiation (base exp) (- (exponent exp) 1))
                         (deriv (base exp) var)))
         )
        (else
         (error "unknown expression type -- DERIV" exp))))

;; representing algebraic expressions

(define (variable? x) (symbol? x))

(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

;(define (make-sum a1 a2) (list '+ a1 a2))
;
;(define (make-product m1 m2) (list '* m1 m2))

(define (sum? x)
  (and (pair? x) (eq? (car x) '+)))

(define (addend s) (cadr s))

(define (augend s) (caddr s))

(define (product? x)
  (and (pair? x) (eq? (car x) '*)))

(define (multiplier p) (cadr p))

(define (multiplicand p) (caddr p))

(define (exponentiation? x)
  (and (pair? x) (eq? (car x) '**)))

(define (base s) (cadr s))
(define (exponent s) (caddr s))


;: (deriv '(+ x 3) 'x)
;: (deriv '(* x y) 'x)
;: (deriv '(* (* x y) (+ x 3)) 'x)


;; With simplification

;(define (make-sum a1 a2)
;  (cond ((=number? a1 0) a2)
;        ((=number? a2 0) a1)
;        ((and (number? a1) (number? a2)) (+ a1 a2))
;;        (else (list '+ a1 a2))))
;
;(define (make-sum . a_)
;    (cond
;      ((null? a_) nil)
;      ((null? (cdr a_))
;       (if (= (car a_) 0)
;         nil
;         (car a_)))
;        ((and (number? (car a_)) (number? (cadr a_)))
;         (let ((sum (+ (car a_) (cadr a_))))
;         (display sum)
;         (newline)
;              (if (= sum 0)
;                (make-sum (cdr a_))
;                (append sum (make-sum (cddr a_))))))
;      (else
;          (list '+ a_)
;      )
;    )
;  )
(define (=number? exp num)
  (and (number? exp) (= exp num)))

(define (make-sum . a_)
  (define (make-sum-iter a_ sum)
    (cond
      ((null? (cdr a_)) (+ sum (car a_)))
      ((number? (car a_)) (make-sum-iter (cdr a_) (+ (car a_) sum)))
      (else
          (list '+ sum a_)
       )
      ))
  (trace make-sum-iter)
  (make-sum-iter a_ 0)
  )
(trace make-sum)
(display (make-sum 1 2 3 4 5))


(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2)) (* m1 m2))
        (else (list '* m1 m2))))

(define (make-exponentiation base exp)
  (cond ((=number? exp 0) 1)
        ((=number? exp 1) base)
        ((and (number? base) (number? exp)) (fast-expt base exp))
    (else (list '** base exp))
    )
  )
;(trace deriv)
;(trace make-sum)
;(display (deriv '(** x 5) 'x))
;(newline)
;(display (deriv '(+ (+ (** x 2) x)  5) 'x))
;(newline)
;(display (deriv '(+ x x x) 'x))
;(newline)
;(display (deriv '(+ (** x 4) (** x 2)  5) 'x))
;(newline)
