#lang racket/load
(require sicp)
(require (prefix-in strm: racket/stream))
(require "3_5_3/stream.rkt")
; 12:48 -> 12:59
; 何も考えず書いた。汚いコード。一応合ってるが、3.63の教訓も活かせていない。
(define (stream-limit s tolerance)
  (if (> tolerance (abs (- (stream-car s) (stream-car (stream-cdr s)))))
    (stream-car (stream-cdr s))
    (stream-limit (stream-cdr s) tolerance)))

; http://uents.hatenablog.com/entry/sicp/038-ch3.5.3.md
; こちらを参考に写経したもの
(define (stream-limit2 s tolerance)
  (define (iter s count)
    (let ((s0 (stream-ref s 0))
          (s1 (stream-ref s 1)))
      (if (< (abs (- s0 s1)) tolerance)
          (cons s1 count)
          (iter (stream-cdr s) (+ count 1)))))
  (iter s 0))


(define (average x y) (/ (+ x y) 2))

(define (square x) (* x x))

(define (sqrt-improve guess x)
  (average guess (/ x guess)))

(define (sqrt-stream x)
  (define guesses
    (cons-stream
     1.0
     (stream-map (lambda (guess) (sqrt-improve guess x))
                 guesses)))
  guesses)

(define (sqrt x tolerance)
  (stream-limit (sqrt-stream x) tolerance))

(display (sqrt 2 0.1))
(newline)
(display (sqrt 2 0.01))
(newline)
(display (sqrt 2 0.001))
(newline)
(display (sqrt 2 0.0001))

(define (sqrt2 x tolerance)
  (stream-limit2 (sqrt-stream x) tolerance))

(newline)
(display (sqrt2 2 0.1))
(newline)
(display (sqrt2 2 0.01))
(newline)
(display (sqrt2 2 0.001))
(newline)
(display (sqrt2 2 0.0001))
