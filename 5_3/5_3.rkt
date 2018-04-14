15:54->16:23
16:34->17:32
+3m
17:45->18:12
18:27->19:16

今回もまた一週間ぶり
ガベージコレクションの話。今回も読むだけにする。

ストップアンドコピーアルゴリズムがぜんぜんわからん
_
ここの解説で少し氷解

"Implementation of a stop-and-copy garbage collector

the-carsとthe-cdrsのベクタのペアを２セット用意していて、セルが無くなるまではその片方を使用する。
consしようとして現在使用中のペアのセルを使い切っていた場合には、rootから辿れる全てのセルをもう片方のペアの方にコピーする。
そうするとrootからアクセス出来ないゴミはコピーされないため、コピー後のペアには空きが出来る筈。

セルをコピーする際には元載せるにはコピーが済んでいる目印とコピー先のアドレスを書き込んでおく。
ポインタを辿ってセルをコピーして行く際にはコピーされたセルに入っているポインタはまだ以前のアドレスを指している。
ポインタの先がまだコピーされていなければそれをコピーしてポインタも更新する。ポインタの先が既にコピーされていたら新しいアドレスでポインタを更新する。"
http://d.hatena.ne.jp/tetsu_miyagawa/20150110/1420849534
---
上が非常にわかりやすく、疑問が完全に解決できた

図にある例でトレースしてみよう。
"注意。p1はコピー元の添字1番を指し、p1' はコピー先の添字1番を指している。"
"注意2。/はrootレジスタが指していない任意の値。"

レジスタ: p1
root: p1

コピー元
添字:  0  1  2  3  4  5  6  7
cars  /  p5 n3 /  n4 n1 /  n2
cdrs  /  p2 p4 /  e0 p7 /  e0

まず、rootにあるもの（今回はp1だけ）から参照できる、
添字1の要素をコピー先にコピーし、freeをインクリメントする

コピー先
free: 1
scan: 1

添字:  0  1  2  3  4  5  6  7
cars  p5 /
cdrs  p2 /
---
次に、p5とp2でコピー元を参照し、それもコピーしつつ、
コピーできたらp5, p2をコピーした先に更新する、という風にやっていく
やりきった形がこうなる

free: 5
scan: 5

コピー先
添字:  0   1   2   3   4   5   6   7
cars  p1' n1  n3  n2 n4
cdrs  p2' p3' p4' e0 e0
---
上の例だと遭遇済みなものに当たる事はなかったが、
例えばこういう形だった場合（rootがp1であり、rootのコピーは既に済んでいる）

コピー元
添字:  0  1  2  3  4  5  6  7
cars  /  p5 n3 /  n4 n1 /  n2
cdrs  /  p5 p4 /  e0 p7 /  e0

コピー先
添字:  0  1  2  3  4  5  6  7
cars  p5 /
cdrs  p5 /

carの処理を終えるとこうなり、

コピー元
添字:  0  1   2  3   4   5   6  7
cars  /  済  n3  /  n4  n1  /  n2
cdrs  /  p1' p4  /  e0  p7  /  e0

コピー先
添字:  0   1  2  3  4  5  6  7
cars  p1' n1
cdrs  p5  p3

cdrの処理に進もうとすると、
[済]にぶつかり、p1' を得るので、
p1' に更新する。
後は同じ。

コピー元
添字:  0  1  2  3  4  5  6  7
cars  /  済 n3 /  n4 n1 /  n2
cdrs  /  p1' p4 /  e0 p7 /  e0

コピー先
添字:  0   1  2  3  4  5  6  7
cars  p1' n1
cdrs  p1' p3

後は同じなので略。
---
疑似アセンブラコードによる解説。
解説文が邪魔でしか無かった。
アルゴリズムが頭に入ってる状態だと、
いちいち途中で日本語解説されるより、
遥かにコードだけ読んだほうがわかりやすい。
とりあえず上の例について脳内トレースした。読めてると思う。

begin-garbage-collection
  (assign free (const 0))
  (assign scan (const 0))
  (assign old (reg root))
  (assign relocate-continue (label reassign-root))
  (goto (label relocate-old-result-in-new))
reassign-root
  (assign root (reg new))
  (goto (label gc-loop))

gc-loop
  (test (op =) (reg scan) (reg free))
  (branch (label gc-flip))
  (assign old (op vector-ref) (reg new-cars) (reg scan))
  (assign relocate-continue (label update-car))
  (goto (label relocate-old-result-in-new))

update-car
  (perform
   (op vector-set!) (reg new-cars) (reg scan) (reg new))
  (assign old (op vector-ref) (reg new-cdrs) (reg scan))
  (assign relocate-continue (label update-cdr))
  (goto (label relocate-old-result-in-new))

update-cdr
  (perform
   (op vector-set!) (reg new-cdrs) (reg scan) (reg new))
  (assign scan (op +) (reg scan) (const 1))
  (goto (label gc-loop))

relocate-old-result-in-new
  (test (op pointer-to-pair?) (reg old))
  (branch (label pair))
  (assign new (reg old))
  (goto (reg relocate-continue))
pair
  (assign oldcr (op vector-ref) (reg the-cars) (reg old))
  (test (op broken-heart?) (reg oldcr))
  (branch (label already-moved))
  (assign new (reg free)) ;new location for pair
  ;; update free pointer
  (assign free (op +) (reg free) (const 1))
  ;; Copy the car and cdr to new memory.
  (perform (op vector-set!)
           (reg new-cars) (reg new) (reg oldcr))
  (assign oldcr (op vector-ref) (reg the-cdrs) (reg old))
  (perform (op vector-set!)
           (reg new-cdrs) (reg new) (reg oldcr))
  ;; Construct the broken heart.
  (perform (op vector-set!)
           (reg the-cars) (reg old) (const broken-heart))
  (perform
   (op vector-set!) (reg the-cdrs) (reg old) (reg new))
  (goto (reg relocate-continue))
already-moved
  (assign new (op vector-ref) (reg the-cdrs) (reg old))
  (goto (reg relocate-continue))

gc-flip
  (assign temp (reg the-cdrs))
  (assign the-cdrs (reg new-cdrs))
  (assign new-cdrs (reg temp))
  (assign temp (reg the-cars))
  (assign the-cars (reg new-cars))
  (assign new-cars (reg temp))
