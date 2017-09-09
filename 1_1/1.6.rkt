#lang racket
;関数を実行する時、まず引数を評価することから始めるので、
;引数のnew-if関数の一つに再帰があると無限に引数の評価が行われ、無限ループになる。

(define (square x) (* x x))

(define (sqrt-iter guess x) (if (good-enough? guess x)
guess
(sqrt-iter (improve guess x) x)))

(define (improve guess x) (average guess (/ x guess)))

(define (average x y)
(/ (+ x y) 2))

(define (good-enough? guess x)
(< (abs (- (square guess) x)) 0.001))

(define (sqrt x) (sqrt-iter 1.0 x))

(define (new-if predicate then-clause else-clause) (cond (predicate then-clause)
(else else-clause)))

(display (sqrt 3))
