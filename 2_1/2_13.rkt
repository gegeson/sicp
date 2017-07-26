#lang racket
(require racket/trace)
; 20:35->21:11
(define (make-interval a b) (cons a b))
(define (upper-bound interval) (car interval))
(define (lower-bound interval) (cdr interval))
(define (add-interval x y)
  (make-interval (+ (lower-bound x) (lower-bound y))
                 (+ (upper-bound x) (upper-bound y))))
(define (sub-interval x y)
  (make-interval (- (lower-bound x) (lower-bound y))
                 (- (upper-bound x) (upper-bound y))))

(define (mul-interval x y)
  (let ((p1 (* (lower-bound x) (lower-bound y)))
        (p2 (* (lower-bound x) (upper-bound y)))
        (p3 (* (upper-bound x) (lower-bound y)))
        (p4 (* (upper-bound x) (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
                   (max p1 p2 p3 p4))))

(define (make-center-width c w)
  (make-interval (- c w) (+ c w)))
(define (center i)
  (/ (+ (lower-bound i) (upper-bound i)) 2))
(define (width i)
  (/ (- (upper-bound i) (lower-bound i)) 2))

(define (make-center-percent c p)
  (make-center-width c (* c (/ p 100))))
(define i1 (make-center-percent 10 0.1))
(newline)
(define i2 (make-center-percent 20 0.1))
(newline)
(display (mul-interval i1 i2))
(newline)
(display (make-center-percent 200 0.2))
; ある正の数 a > 0, b > 0について、
; aの許容誤差p1%, bの許容誤差p2%とすると、
; a-p1 ~ a+p1
; b-p2 ~ b+p2
; がそれぞれの区間である
; すべての値が正である、という仮定を使っていいので、
; 下限が両方正だとする。
; すると、区間の積は、
; ≒ ab + abp2 + abp1　が上限
; ab - abp2 - abp1　 が下限となる（それぞれにp1p2≒0の仮定を使った）
; 中央はab,
; 幅=誤差はab(p2+p1)である。
; よって、abの誤差はp1+p2と近似できる。（実験結果にも一致する。）
