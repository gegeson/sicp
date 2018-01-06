#lang racket/load
(require sicp)
(require (prefix-in strm: racket/stream))
(require "3_5_3/stream.rkt")
; 22:10-> 23:20
; おや？
; mergeが機能するのは受け取ったストリームが整列済みのときだけ
; しかし元のpairsは整列したペアを返さない
; ということは作り直せってことなのか？
; わからん。問題の要件からしてよくわからん。

; 答え見た。

; 最初思いついたシンプルな解答で大体合ってたっぽい。
; ただし、重みが等しい時に両方進める、というふうにしてはいけない。
; 重みが等しいからと言って同じペアとは限らないので、意味が壊れる。
; あとはこのmerge-weightedを使うようにpairsを書き換えるだけ。
; pair生成時は、途中までは整列済みで、いま手元にある二つの順序だけを考えればいいので、
; interleaveをmerge-weightedに変えるだけで問題ない。
; 味わい深い解答。明日に復習しよう。


(define (interleave s1 s2)
  (if (stream-null? s1)
    s2
    (cons-stream (stream-car s1)
                 (interleave s2 (stream-cdr s1)))))

(define (merge-weighted s1 s2 weight)
  (cond ((stream-null? s1) s2)
        ((stream-null? s2) s1)
        (else
         (let ((s1car (stream-car s1))
               (s2car (stream-car s2)))
           (cond ((weight s1car s2car)
                  (cons-stream s1car (merge-weighted (stream-cdr s1) s2 weight)))
                 (else
                  (cons-stream s2car (merge-weighted s1 (stream-cdr s2) weight)))
                 )))))


(define (pairs-weighted s t weight)
(cons-stream
 (list (stream-car s) (stream-car t))
 (merge-weighted
  (stream-map (lambda (x) (list (stream-car s) x))
              (stream-cdr t))
  (pairs-weighted (stream-cdr s) (stream-cdr t) weight) weight)))

(define (sum-weight p1 p2)
  (< (+ (car p1) (cadr p1)) (+ (car p2) (cadr p2))))

(define (stream-head s n)
 (define (iter s n)
   (if (<= n 0)
     'done
     (begin
       (display (stream-car s))
       (newline)
       (iter (stream-cdr s) (- n 1)))))
 (iter s n))
; (stream-head (merge-weighted integers integers sum-weight) 20)
(stream-head (pairs-weighted integers integers sum-weight) 100)

(define s (stream-filter
           (lambda (x)
                   (and (not (= (remainder x 2) 0))
                        (not (= (remainder x 3) 0))
                        (not (= (remainder x 5) 0))))
           integers))

(define (siki i j)
  (+ (* 2 i) (* 3 j) (* 5 i j)))

(define (sum2-weight p1 p2)
    (<  (siki (car p1) (cadr p1)) (siki (car p2) (cadr p2))))

(newline)
(stream-head (pairs-weighted s s sum2-weight) 20)
