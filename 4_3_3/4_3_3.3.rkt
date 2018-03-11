14:57->15:49

考察ノート3

(set! x 2)
評価時

succeedの元の姿はこれ
(lambda (val next-alternative)
        (announce-output output-prompt)
        (user-print val)
        (internal-loop next-alternative))

こいつに渡ることで
(define (analyze-assignment exp)
  (let ((var (assignment-variable exp))
        (vproc (analyze (assignment-value exp))))
       (lambda (env succeed fail)
               (vproc env
                      (lambda (val fail2) ; *1*
                              (let ((old-value
                                      (lookup-variable-value var env)))
                                   (set-variable-value! var val env)
                                   (succeed 'ok
                                            (lambda () ; *2*
                                                    (set-variable-value! var
                                                                         old-value
                                                                         env)
                                                    (fail2)))))
                      fail))))


こうなる
(lambda (val fail2) ; *1*
        (let ((old-value
                (lookup-variable-value var env)))
             (set-variable-value! var val env)
    (announce-output output-prompt)
    (user-print 'ok)
    (internal-loop
      (lambda () ; *2*
            (set-variable-value! var
                                 old-value
                                 env)
        (fail2)))))

fail2が何者かは文脈で決まる
internal-loopの引数がtry-againなので、try-againすると
(lambda () ; *2*
      (set-variable-value! var
                           old-value
                           env)
  (fail2))
が呼ばれることになる

ここいらで実験
set! のあとで(amb)を呼ぶと、set!が無かったことになる

;;; Amb-Eval input:
(define x 0)

;;; Starting a new problem
;;; Amb-Eval value:
ok

;;; Amb-Eval input:
(begin (set! x 1) (amb))

;;; Starting a new problem
;;; There are no more values of
(begin (set! x 1) (amb))

;;; Amb-Eval input:
x

;;; Starting a new problem
;;; Amb-Eval value:
0

;;; Amb-Eval input:
(begin (set! x 1) )

;;; Starting a new problem
;;; Amb-Eval value:
ok

;;; Amb-Eval input:
x

;;; Starting a new problem
;;; Amb-Eval value:
1

;;; Amb-Eval input:
(begin (set! x (+ x 1)) (set! x (+ x 1)))

;;; Starting a new problem
;;; Amb-Eval value:
ok

;;; Amb-Eval input:
x

;;; Starting a new problem
;;; Amb-Eval value:
3

;;; Amb-Eval input:
(begin (set! x (+ x 1)) (set! x (+ x 1)) (amb))

;;; Starting a new problem
;;; There are no more values of
(begin (set! x (+ x 1)) (set! x (+ x 1)) (amb))

;;; Amb-Eval input:
x

;;; Starting a new problem
;;; Amb-Eval value:
3

なぜ？
なぜ失敗は伝搬するのか？
ここがわかってない。
多分だけど、
成功継続がペアに持つ失敗継続は加工されながら次へ次へと渡される。
失敗継続がある一点で呼ばれると、加工されてきた失敗継続の最終型が呼ばれる。
それはこれまでの失敗継続をすべて含んだものである。
ということだろうとは思うが、実装と結びつかない…
