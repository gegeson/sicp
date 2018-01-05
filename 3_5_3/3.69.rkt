#lang racket/load
(require sicp)
(require (prefix-in strm: racket/stream))
(require "3_5_3/stream.rkt")
; 7:45-> 8:16
; 8:27->

; 方針1
; pairsでペア作った後に、
; ペアと数値のストリーム受け取ってトリプルを返す関数に渡せばよいのでは。
; 方針2
; 方針1だと結局フィルターかます必要があって効率が良くない気がした。
; というわけで別の方針。
; 二つペアを作り、
; (a, b), (b, c)
; のように二つ目と一つ目が一致している二つのペアがあったら、
; (a, b, c)
; とくっつけてしまう。

(define (interleave s1 s2)
  (if (stream-null? s1)
    s2
    (cons-stream (stream-car s1)
                 (interleave s2 (stream-cdr s1)))))

(define (pairs s t)
 (cons-stream
  (list (stream-car s) (stream-car t))
  (interleave
   (stream-map (lambda (x) (list (stream-car s) x))
               (stream-cdr t))
   (pairs (stream-cdr s) (stream-cdr t)))))

(define (<= a b)
  (or (< a b) (= a b)))

; 失敗作
(define (triples-failed s t u)
  (let ((p (pairs t u)))
    (define (iter s p)
     (cons-stream
      (cons (stream-car s) (stream-car p))
      (interleave
       (stream-map (lambda (x) (if (<= (stream-car s) (car x))
                                 (cons (stream-car s) x)
                                 nil)) (stream-cdr p))
       (iter (stream-cdr s) (stream-cdr p)))))
    (iter s p)))

(define (triples s t u)
  (let ((p1 (pairs s t))
        (p2 (pairs t u)))
    (define (iter p1 p2)
      (if (= (cadr (stream-car p1)) (car (stream-car p2)))
        (begin (printf "~a ~a \n"  (stream-car p1)  (stream-car p2))
        (cons-stream (cons (car (stream-car p1)) (stream-car p2))
                     (iter (stream-cdr p2) p1)
                     ))
        (iter (stream-cdr p2) p1)
        )
      )
    (iter p1 p2))
  )

(define (stream-head s n)
 (define (iter s n)
   (if (<= n 0)
     'done
     (begin
       (display (stream-car s))
       (newline)
       (iter (stream-cdr s) (- n 1)))))
 (iter s n))

(stream-head (triples integers integers integers) 10)
