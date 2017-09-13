#lang racket/load
(require sicp)
(require racket/trace)
(require "2_4/get_put.rkt")
;時間不明。10分ぐらい？
;; EXERCISE 2.73
(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp) (if (same-variable? exp var) 1 0))
        ((sum? exp)
         (make-sum (deriv (addend exp) var)
                   (deriv (augend exp) var)))
        ((product? exp)
         (make-sum
           (make-product (multiplier exp)
                         (deriv (multiplicand exp) var))
           (make-product (deriv (multiplier exp) var)
                         (multiplicand exp))))
        (else (error "unknown expression type -- DERIV" exp))))


(define (deriv exp var)
   (cond ((number? exp) 0)
         ((variable? exp) (if (same-variable? exp var) 1 0))
         (else ((get 'deriv (operator exp)) (operands exp)
                                            var))))

(define (operator exp) (car exp))

(define (operands exp) (cdr exp))

;getにderiv（データ主導で言う演算子）と+, *などの演算子（データ主導で言う型）を渡し、
;+, *などの演算子（データ主導で言う型）に対応した微分演算の法則を引っ張ってきて、
;それを第二項に渡し、+なら和の微分法則、*なら積の微分法則を適用した上でvar変数で微分する、
;ということをやっている。
;なぜnumber?とvariable?はデータ主導ディスパッチに取り込めないのかというと、
;1. carが演算子であり
;2. cdrに変数もしくは値がある
;という前提で動いているからであり、
;number?やvariable?で引っかかる値はリストではなくそれ自体が値・変数
;というイレギュラーだから、統一的に扱えないため。
;単一のリストなら、値・変数それ自体を演算とみなし、
;更にnullにその演算を適用させる、という風に計算することも不可能ではないのかもしれないが、
;不自然過ぎる。
