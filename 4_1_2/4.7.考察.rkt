17:20->17:33

本編は4.7.rktにて。

まず、
(eval (let*->nested-lets exp) env)
これを追加するだけで足りるかについて。

多分大丈夫だと思う。
let*をletに変換してからeval
→let?で引っかかる
→(_eval (let->combination exp) env)
で、letがラムダの適用に変換されたものが評価される、
という順序で進む。

ただ、この方法が上手くいかないケースがある気がする。
letの入れ子が機能しない可能性があるから。
これについて実行する前に考察してみよう。

lambda? で引っかかると、
(make-procedure (lambda-parameters exp)
                (lambda-body exp)
                env)
が評価される。
入れ子のletは、(lambda-body exp)
この部分にletが含まれる形になるはず。
そうなると、
実行するまでは入れ子letの中身が評価されないんじゃないかな。

ここで一旦、この考察を実験で確かめることにする。

(let ((x 2))
  (let ((y 3)) y))

きっちり評価されていた。なぜ？

あーミスだ。
よく考えると、lambda?では引っかからないな。
適用の形になるから、正しくはapplication?で引っかかる。
そしてapplication?は再帰的に_evalしてくれるから、その点抜かりない。

実際に#RRを
(_apply (_eval #RR(operator exp) env)
このように仕込むと、
これ
'(lambda (x) (let ((y 3)) y))
'(lambda (y) y)
が表示されていた。

つまり、結論。
let*は入れ子のletに変換した後、
(eval (let*->nested-lets exp) env)
これを計算するだけでよい、はず。
実際には作って試す必要があるが、まあ多分大丈夫。
→実際にこれで動いた。
