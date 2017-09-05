#lang racket
(require sicp)
(require racket/trace)
; 21:47->22:19(2_56)

;(2.57 sum)
; 22:24->0:06
; 10:30->11:08
; 11:27->12:06
; 12:12->12:36
; 13:55->14:20
;(2.57 sum)
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

(define (augend s)
  (if (< (length (cddr s)) 2)
      (caddr s)
      (cons '+ (cddr s))))


(define (product? x)
  (and (pair? x) (eq? (car x) '*)))

(define (multiplier p) (cadr p))

(define (multiplicand p) (caddr p))

(define (exponentiation? x)
  (and (pair? x) (eq? (car x) '**)))

(define (base s) (cadr s))
(define (exponent s) (caddr s))




(define (=number? exp num)
  (and (number? exp) (= exp num)))


;シンプルかつ正しい版
(define (make-sum a . a_)
  (cond
      ((=number? a 0) (car a_))
      ((=number? (car a_) 0) a)
    ((and (number? a) (number? (car a_)) (+ a (car a_))))
    (else (list '+ a (car a_)))
    )
  )

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

;これ（下のmake-sum）でも一応正しく動くが、不必要に複雑。
  ;(define (make-sum . a_)
  ;  (define (make-sum-iter a_ sum)
  ;  ;(display "a_ is ") (display a_)(newline)
  ;  ;(display "sum is ") (display sum)(newline)
  ;    (cond
  ;      ((null? a_) sum)
  ;      ((and (= (length a_) 1) (number? (car a_))) (+ sum (car a_)))
  ;      ((and (null? (cdr a_)) (number? (car a_)))
  ;        (+ sum (car a_)))
  ;      ((null? (cdr a_)) (car a_))
  ;      ((number? (car a_))
  ;       (make-sum-iter (cdr a_) (+ (car a_) sum)))
  ;      (else
  ;       (if (= sum 0)
  ;         (cons '+ a_ )
  ;         (list sum a_))
  ;       )
  ;      ))
  ;  ;(display "ビフォー a_ ") (display a_) (newline)
  ;  ;(display "ここからmake-sum-iter ")(newline)
  ;   (make-sum-iter  (elim_zero a_) 0)
  ;  )
  ;
  ;(define (elim_zero lst)
  ;    (cond
  ;      ((null? lst) nil)
  ;      ((equal? (car lst) 0) (elim_zero (cdr lst)))
  ;      (else
  ;        (cons (car lst) (elim_zero (cdr lst)))
  ;       )
  ;      )
  ;  )
;(trace deriv)
;(trace make-sum)
;(display (deriv '(** x 5) 'x))
;(newline)
(display (deriv '(+ (+ (** x 2) x)  5) 'x))
(newline)
(display (deriv '(+ u (* x 5) y z) 'x))
(newline)
(display (deriv '(+ (** x 4) (** x 2)  5) 'x))
(newline)
(display (deriv '(+ y z (** x 4) u (** x 3) v (** x 2)  5) 'x))
(newline)
(display (deriv '(+ (* 4 (** x 3)) (+ (* 3 (** x 2)) (* 2 x))) 'x))
(newline)
(display (deriv '(+ x x x z x y) 'x))


;正しい結果
;(+ (* 2 x) 1)
;5
;(+ (* 4 (** x 3)) (* 2 x))
;(+ (* 4 (** x 3)) (+ (* 3 (** x 2)) (* 2 x)))
;(+ (* 4 (* 3 (** x 2))) (+ (* 3 (* 2 x)) 2))
;4

;ゴミ置き場（失敗作）
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
