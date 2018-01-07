#lang racket/load
(require sicp)
(require (prefix-in strm: racket/stream))
(require "3_5_3/stream.rkt")
; 22:57->23:22

; 拝借
; http://uents.hatenablog.com/entry/sicp/038-ch3.5.3.md
(define (sign-change-detector last x)
  (cond ((and (< x 0) (> last 0)) -1)
        ((and (> x 0) (< last 0)) 1)
        (else 0)))

(define (average a b)
  (/ (+ a b) 2))

; 若干スマートじゃない気がするが、
; 一個右にずらす上手い方法が思い浮かばん。
(define (smooth s)
  (cons-stream (stream-car s)
               (stream-map average s (stream-cdr s))))

; いつもどおりこちらから解答参照
; http://uents.hatenablog.com/entry/sicp/038-ch3.5.3.md
; なるほど単にそれでよかったのか…てかこれ一回試した方法じゃんか。
(define (smooth2 input-stream)
  (stream-map average
              input-stream
              (cons-stream 0 input-stream)))

(define (zero-crossings s)
  (define (make-zero-crossings s)
    (let ((s1 (stream-ref s 0))
          (s2 (stream-ref s 1)))
      (cons-stream
       (sign-change-detector s1 s2)
       (make-zero-crossings (stream-cdr s))
       )
      )
    )
  (make-zero-crossings (smooth s)))

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

(stream-head (smooth integers) 10)

(stream-head (zero-crossings sense-data) 12)
