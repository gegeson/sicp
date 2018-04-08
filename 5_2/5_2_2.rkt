一週間ぶりに
12:45->13:13
13:16->13:37
5.2.2アセンブラ
ラベルが「fact-loop」などを意味してることに気付くのに無駄に時間を要した

extract-labelsは、
ラベルが来たら(そのラベル+それ以降の命令)+ラベルテーブル
命令が来たら命令の列に加えるだけてラベルは触らない
あとこれ、継続呼び出しみたいなことやってるな。
receiveが下の形してるのは受け取ったときの一回だけで、
(lambda (insts labels)
  (update-insts! insts labels machine)
  insts)

それ以降は
↓これがどんどん膨らんだ形をしている。
(lambda (insts labels)
  (let ((next-inst (car text)))
    (if (symbol? next-inst)
        (receive insts
                 (cons (make-label-entry next-inst
                                         insts)
                       labels))
        (receive (cons (make-instruction next-inst)
                       insts)
                 labels))))

最後にnil nilが渡されて、膨らんだ形から元の形に向かって実行が進む。
だから、一番最初の形に戻るまではrecieveの仕事はひたすら命令・ラベルの振り分けだけだな
update-insts!に渡る時点では、ラベルと命令の対応付けが完了した状態のラベルと命令列が渡されるようになってる。
分かりづらいコードだけど、4.3で鍛えられたから読めるぞ。
