; 16:48 -> 16:54

exchange手続きは内部でdeposit、withdrawを使っている。
にも関わらず、exchangeがdeposit、withdrawと直列化されているが、
そうすると使えなくなるような気が……
↓
合ってたっぽい。これをデッドロックと呼ぶらしい

;; EXERCISE 3.45

(define (make-account-and-serializer balance)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (let ((balance-serializer (make-serializer)))
    (define (dispatch m)
      (cond ((eq? m 'withdraw) (balance-serializer withdraw))
            ((eq? m 'deposit) (balance-serializer deposit))
            ((eq? m 'balance) balance)
            ((eq? m 'serializer) balance-serializer)
            (else (error "Unknown request -- MAKE-ACCOUNT"
                         m))))
    dispatch))

(define (deposit account amount)
 ((account 'deposit) amount))
