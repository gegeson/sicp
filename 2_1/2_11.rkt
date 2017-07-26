#lang racket
(require racket/trace)
;18:15->18:26
;18:27->18:41
;18:15->19:02 -5
;41m
;19:06->19:25

;19:37->19:52
;20:00->20:09

;だるいのでスキップ
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
;
;(define (mul-interval2 x y)
;  (let ((lx (lower-bound x))
;        (ux (upper-bound x))
;        (ly (lower-bound y))
;        (uy (upper-bound y)))
;    (cond
;      ((and (negative? lx) (negative? ux))
;        (cond
;            ((and (negative? ly) (negative? uy))
;             (*))
;          ))
;      )
;    )
;  )

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

(define ia (make-interval 5 -1))
(define ib (make-interval 8 -3))
(display (div-interval ia ib))
(newline)
(display (div-interval ib ia))
