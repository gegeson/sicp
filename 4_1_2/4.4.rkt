16:29->16:54
先に派生式版を解いた。
おそらくand? and-operandsなどはこっちでも使うはず。
あとはとりあえず eval-if を真似ればいいんじゃね？
出来てるっぽい。
実験は "mc/4.4.1.mc.rkt" にて。

16:58->17:01
順序について考えてなかったので修正。

(define (and? exp)
  (tagged-list? exp 'and))

(define (and-operands exp)
  (cdr exp))

(define (eval-and exp env)
  (define (eval-and-sub operands)
    (if (null? operands)
      #t
      (let ((first (eval (car operands) env)))
        (if (false? first)
          #f
          (eval-and-sub (cdr operands))
          )))
      )
  (eval-and-sub (and-operands exp))
  )

(define (or? exp)
  (tagged-list? exp 'or))

(define (or-operands exp)
  (cdr exp))

(define (eval-or exp env)
  (define (eval-or-sub operands)
    (if (null? operands)
      #f
      (let ((first (eval (car operands) env)))
        (if (true? first)
          #t
          (eval-or-sub (cdr operands)))))
    )
  (eval-or-sub (or-operands exp))
  )
