#lang racket
(require racket/trace)
; 15:05->15:24
; 15:26->
; 平均緩和法で上手く行く理由
; sqrt xにおいて、解となる√xは、常に
; yとx/yの間にあるから、という説明があった。
; 数式で置き換えると、
; y <= √x <= x/y or x/y <= √x <= y
; それぞれ、変形すると y<=√x, √x <= yになる。
; yの値に関わらず、いつもどちらかが成り立っているはず。
; したがって解は常にyとx/yの間にあり、平均を取ることでより解に近づくことが出来る。

;; Fixed points
(define (average x y)
  (/ (+ x y) 2))

(define tolerance 0.00001)

(define (close-enough? x y)
  (< (abs (- x y)) 0.001))

(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
          next
          (try next))))
  (try first-guess))

;: (fixed-point cos 1.0)

;: (fixed-point (lambda (y) (+ (sin y) (cos y)))
;:              1.0)


;(define (sqrt x)
;  (fixed-point (lambda (y) (/ x y))
;               1.0))

(define (sqrt x)
  (fixed-point (lambda (y) (average y (/ x y)))
               1.0))

(sqrt 2.0)
