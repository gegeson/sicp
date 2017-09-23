#lang debug racket
(require sicp)
(require racket/trace)
;21:06->21:18
;21:20->21:26
(define call-the-cops  "警察だ！")
(define (make-account balance password-init)
  (let ((wrong-number 0))
    (define (withdraw password amount)
      (cond
        ((not (eq? password-init password))
         (if (= wrong-number 6)
           call-the-cops
           (begin (set! wrong-number (+ wrong-number 1))
                  "Incorrect password")))
        ((>= balance amount)
         (begin (set! wrong-number 0) (set! balance (- balance amount))
                balance))
        (else ((begin (set! wrong-number 0) "Insufficient funds")))))
    (define (deposit password amount)
      (cond
        ((not (eq? password-init password))
        (if (= wrong-number 6)
          call-the-cops
          (begin (set! wrong-number (+ wrong-number 1))
                 "Incorrect password")))
        (else (begin (set! wrong-number 0) (set! balance (+ balance amount)))
              balance)))
    (define (dispatch m)
      (cond ((eq? m 'withdraw) withdraw)
        ((eq? m 'deposit) deposit)
        (else (error "Unknown request: MAKE-ACCOUNT" m))))
    dispatch))

;良く出来てる解答を写経
;http://uents.hatenablog.com/entry/sicp/027-ch3.1.md
;パスワード関係の処理とアカウント関係の処理を上手く分離している。
;初期預金、初期パスワード、警察を受け取り、
;アカウント初期化、カウンター初期化
;パスワードとメソッドを受け取り、
;初期パスワードとパスワードの一致を調べ、
;一致するなら引き出し、
;一致しなかったらカウンター++、
;カウンターが3以上なら警察呼びだし
;という操作
(define (make-secure-account balance password call-the-cops)
  (let ((account (make-account balance))
        (mistake-counter 0))
    (lambda (pw method)
            (if (eq? pw password)
              (begin (set! mistake-counter 0)
                     (account method))
              (begin (set! mistake-counter (+ mistake-counter 1))
                     (if (< mistake-counter 3)
                       "Incorrect password"
                       (call-the-cops)))))))
