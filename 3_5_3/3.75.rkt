#lang racket/load
(require sicp)
(require (prefix-in strm: racket/stream))
(require "3_5_3/stream.rkt")
; 22:03 -> 22:21

; 拝借
; http://uents.hatenablog.com/entry/sicp/038-ch3.5.3.md
(define (sign-change-detector last x)
  (cond ((and (< x 0) (> last 0)) -1)
        ((and (> x 0) (< last 0)) 1)
        (else 0)))

; あーわかった。
; 最後の値が入るべき所に平滑化後の値を入れてるのは何かがおかしい。
; これだと平滑化した後の値とセンスデータの値で平滑化することになってしまう。
(define (make-zero-crossings-bug input-stream last-value)
  (let ((avpt (/ (+ (stream-car input-stream)
                    last-value)
                 2)))
    (cons-stream
     (sign-change-detector avpt last-value)
     (make-zero-crossings-bug
      (stream-cdr input-stream) avpt))
    ))

; ならシンプルにこうすればいいのでは。
; →上手くいかない！
; なぜだろう、と思って答えを見た（最近気が早い）が、
; 受け取ったavptを活用してなかった。
; sign-change-detectorで受け取った方のavptを活用してやればいいだけ。
(define (make-zero-crossings-failed　input-stream last-value avpt)
  (let ((avpt (/ (+ (stream-car input-stream)
                    last-value)
                 2)))
    (cons-stream
     (sign-change-detector avpt last-value)
     (make-zero-crossings-failed
      (stream-cdr input-stream) (stream-car input-stream) avpt))
    ))

; 成功ver
(define (make-zero-crossings　input-stream last-value last-avpt)
  (let ((avpt (/ (+ (stream-car input-stream)
                    last-value)
                 2)))
    (cons-stream
     (sign-change-detector avpt last-avpt)
     (make-zero-crossings
      (stream-cdr input-stream) (stream-car input-stream) avpt))
    ))


(define sense-data
  (list->stream
   (list 1 2 1.5 1 0.5 -0.1 -2 -3 -2 -0.5 0.2 3 4)))

(define (stream-head s n)
  (define (iter s n)
    (if (<= n 0)
      'done
      (begin
        (display (stream-car s))
        (newline)
        (iter (stream-cdr s) (- n 1)))))
  (iter s n))

(stream-head (make-zero-crossings sense-data 0 0) 13)
