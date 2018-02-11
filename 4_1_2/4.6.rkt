16:49->17:15

すでにあるこれを使えばなんとかなりそう？
(define (make-lambda parameters body)
  (cons 'lambda (cons parameters body)))

う〜ん。
expsをどうやって渡すかが一番の問題かも。
一個ずつ再帰的に渡していくしかない?

いやまて。
(cons '(a b c) '(1 2 3))
は
'((a b c) 1 2 3)
だ。
だから単にconsでいいじゃん。

(define (let? exp) (tagged-list? exp 'let))

(define (let-var-exp-pairs exp)
  (cadr exp)
  )

(define (let-vars exp)
  (map car (let-var-exp-pairs exp)))

(define (let-exps exp)
  (map cadr (let-var-exp-pairs exp)))

(define (let-body exp)
  (cddr exp))

(define (let->combination exp)
  (let ((_lambda (make-lambda #RR(let-vars exp) #RR(let-body exp))))
    (cons _lambda (let-exps exp))
    )
  )

出来た。
実験室は"mc/4.6.mc.rkt"

(let ((x 2) (y 3)) x)
が
(cons (cons 'lambda (cons (cons 'x (cons 'y '())) (cons 'y '()))) (cons 2 (cons 3 '())))
これに変換されていた。
計算すると
'((lambda (x y) y) 2 3)
バッチリ！
