20:51->21:02

元のバージョンと
(define (eval-sequence exps env)
  (cond ((last-exp? exps) (_eval (first-exp exps) env))
        (else (_eval (first-exp exps) env)
              (eval-sequence (rest-exps exps) env))))

改善版とで
(define (eval-sequence exps env)
  (cond ((last-exp? exps) (_eval (first-exp exps) env))
        (else (actual-value (first-exp exps) env)
              (eval-sequence (rest-exps exps) env))))

以下の関数における
(p1 1)
(p2 1)
の挙動を調べる。

(define (p1 x)
  (set! x (cons x '(2)))
  x)

(define (p2 x)
  (define (p e)
    e
    x)
  (p (set! x (cons x '(2)))))

元のバージョンで両方考える。
(p1 1)は、
プリミティブなconsに渡っているので、
(1 2)
を返すはず。
(p2 1)は、
pが手続き(set! x (cons x '(2))を受け取っているが、
多分これはthunk化されるはず。
しかし、
pでは特にeの強制が起きないので、xはそのまま、なんじゃないかな。
---
→実行したら、当たってた。
つまり、ここでは強制が起きてないのは確かだなあ。
---
変更した版なら、強制が確実に起きるから、
両方(1 2)になるんじゃなかろうか？
---
→合ってた。
