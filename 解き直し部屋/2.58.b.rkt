#lang debug racket
; 19:48->20:18
; 20:48->20:52
; 20:58->21:30

; 方針（思い出しながら）
; (x + 3 * (x + y + 2))
; を
; (x + (3 * (x + y + 2)))
; の形に変化させればOK
; +を探し、
; +が現れたらまず可能な範囲で+の計算をする。
; (x + 3 * (x + x) * 2)
; みたいなケースでは
; (x + (3 * (x + x) * 2))
; (x + (3 * 2 * 2))
; (3 * 2 * 2)
; のように
; *しか現れなくなった時に初めて*の計算をする
; (x + 3 * x + x + x * y)
; みたいな場合だとどうだろう
; (x + (3 * x + x + x * y))
; (x + ((3 * x) + (x + x * y)))
; (x + ((3 * x) + (x + (x * y))))
; こうなるのかな
; それぞれの括弧の一番内側で*と+の混在が無くなり、計算できる形になる
; これを実現するには、
; まず+を探し、+以前・+以降とを分ける計算ができればよい

; やり方汚いけど出来た
; 昔のを眺めると更に汚いな

;;; 最後に足す
(define (add-last x lst)
  (if (null? lst)
      (list x)
    (cons (car lst) (add-last x (cdr lst)))
    )
  )

(define (addend-and-augend exp)
;;; addendがacm
  (define (iter addend exp)
  (cond
    ((null? exp) #f)
    ((eq? '+ (car exp)) (cons addend (cdr exp)))
    (else
     (iter (add-last (car exp) addend) (cdr exp))
     )
    )
  )
  (iter '() exp))

(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp)
         (if (same-variable? exp var) 1 0))
         ((one? exp) (deriv (car exp) var))
        ((simple-sum? exp)
          (make-sum (deriv (addend exp) var)
                    (deriv (augend exp) var)))
        ((sum? exp)
         (make-sum (deriv (car (sum? exp)) var)
                   (deriv (cdr (sum? exp)) var)))
        ((product? exp)
          (make-sum
           (make-product (multiplier exp)
                         (deriv (multiplicand exp) var))
           (make-product (deriv (multiplier exp) var)
                         (multiplicand exp))))
         (else
          (error "unknown expression type -- DERIV" exp))))

;; representing algebraic expressions

(define (variable? x) (symbol? x))

(define (one? x) (and (pair? x) (= (length x) 1)))

(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

(define (simple-sum? x)
  (and (pair? x) (eq? (cadr x) '+)
       (null? (cdddr x))))

(define (sum? x)
   (addend-and-augend x))

(define (addend s) (car s))

(define (augend s) (caddr s))

(define (product? x)
  (and (pair? x) (eq? (cadr x) '*)))

(define (multiplier p) (car p))

(define (multiplicand p)
(if (null? (cdddr p))
  (caddr p)
  (cddr p)))



;: (deriv '(+ x 3) 'x)
;: (deriv '(* x y) 'x)
;: (deriv '(* (* x y) (+ x 3)) 'x)


;; With simplification

(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2)) (+ a1 a2))
        (else (list a1 '+ a2))))

(define (=number? exp num)
  (and (number? exp) (= exp num)))

(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2)) (* m1 m2))
        (else (list m1 '* m2))))

(deriv '(x + 3) 'x)
(deriv '(x * y) 'x)
(deriv '((x * y) * (x + 3)) 'x)
(deriv '(x + 3 * (x + y + 2)) 'x)
(deriv '(x + 3 * (x + x) * 2) 'x)
(deriv '(x + 3 * x + x + x * y) 'x)
(deriv '(x * 3 * x * x + x * y * y + y * x) 'x)
(deriv '(x + x + x * x * 3 * y * 5 + x * x) 'x)
(deriv '(x + 3 * x * x + x * (y + 2)) 'x)
(deriv '(x + 3 * x * x + (x + (x * x + x))) 'x)
(deriv '(x + 3 * x * x + (x + (x * (x + x) * y * x))) 'x)
(deriv '(x + 3 * x * x + (x + (x * (x + x) * y * x))) 'y)
