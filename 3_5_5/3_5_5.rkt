#lang racket/load
(require sicp)
(require (prefix-in strm: racket/stream))
(require "3_5_5/stream.rkt")
; 15:40->16:00
; 17:55->18:07
; 何をやってるか全然わからんので解説を見た
; http://uents.hatenablog.com/entry/sicp/040-ch3.5.5.md

(define random-init 7)

(define (rand-update x)
  (let ((a 27) (b 26) (m 127))
    (modulo (+ (* a x) b) m)))


(define random-numbers
  (cons-stream
   random-init
   (stream-map rand-update random-numbers)))


(define (map-successive-pairs f s)
 (cons-stream
  (f (stream-car s) (stream-car (stream-cdr s)))
  (map-successive-pairs f (stream-cdr (stream-cdr s)))))

; 連続するランダムな整数二つが素数→#t, 素数でない→#f
; としてストリームを返す
(define cesaro-stream
 (map-successive-pairs (lambda (r1 r2) (= (gcd r1 r2) 1))
                       random-numbers))

; 上のテストの成功率のストリームを返す
(define (monte-carlo-stream experiment-stream passed failed)
  (define (next passed failed)
    (cons-stream
     (* (/ passed (+ passed failed) 1.0)) ;;小数にするため1.0を掛ける
     (monte-carlo-stream
      (stream-cdr experiment-stream) passed failed)))
  (if (stream-car experiment-stream)
      (next (+ passed 1) failed)
      (next passed (+ failed 1))))

; テスト結果を(sqrt (/ 6 p))に施すとpiになるらしい…なんでかは説明無し
(define pi-stream
  (stream-map
   (lambda (p) (sqrt (/ 6 p)))
   (monte-carlo-stream cesaro-stream 0 0)))

(display (stream-ref pi-stream 10))


; 後半
; これすごいな
(define (stream-withdraw balance amount-stream)
  (cons-stream
   balance
   (stream-withdraw
    (- balance (stream-car amount-stream))
    (stream-cdr amount-stream))))
