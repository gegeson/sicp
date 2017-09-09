;16:01->
#lang racket
(require racket/trace)

(define (square x) (* x x))
(define (fast-expt b n)
  (cond ((= n 0) 1)
        ((even? n) (square (fast-expt b (/ n 2))))
        (else (* b (fast-expt b (- n 1))))))

(define (even? n)
  (= (remainder n 2) 0))
(define (mult3? n)
  (= (remainder n 3) 0))

(define (cons2 a b)
  (* (fast-expt 2 a) (fast-expt 3 b))
  )
;(define (car2 product)
;  (define (car-iter i product)
;    (if (not (even? product))
;      i
;      (car-iter (+ i 1) (/ product 2))))
;  (car-iter 0 product)
;  )
;
;(define (cdr2 product)
;  (define (cdr-iter i product)
;    (if (not (mult3? product))
;      i
;      (cdr-iter (+ i 1) (/ product 3))))
;  (cdr-iter 0 product)
;  )

(define (car2 product)
  (define (car-iter product)
    (if (not (even? product))
      0
      (+ 1 (car-iter (/ product 2)))))
  (car-iter product)
  )

(define (cdr2 product)
  (define (cdr-iter product)
    (if (not (mult3? product))
      0
      (+ 1 (cdr-iter (/ product 3)))))
  (cdr-iter product)
  )
(display (cons2 3 10))
(newline)
(display (car2 (cons2 3 10)))
(newline)
(display (cdr2 (cons2 3 10)))
;2^a * 3^b == 2^a' * 3^b'
;を、両辺の自然対数を取って変形すると、
; (a-a')log2 + (b-b')log3 == 0
; これが成り立つのはa==a' かつ　b==b'の時に限る
; よって、2^a*3^bという表記は一意の整数を示す
