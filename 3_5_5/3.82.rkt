#lang racket/load
(require sicp)
(require (prefix-in strm: racket/stream))
(require "3_5_5/stream.rkt")
; 17:11->17:47

; まずモンテカルロ積分のアルゴリズムを整理する。
; 円の領域内を示す方程式と、その円を内包する長方形を受け取り、
; 長方形内に点を打っていき、円の方程式によって
; (円の中に打たれた点の数) / (打った点の数)
; を計算する。
; これに長方形の面積をかけると、
; おおよその円の面積が分かる。

(define (random-in-range low high)
  (let ((range (- high low)))
    (+ low (* (random) range))))

(define integers
  (cons-stream 1 (add-streams ones integers)))

(define (add-stream a stream)
  (stream-map (lambda (x) (+ x a)) stream))

; 汚いけど一応動くぞ。
(define (estimate-integral p x1 x2 y1 y2)
  (define (count-in-p x y)
      (cons-stream 1
       (if (p x y)
         (add-streams ones (count-in-p (random-in-range x1 x2) (random-in-range y1 y2)))
         (count-in-p (random-in-range x1 x2) (random-in-range y1 y2))))
      )
  (let ((in-p (count-in-p (random-in-range x1 x2) (random-in-range y1 y2)))
        (count (cons-stream 1 integers)))
    ; in-pは打った点の内 領域 p に含まれる点
    ; countは打った点全て
    ; 1.0をそれぞれにかけて実数化したあと、
    ; それぞれを割って面積をかける。
    (stream-map (lambda (x) (* x (- x2 x1) (- y2 y1)))
     (stream-map / (scale-stream in-p 1.0)
                            (scale-stream count 1.0)))
    )
  )

(define (p1 x y) (<= (+ (* x x) (* y y)) 4.0))
(stream-head (estimate-integral p1 -2.0 2.0 -2.0 2.0) 1000)
; 真の値が12.56ぐらい
; 出力はn=1000で12.332332332332332

(define (p2 x y) (<= (+ (* x x) (* y y)) 1.0))
(stream-head (estimate-integral p2 -1.0 1.0 -1.0 1.0) 1000)
; 真の値が円周率3.14…
; 出力はn=1000で 3.2072072072072073
; まあまあかな
