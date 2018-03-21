とにかくやる気がない。
とにかく早く5章に進みたい。
ということで、
とりあえずこの節読んだら5章に行くことにした。
問題は解かない。
もっというとさっさとSICP読み終えたいのだ。
読み始めてからもうすぐ一年経つし。

18:25->18:51

これから
(assert! (married Minnie Mickey))
これが決まらないのはまあ分かる
(married Mickey ?who)

しかし、これが無限ループというのは驚き
(assert! (rule (married ?x ?y) (married ?y ?x)))
(married Mickey ?who)

単純に、片側だけが変数になってマッチが成功する場合でも、
無限再帰みたいにもう一回規則を適用してしまうからかな。と思う
再帰呼び出しを行っていいのは、引数が全部決定する時だけなんだろうな
---
(and (supervisor ?x ?y)
(not (job ?x (computer programmer))))

下がなんでダメかよくわかってない
(and (not (job ?x (computer programmer)))
     (supervisor ?x ?y))
notの実装は、入力フレームと変数を見て、
変数が入力フレームの中に現れるものを弾くという風になっているから、なのかな
上の例だと?xが既に登場してるからnotで弾けるようになっているけど、
下は未登場だから全部弾くようになってしまう。
という微妙な理解
---
4.68の答えだけみて理解
http://uents.hatenablog.com/entry/sicp/066-ch4.4.2.md
(assert! (rule (reverse (?z . ())  (?z))))

(assert! (rule (reverse (?u . ?v) ?x)
               (and (reverse ?v ?y)
                    (append-to-from ?y (?u) ?x))))
zをひっくり返すとz
u . v　をひっくり返すとxになる時、
yはvをひっくり返したものだとするのなら、
(append y u) はxになる
まあ、当たり前なのかな
