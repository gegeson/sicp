5+
15:49->16:22

派生式の方はすぐに方針が思いついた。
こんなふうに変形するだけで出来る。
あとは再帰的にルールを適用してやれば良い。
実験室は "mc/4.4.2.mc.rkt" にて。

17:05->17:12
順序について
eval-ifを書き換える必要がありそうだけどだるいのでパス

---
(and a b)
は
(if a
  (if b
    b
    false)
  false)
---
(and a b c)
は
(if a
  (if b
    (if c
      c
      false)
    false)
  false)
---
(define (and? exp)
  (tagged-list? exp 'and))

(define (and-operands exp)
  (cdr exp))

(define (and->if exp)
  (define (and->if-sub operands)
    (if (null? operands)
      'true
      (make-if (car operands)
               (and->if-sub (cdr operands))
               'false)
      )
  )
(and->if-sub (and-operands exp))
)

実験して気付いたが、
make-ifに#t/#fを渡してしまうと、インタプリタ側は#t/#fではなくtrue/falseで偽を解釈しているので、
バグった。
'true/'false を渡す必要があった。
それでは or いってみよう
---
(or a b)
は
(if a
  a
  (if b
    b
    false))
---
(or a b c)
は
(if a
  a
  (if b
    b
    (if c
      c
      false)))
---
(define (or? exp)
  (tagged-list? exp 'or))

(define (or-operands exp)
  (cdr exp))

(define (or->if exp)
  (define (or->if-sub operands)
    (if (null? operands)
      'false
        (make-if (car operands)
          (car operands)
         (or->if-sub (cdr operands)))
      )
    )
  (or->if-sub (or-operands exp))
  )

実験した結果出来ているっぽい。
