#lang racket
(require racket/trace)
; 20:35->21:11
;
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

(define (div-interval x y)
  (cond
    ((or (= (upper-bound y) 0) (= (lower-bound y) 0))
      (newline) (display "0 division Error"))
    ((negative? (* (upper-bound y) (lower-bound y)))
     (newline) (display "0をまたぐな"))
    (else
     (mul-interval
      x
      (make-interval (/ 1.0 (upper-bound y))
                     (/ 1.0 (lower-bound y)))))))
(define (width-interval interval)
  (let ((x (upper-bound interval))
        (y (lower-bound interval)))
        (abs (/ (- x y) 2))))

(define (make-center-percent c p)
  (make-center-width c (* c (/ p 100))))
(define i1 (make-center-percent 10 0.01))
(define i2 (make-center-percent 20 0.01))
(define i3 (make-center-percent 150 0.2))
(define i4 (make-center-percent 200 0.2))
(define i5 (make-center-percent 10 1))
(define i6 (make-center-percent 20 1))
(define i7 (make-center-percent 150 2))
(define i8 (make-center-percent 200 2))
(define i (make-interval 1 1))
;(newline)
;(display (div-interval i1 i2))
;(newline)
;(display (div-interval i1 i1))
;(newline)
;(display (div-interval i1 i))
;(newline)
;(display (div-interval i2 i))
;(newline)
; 自分自身を自分自身で割ったら区間は[1,1]のはずなのに、そこからずれが生じる
; 一方、[1, 1]で割っても影響なし

(display (div-interval i5 i6))
(newline)
(display (div-interval i5 i5))
; 割り算のズレについて
; [a-ap, a+ap]を自分で割ると、
; [(a-ap)/(a+ap), (a+ap)/(a-ap)]
; となり、微妙にずれる
; この結果は、分母と分子が別々に変動するという仮定に基いているが
; 実際には有り得ない。そこでこのズレが生じる
; つまり、割り算の分母分子に同じものが含まれると、
; 同時には同じ値しか取らないのに別々に動くという仮定が自動で入るため、
; 誤差が生じる。
(newline)
(display (mul-interval i1 i2))
(newline)
(display (mul-interval i5 i5))
(newline)
;(display (mul-interval i1 i))
;(newline)
;(display (mul-interval i2 i))

;23:16->0:16
(define (par1 r1 r2)
  (div-interval (mul-interval r1 r2)
                (add-interval r1 r2)))

(define (par2 r1 r2)
  (let ((one (make-interval 1 1)))
    (div-interval one
                  (add-interval (div-interval one r1)
                                (div-interval one r2)))))
;(newline)
;(display (par1 i1 i2))
;(newline)
;(display (par2 i1 i2))
;(newline)
;(display (par1 i3 i4))
;(newline)
;(display (par2 i3 i4))
;(newline)
;(display (par1 i5 i6))
;(newline)
;(display (par2 i5 i6))
;(newline)
;(display (par1 i7 i8))
;(newline)
;(display (par2 i7 i8))
