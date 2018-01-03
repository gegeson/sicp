#lang racket/load
(require sicp)
(require (prefix-in strm: racket/stream))
(require "3_5_2/stream.rkt")
; 22:36->22:57
; 解けた
; 1を2倍したもの、3倍したもの、5倍したものを用意する
; それらをつなげる
; 1, 2, 3, 5
; 2, 3, 5を2倍したもの、3倍したもの、5倍したものを用意する
; 4, 6, 10, 6, 9, 15, 10, 15, 25
; これらを繋げる
; 以下無限ループ
; ってことなのかな。
; 8が適切なタイミングで出て来る理由がよくわからないな。
(define (scale-stream stream factor)
  (stream-map (lambda (x) (* x factor)) stream))

  (define (merge s1 s2)
    (cond ((stream-null? s1) s2)
          ((stream-null? s2) s1)
          (else
           (let ((s1car (stream-car s1))
                 (s2car (stream-car s2)))
             (cond ((< s1car s2car)
                    (cons-stream s1car (merge (stream-cdr s1) s2)))
                   ((> s1car s2car)
                    (cons-stream s2car (merge s1 (stream-cdr s2))))
                   (else
                    (cons-stream s1car
                                 (merge (stream-cdr s1)
                                        (stream-cdr s2)))))))))

(define S (cons-stream 1 (merge (merge (scale-stream S 2) (scale-stream S 3)) (scale-stream S 5))))

(display-s S 0 10)
