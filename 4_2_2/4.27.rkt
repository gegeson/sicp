14:50->15:27

(define count 0)

(define (id x)
  (set! count (+ count 1))
  x)

(define w (id (id 10)))

それぞれがどういう値を返すかの穴埋め。
実行せず想像。（結果・考察共に間違っていた。実行結果は下）
--------------------
;;; L-Eval input:
count
;;; L-Eval value:
? -> 0

;;; L-Eval input:
w
;;; L-Eval value:
? -> 10

ここはちょっと考えてみよう。
まず、REPLの出力に来てるので、
force-itで再帰的に(id (id 10))が評価されるはず。
(id ((id 10)のサンク))
count += 1
返り値は(id 10)
これもまた評価されて、
count += 1
返り値は10
だからここは10だな。

countは二つ回ってるので、最後は2。
;;; L-Eval input:
count
;;; L-Eval value:
? -> 2
-----------------
実際の結果
;;; L-Eval input:
count

;;; L-Eval value:
1

;;; L-Eval input:
w

;;; L-Eval value:
10

;;; L-Eval input:
count

;;; L-Eval value:
2

さて、wが評価されていない時点でcountが1回っていた。
これについて調べ、考えてみよう。
----
(define w (id 10))
としても同様に、いきなりcountが1だった。何故か。
----
先に評価されるのを内側と間違えてたのでこちらを参照し修正。
http://d.hatena.ne.jp/tmurata/20100430/1272628240

つまり、定義時には
 (define w (サンク化された(id 10)))
こうなる。
外側のid自体は評価されてcount += 1となるが、引数の評価は遅れる。
更にここからwを呼ぶことでサンクが強制されて、
10が返り、内側のidが評価されてcount += 1となる。

ふつうのインタプリタでは評価時にwが2になる模様。
