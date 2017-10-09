#lang debug racket
(require sicp)
(require racket/trace)
;18:18->18:39
(define (make-withdraw initial-amount)
  (let ((balance initial-amount))
    (lambda (amount)
            (if (>= balance amount)
              (begin (set! balance (- balance amount))
                     balance)
              "Insufficient funds"))))
;これは要するに
;(define (make-withdraw initial-amount)
;  ((lambda (balance)
;           (lambda (amount)
;                   (if (>= balance amount)
;                     (begin (set! balance (- balance amount))
;                            balance)
;                     "Insufficient funds"))) initial-amount))
;これと同じっちゅう話。
(define W1 (make-withdraw 100))
(define W2 (make-withdraw 100))

(display (W1 100))
(newline)
(display (W2 100))
(newline)
(display (W1 100))
(newline)
;挙動もlet版,lambda版でいっしょ。本文にあるやつとも一緒。
;環境構造も、代入による束縛だから同じだと思う
;答えみたら違った。実際には、initial-amountの値も保持される。
;グローバル環境<-initial-amountがxを保持した環境<-balanceが初期値を保持した環境
;ということらしい
