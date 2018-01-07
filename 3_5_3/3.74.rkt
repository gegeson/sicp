#lang racket/load
(require sicp)
(require (prefix-in strm: racket/stream))
(require "3_5_3/stream.rkt")
; 21:43->22:01
; テストが面倒だから解けたと思ってすぐに答え見たが違った
; 一個手前にずらす（cdr）のかな、と思ったが、逆で、一個後ろにずらす(cons)のが正解らしかった。

; 拝借
; http://uents.hatenablog.com/entry/sicp/038-ch3.5.3.md
(define (sign-change-detector last x)
  (cond ((and (< x 0) (> last 0)) -1)
        ((and (> x 0) (< last 0)) 1)
        (else 0)))

(define (make-zero-crossings input-stream last-value)
  (cons-stream
   (sign-change-detector
    (stream-car input-stream)
    last-value)
   (make-zero-crossings
    (stream-cdr input-stream)
    (stream-car input-stream))))

; (define zero-crossings
;   (make-zero-crossings sense-data 0))

(define (zero-crossings sense-data)
  (stream-map sign-change-detector
              sense-data
              (cons-stream (stream-car sense-data) sense-data)))

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

(stream-head (zero-crossings sense-data) 13)
