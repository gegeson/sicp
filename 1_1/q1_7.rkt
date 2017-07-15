#lang racket
(require sicp)

(define (square x) (* x x))

(define (sqrt-iter guess x) (if (good-enough? guess x)
guess
(sqrt-iter (improve guess x) x)))

(define (improve guess x) (printf (format "guess = ~a" guess))
                           (newline)
                           (printf (format "x = ~a" x))
                           (newline)
                           (printf (format "/ x guess = ~a" (/ x guess)))
                           (newline)
                           (printf (format "average = ~a" (average guess (/ x guess))))
                           (newline)
                           (average guess (/ x guess)))

(define (average x y)
(/ (+ x y) 2))

(define (good-enough? guess x)
  (printf (format "diff = ~a" (- (square guess) x)))
  (newline)
(< (abs (- (square guess) x)) 0.001))
;11:23->11:31

(define (sqrt-iter2 pre_guess guess x) (if (good-enough?2 pre_guess guess x)
guess
(sqrt-iter2 guess (improve guess x) x)))

(define (good-enough?2 pre_guess guess x)
(< (abs (- guess pre_guess)) (/ guess 1000)))

(define (sqrt x) (sqrt-iter 1.0 x))
(define (sqrt2 x) (sqrt-iter2 1.0 (improve 1.0 x) x))
;(display (sqrt 3.0))
(display (sqrt2 3.0))

;(display (sqrt 0.0000000001))
;この数にとって、0.001は巨大すぎる。
;3.0の平方根を調べる時に差が1なんかでは全然精度が出ないのと原理は同じ。
;「どの程度理想値に近い値が出たか？」における「近い」の基準がゆるい、という意味である。
;逆に言えば、与えられた数に対して小さく取ればなんとかなる。
(display (sqrt2 0.0000000001))

;(sqrt 10000000000000)
;有効数字の関係で、この計算の精度には限界があり、
;大きな数ほどその限界が早く訪れる。
;その限界が差が0.001より大きい時に訪れる場合、無限ループになる。
;これは巨大な数だと起きる
;もうちょっと具体的に書くと、
; new_guess = (guess + x/guess) / 2
; という計算式でguessは更新されていくが、
; guessが有効数字ギリギリまで行った場合、
; 本来はnew_guessの値はguessとx/guessの間になるべきなのにも関わらず、
; new_guess がguessと等しくなってしまう、という事が起きる
;これを修正するには、good-enough?の比較に使う数をもっと大きく取ってやれば良い。
(display (sqrt2 100000000000000))
