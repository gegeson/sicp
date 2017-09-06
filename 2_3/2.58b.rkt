#lang racket
(require sicp)
(require racket/trace)
;http://d.hatena.ne.jp/awacio/20100803/1280843906
;にてヒントを参照（プログラムは読んでないが、どう解くかを参考にした）

;問題では問われていないが、簡単なので ** も括弧無しで扱えるようにした
;23:00->23:11 a

;b
;23:16->0:11
;0:16->0:38
;8:11->8:30 8:33->9:33 b
;+5 **

(define (square n)
  (* n n))
(define (even? n)
    (= (remainder n 2) 0))

(define (fast-expt b n)
  (cond ((= n 0) 1)
        ((even? n) (square (fast-expt b (/ n 2))))
        (else (* b (fast-expt b (- n 1))))))


(define (deriv exp var)
  ;(display "exp is ")(display exp)(newline)
  (cond ((number? exp) 0)
        ((variable? exp)
         (if (same-variable? exp var) 1 0))
        ((sum? exp)
        ; (display "this is sum ")(display exp)(newline)
         (make-sum (deriv (addend exp) var)
                   (deriv (augend exp) var)))
        ((product? exp)
        ; (display "this is product ")(display exp)(newline)
         (make-sum
           (make-product (multiplier exp)
                         (deriv (multiplicand exp) var))
           (make-product (deriv (multiplier exp) var)
                         (multiplicand exp))))
        ((exponentiation? exp)
        ; (display "this is exponentiation ")(display exp)(newline)
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


(define (sum? x)
  (cond
    ((null? x) #f)
    ((eq? (car x) '+) #t)
    (else
      (sum? (cdr x))
     )
    )
  )

(display (sum? '(1 + 2 + 3)))
(newline)
(display (sum? '(1 * 2 + 3)))
(newline)
(display (sum? '(1 * 2 * 3)))


(define (addend s)
  (define (addend-iter s)
    (cond
      ((null? s) nil)
      ((eq? (car s) '+) nil)
      (else
       (cond
         ((pair? (car s))
          (append (car s) (addend-iter (cdr s))))
         (else
          (append (cons (car s) nil) (addend-iter (cdr s))))
         )
       )
      ))
  (if (= 1 (length (addend-iter s)))
    (car (addend-iter s))
    (addend-iter s)
    )
  )
;(trace addend)
(newline)
(display (addend '(1 + 2 + 3)))
(newline)
(display (addend '(1 * 2 + 3)))
(newline)
(display (addend '(1 * 2 * 3 * 4 + 5 * 6 + 7)))
(newline)
(display (addend '(((1 + 2) * 3 * 4) + 5 * 6 + 7)))
(newline)


(define (augend s)
  (define (augend-iter s)
    (cond
      ((null? s) nil)
      ((eq? (car s) '+) (cdr s))
      (else
       (augend-iter (cdr s))
       )
      ))
  (if (= (length (augend-iter s)) 1)
      (car (augend-iter s))
      (augend-iter s)
    )
  )

(display (augend '(1 + 2 + 3)))
(newline)
(display (augend '(1 * 2 + 3)))
(newline)
(display (augend '(1 * 2 * 3 * 4 + 5 * 6 + 7)))
(newline)


(define (product? x)
  (define (product-iter x)
    (cond
      ((null? x) #t)
      ((eq? (car x) '+) #f)
      (else (product-iter (cdr x)))
      ))
  (define (product-iter2 x)
      (cond
        ((null? x) #f)
        ((eq? (car x) '*) #t)
        (else (product-iter2 (cdr x)))
        )
    )
  (and (> (length x) 2) (product-iter x) (product-iter2 x))
  )


(display (product? '(1 + 2 + 3)))
(newline)
(display (product? '(1 * 2 + 3)))
(newline)
(display (product? '(1 * 2 * 3)))

(define (multiplier p)
  (define (multiplier-iter p)
    (cond
      ((null? p) nil)
      ((eq? (car p) '*) nil)
      (else
       (if (pair? (car p))
         (append (car p) (multiplier-iter (cdr p)))
         (append (cons (car p) nil) (multiplier-iter (cdr p)))
         )
       )
      ))
      (if (= 1 (length (multiplier-iter p)))
        (car (multiplier-iter p))
        (multiplier-iter p)
        ))


(display (multiplier '(1 * 2 + 3)))
(newline)
(display (multiplier '(((1 * 2) * 3) * 4 + 5 * 6 + 7)))
(newline)

(define (multiplicand p)
  (define (multiplicand-iter p)
    (cond
      ((null? p) nil)
      ((eq? (car p) '*) (cdr p))
      (else
       (multiplicand-iter (cdr p))
       )
      ))
  (if (= (length (multiplicand-iter p)) 1)
    (car (multiplicand-iter p))
    (multiplicand-iter p)))

(display (multiplicand '(1 * 2 + 3)))
(newline)
(display (multiplicand '(1 * 2 * 3 * 4 + 5 * 6 + 7)))
(newline)

(define (exponentiation? x)
  (define (exponentiation-iter x)
  (cond
    ((null? x) #t)
    ((eq? (car x) '+) #f)
    ((eq? (car x) '*) #f)
    (else (exponentiation-iter (cdr x)))
    ))
    (and (> (length x) 2) (exponentiation-iter x))
    )

(define (base s) (car s))
(define (exponent s)
  (if (> (length s) 3)
    (cddr s)
    (caddr s)))

(define (=number? exp num)
  (and (number? exp) (= exp num)))

(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2)) (+ a1 a2))
        (else (list a1 '+ a2))))

(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2)) (* m1 m2))
        (else (list m1 '* m2))))

(define (make-exponentiation base exp)
  (cond ((=number? exp 0) 1)
        ((=number? exp 1) base)
        ((and (number? base) (number? exp)) (fast-expt base exp))
    (else (list base '** exp))
    )
  )
;(trace deriv)
(display (deriv '(((x ** 2) + x) + 5) 'x))
(newline)
(display (deriv '(u + (x * 5) + y + z) 'x))
(newline)
(display (deriv '(x + 4 * 3 * (x + y + 2)) 'x))
(newline)
(display (deriv '((x + y) + (x + (x + z) + x)) 'x))
(newline)
(display (deriv '(x + (3 * ((x * x) + (x * (y + 2))))) 'x))
(newline)
(display (deriv '(x * y * (x + 3)) 'x))
(newline)
(display (deriv '(2 * 4 * x ** 2 + 3 * 4 * 5 * x + 5) 'x))
(newline)
(display (deriv '(x ** 2 + 2 * x + 3 * 4 * x + 5) 'x))
(newline)
(display (deriv '(x ** 2 + x * 3) 'x))
(newline)
(display (deriv '(x * 3 + x ** 2) 'x))
(newline)
(display (deriv '(x + 2 * x ** 2 + x * 3) 'x))
(newline)
(display (deriv '(2 * x ** 2 + x + x * 3) 'x))
(newline)
(display (deriv '(x ** 4 + x ** 2 + 5) 'x))
(newline)
(display (deriv '(y + z + x ** 4 + u + x ** 3 + v + x ** 2 + 5) 'x))
(newline)
