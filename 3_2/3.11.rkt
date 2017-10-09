#lang debug racket
(require sicp)
(require racket/trace)
;19:18->19:23
;19:25->19:46
;図はノートに書いた。魅せられないぐらいひどい図なので省略。
;小さいようで割りと大きめの間違いをしてた。
;m = 'deposit という環境の下にamount = 30という環境が作られる、
;と書いてしまったが、
;実際は両方E1に直接ぶら下がっている。
;自分のケースだと、 (acc 'deposit)とすることでm=depositという情報が保持されたまま
;関数depositが呼び出されるという事になってしまうが、これは明らかにおかしい。
;何故なら、depositはdispatchのmを参照できるような形の関数ではないからである。（という説明で良いのか？）
;もうちょっとマシな説明。
;環境構造がぶら下がりになるのは、下にある環境構造は上にある環境構造の変数の情報全てを持っている、という状態である。
;deposit, withdrawは、dispatchに渡されるmという情報を一切知らないし、知り得ない。例え同じ変数名であっても機能しうる。
;だからぶらさがりになるのはおかしい、という感じかな

(define (make-account balance)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (define (dispatch m)
    (cond ((eq? m 'withdraw) withdraw)
          ((eq? m 'deposit) deposit)
          (else (error "Unknown request -- MAKE-ACCOUNT"
                       m))))
  dispatch)

 (define acc (make-account 50))

 ((acc 'deposit) 40)
 ((acc 'withdraw) 60)

 (define acc2 (make-account 100))
