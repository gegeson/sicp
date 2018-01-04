#lang racket/load
(require sicp)
(require (prefix-in strm: racket/stream))
(require "3_5_2/stream.rkt")
; 14:12 ->14:52
; そもそも問題の要求がわからん。
; mul-streamsじゃいかんのか？
; http://uents.hatenablog.com/entry/sicp/037-ch3.5.2.2.md
; ここの答えの手前を見たが、なるほど。
; a0*b0 + a1*b1 + a2*b2 + …
; じゃなくて
; (a0 + a1 + a2 + …) * (b0 + b1 + b2 + …)
; これを求めよ、という意味だったらしい。
; 改めて考えるぞ。
;
(define (scale-stream stream factor)
  (stream-map (lambda (x) (* x factor)) stream))

; 初項が思いつかなかったので、とりあえず0。でも正しいはず。
(define (mul-series s1 s2)
  (cons-stream 0
  (add-streams (scale-stream s2 (stream-car s1))
               (mul-series (stream-cdr s1) s2))))
; --------------
; ここからテストの準備
; --------------
(define ones (cons-stream 1 ones))

(define nega-ones (cons-stream -1 nega-ones))

(define integers
 (cons-stream 1 (add-streams ones integers)))

(define (mul-streams s1 s2)
 (stream-map * s1 s2))

(define (quotient-streams s1 s2)
 (stream-map / s1 s2))

(define (integrate-series sa)
 (quotient-streams sa integers))

(define cosine-series
 (cons-stream 1 (integrate-series (mul-streams nega-ones sine-series))))

(define sine-series
 (cons-stream 0 (integrate-series cosine-series)))


(define (stream-head s n)
 (define (iter s n)
   (if (<= n 0)
     'done
     (begin
       (display (stream-car s))
       (display ", ")
       (iter (stream-cdr s) (- n 1)))))
 (iter s n))


 (define (stream-sum s n)
  (define (iter s n sum)
    (if (<= n 0)
      sum
        (iter (stream-cdr s) (- n 1) (+ sum (stream-car s)))))
  (iter s n 0))
 ; ----------------
 ; ここまでテストの準備
 ; ----------------
 ; ----------------
 ; ここからテスト
 ; ----------------
(stream-head cosine-series 10)
(newline)
(display (stream-sum (mul-series cosine-series cosine-series) 15))
; 19508/66825
(newline)
(display (stream-sum (mul-series sine-series sine-series) 15))
; 47317/66825
(newline)
(display (+ (stream-sum (mul-series cosine-series cosine-series) 15)
            (stream-sum (mul-series sine-series sine-series) 15)))
(newline)
; 19508/66825 + 47317/66825 = 1
; 合ってるっぽい……？

; uents.hatenablog.com/entry/sicp/037-ch3.5.2.2.md
; ここをちら見して比較すると初項のとり方が違ったけど、まあ合ってると言っていいでしょう。
; とは言え、一応そのバージョンも実装してみよう。
(define (mul-series2 s1 s2)
  (cons-stream (* (stream-car s1) (stream-car s2))
  (add-streams (scale-stream (stream-cdr s2) (stream-car s1))
               (mul-series2 (stream-cdr s1) s2))))

(display (map (lambda (i) (stream-ref (mul-series2 integers integers) i))
              (enumerate-interval 0 5)))
; あっさりできた。完璧！
