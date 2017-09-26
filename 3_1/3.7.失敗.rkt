#lang debug racket
(require sicp)
(require racket/trace)
;21:21->21:45
;失敗作。アカウントが別でも同じパスワードでログイン可能。
;もう2作ぐらい失敗作を作ったが載せてない
(define (make-account balance password-init)
  (let ((passlist (cons password-init nil)))
    (define (has_pass? pass passlist)
      (cond
        ((null? passlist) #f)
        ((eq? (car passlist) pass) #t)
        (else
         (has_pass? pass (cdr passlist))
         )
        ))
    (define (add-password newpass)
      (set! passlist (cons newpass passlist))
      )

    (define (withdraw password amount)
      (cond
        ((not (has_pass? password passlist)) "Incorrect password")
        ((>= balance amount)
         (begin (set! balance (- balance amount))
                balance))
        (else ("Insufficient funds"))))
    (define (deposit password amount)
      (cond
        ((not (has_pass? password passlist)) "Incorrect password")
        (else (set! balance (+ balance amount))
              balance)))
    (define (dispatch m)
      (cond ((eq? m 'withdraw) withdraw)
        ((eq? m 'deposit) deposit)
        ((eq? m 'check_pass) check_pass)
        ((eq? m 'add_pass) add-password)
        (else (error "Unknown request: MAKE-ACCOUNT" m))))
    (define (check_pass pass)
      (if (has_pass? pass passlist)
        #t
        #f)
      )
    dispatch))
(define acc (make-account 100 "aiueo"))

;(define acc (make-account 100 "aiueo"))
(display ((acc 'withdraw) "aiuoe" 50))
(newline)
(display ((acc 'withdraw) "aiueo" 50))
(newline)
(display ((acc 'deposit) "aiueo" 5000))
(newline)
(display ((acc 'deposit) "aiuow" 5000))
(newline)

(define (make-joint acc pass newpass)
  (cond
    (((acc 'check_pass) pass)
      (begin ((acc 'add_pass) newpass)
             acc)
     )
  (else
      (display "パスワードが違います")
   )
  ))
(define neko (make-joint acc "aiueo" "akstn"))

(display ((neko 'withdraw) "akstn" 50))
(newline)
(display ((neko 'withdraw) "aiueo" 50))
(newline)
(display ((neko 'deposit) "aiueo" 5000))
(newline)
(display ((neko 'deposit) "akstn" 5000))
(newline)
