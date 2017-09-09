#lang racket
(require racket/trace)
;18:15->18:26
;18:27->18:41
;18:15->19:02 -5
;41m
;19:06->19:17
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

; -1~1の値を取るR1と、
; 1~3の値を取るR2について、
; R2/R1の取りうる値は、
; R1->+0では正の無限大、
; R1->-0では負の無限大に発散する。
; しかし、これを前のバージョンで試すと…
(define (prev-div-interval x y)
  (mul-interval
    x
    (make-interval (/ 1.0 (upper-bound y))
                    (/ 1.0 (lower-bound y)))))
(define _ia (make-interval 3 1))
(define _ib (make-interval 1 -1))
(display (prev-div-interval _ia _ib))
;　->(-3.0, 3.0)
;　と、全然違った結果が出てしまう。
; そこで、0をまたぐ場合は禁止。
; 勿論0割りも禁止。

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

;(define ia (make-interval 5 -1))
;(define ib (make-interval 8 -3))
;(display (div-interval ia ib))
;(newline)
;(display (div-interval ib ia))
