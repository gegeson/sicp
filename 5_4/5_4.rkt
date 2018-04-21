9:51->10:51
10:56->11:01

また一週間ぶり。
今回も読むだけ。
---
なるほど。
基本演算を色々用意しておくから想像してたほどえげつないことにはならないらしい。
---
いつもどおり理解度チェックのためのトレースをやる
---
(define example
  (lambda (a b)
    (+ a b)
  )
)

(define x 2)
---
上の環境で
(example (+ 1 x) (+ 3 x))
を評価するとき、を考えてみる
まず
dispatchでev-applicationに移り、
continueとenvがスタックに積まれ、
envにはexampleとxが保存され、
unevには((+ 1 x) (+ 3 x))が保存される。
expにはexampleが保存される。
この状態で、もう一回dispatch。
ただし、continueにはev-appl-did-operatorが保存されている。

次は(+ 1 x)を見ることになる。
envはさっきと同じ。
unevには(1 x)がさっきのものに乗っかる
expには+が来る。
この状態で、更にcontinueにev-appl-did-operatorが代入され
もう一回dispatch。
+がどう評価されるのか書いてないな…。

まだ本に出てきてないコードも読んでみる。
恐らく+でev-variableに引っかかり、
+がvalに代入された状態で
ev-appl-did-operator
に移り、
1, xおよび環境を持っててきつつ、
apply-dispatchに飛ぶ。
そこのprimitive-procedure?に引っかかり、
更にprimitive-applyに引っかかり、
…ここで詰まった。
agrlってここまで追いかけた感じだと、空リストのはずなんだけどな…
先を読み進めよう
なるほど、掲載コードの表記が悪い気がする。
スペースあいてるけど、
ev-appl-did-operator
で(save proc)したあとはそのまま
ev-appl-operand-loop
に進むんだな。
なら完全に納得がいくわ
---
1の評価とx=2の評価をした上でarglを(1 2)とし
（arglの詳細は普通に追えたけど結構煩雑なのでスキップ）
その状態でprimitive-applyに向かうから、(+ 1 2)が計算できるはずだ。
example視点でも引数それぞれに対してこれを再帰的に繰り返していくだけだから、
もうほぼ納得行ったかなと思う
---
