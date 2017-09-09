#lang racket
(require racket/trace)
;18:15->18:26
;18:27->18:41
;18:15->19:02 -5
;41m
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
(define (div-interval x y)
  (mul-interval
    x
    (make-interval (/ 1.0 (upper-bound y))
                    (/ 1.0 (lower-bound y)))))
(define (width-interval interval)
  (let ((x (upper-bound interval))
        (y (lower-bound interval)))
        (abs (/ (- x y) 2))))

;任意の区間は、幅をw、lower-boundをaとすると、
;[a, a+2w]と書ける。
;今、区間Aを[a, a+2*w_a]
;区間Bを[b, b+2*w_b]とすると、
;区間AとBの和は、
;[a+b, a+b+2*(w_a+w_b)]
;となり、幅は(w_a+w_b)である
;区間AとBの差は、
;[a-b, a-b+2*(w_a-w_b)]
;となり、幅は(w_a-w_b)である。
;この2つは幅の関数になっている。
(define ia (make-interval 5 1))
(define ib (make-interval 8 -1))
;(display (width-interval ia))
;(newline)
;(display (width-interval ib))
;(newline)
;(display (width-interval (add-interval ia ib)))
;(newline)
;(display (width-interval (sub-interval ia ib)))
;(newline)
(define ia2 (make-interval -6 -10))
(define ib2 (make-interval 23 14))
;幅だけは上と同じ
;(display (width-interval ia2))
;(newline)
;(display (width-interval ib2))
;(newline)
;(display (width-interval (add-interval ia2 ib2)))
;(newline)
;(display (width-interval (sub-interval ia2 ib2)))
;　幅を買えただけでは結果は変わらない

; 一方、乗算と除算について。
; まず乗算について。
; 区間Aを[a, a+2*w_a]
; 区間Bを[b, b+2*w_b]とすると、
; A*Bの結果は、
; p1 = ab
; p2 = ab+2a*w_q
; p3 = ab+2b*w_b
; p4 = ab+2a*w_a+2b*w_b+4*w_a*w_b
; のうち、最小値が区間の下限、最大値が区間の上限になる。
; しかし、これらのうちどの二組を選んでも,
; width-intervalの値は明らかにwだけでは決まらない。
; まず除算について。
; 区間Aを[a, a+2*w_a]
; 区間Bを[b, b+2*w_b]とすると、
;2つの区間 [a, a+2*w_a]
;         [1/(b+2*w_b), 1/b]
; の積を計算すれば良い。
; この結果は
; p1 = a/(b+2*w_b)
; p2 = a/b
; p3 = (a+2*w_a)/(b+2*w_b)
; p4 = (a+2*w_a)/b
; の最小値が下限、最大値が上限、となる
; この場合、どの二組を選んでも、
; 分母にbが混ざるため、幅wだけではなくbも関与する。
; よってwidth-intervalの値は明らかにwだけでは決まらない。

(display (width-interval (mul-interval ia ib)))
(newline)
(display (width-interval (mul-interval ia2 ib2)))
(newline)
(display (width-interval (div-interval ia ib)))
(newline)
(display (width-interval (div-interval ia2 ib2)))
;->全然別な結果が出る
