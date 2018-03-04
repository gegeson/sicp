23:33->23:36
23:41->0:07
0:08->0:13
7:30->7:42
だるいので、方針だけ考えてあとは答え見る
多分だけど、
'(1 2 3)
を
(cons 1 '(2 3))
にすればいいのでは
---
http://www.serendip.ws/archives/2307
合ってた。
でも、再帰的にやらなくてもこれでも機能すると思うんだよなあ。
(define (make-quotation-list lis)
  (list 'cons (car lis) (cons 'quote (cdr lis)))
  )

なんかダメだな…これconsじゃなくてlistにしないとだめか。
(define (make-quotation-list lis)
  (list 'cons (car lis) (list 'quote (cdr lis)))
  )
できたできた。問題なし。
やった。

(define (cons x y)
  (lambda (m) (m x y)))

(define (car z)
  (z (lambda (p q) p)))

(define (cdr z)
  (z (lambda (p q) q)))
