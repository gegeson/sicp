19:47->20:25
---
5.5.2
----
,をつければクォートの中でそこだけ評価されるとは、
なんと都合がいい。
と思ったけどよく考えたら大抵の言語にそういうのあるわ
S式だとそのまま実行に使えるからお得度違うけど
---
(define (end-with-linkage linkage instruction-sequence)
  (preserving '(continue)
   instruction-sequence
   (compile-linkage linkage)))
-
でcontinue使う場合における保険を3パターンのどれに対しても打っておき、
-
(define (compile-linkage linkage)
  (cond ((eq? linkage 'return)
         (make-instruction-sequence '(continue) '()
          '((goto (reg continue)))))
        ((eq? linkage 'next)
         (empty-instruction-sequence))
        (else
         (make-instruction-sequence '() '()
          `((goto (label ,linkage)))))))
-
で実際にcontinueレジスタを使う場合は指定しておく。
-
"再帰的コンパイルはターゲット val とリンク記述子 next を持つので、
コードは結果を val に入れ、その後に 追加されるコードから続行します。
追加は env を保存して行われます。これは、 変数の設定や定義には環境が必要であり、
また変数の値のコードはレジスタを 任意に変更するような複雑な式のコンパイルとなるかもしれないからです。"
ここの最後の
"また変数の値のコードはレジスタを 任意に変更するような複雑な式のコンパイルとなるかもしれないからです。"
がようわからんな。
恐らくだけど、valの計算中にenvが書き換わる可能性がない事もないから、
退避させておいたほうがいいぞってことかな。
---
"追加される二命令の列は、env と val を必要とし、ターゲットを変更します。
この命令列のために env は保存するのに、val は保存しないということに気を つけてください。
これは、この命令列が使うために、get-value-code が結果を 明示的に val に入れるよう設計されていることによります
 (実際、もし val を 保存するとバグになります。こうしてしまうと、get-value-code の実行直後 に val の以前の中身が復元されるようになってしまうからです)。"
うん、ここはOK
スタックにvalを逃しておいて命令終了後valをスタックから取り出すってことをやろうとすると、
折角valに代入値を入れたのに帳消しになって無駄ってことでしょ
---
if文のパラレルなんちゃらが謎。
→実装見たら思ったほど意味不明でもなかった。
単に、consequentとalternativeが別々に実行される事を込み入れつつ
preserving用に変換してるだけかと。
-
ラムダ式の本文が何を言ってるやら…
"ラムダ式の中身の命令はその場に挿入するが、式の途中などにラムダ式があるような場合には、この部分をジャンプして実行が進むようにしなければならない。"
http://d.hatena.ne.jp/tetsu_miyagawa/20150420/1429534972
なるほど？
---
実装見たらわかった。
本体はここにあるよーっていう印と本体をセットで用意して、
印を見た後に下に行きたかったら本体を飛ばしなさいよということか。
compile-lambda-bodyは疑問点なし
---
(define (compile-lambda exp target linkage)
  (let ((proc-entry (make-label 'entry))
        (after-lambda (make-label 'after-lambda)))
    (let ((lambda-linkage
           (if (eq? linkage 'next) after-lambda linkage)))
      (append-instruction-sequences
       (tack-on-instruction-sequence
        (end-with-linkage lambda-linkage
         (make-instruction-sequence '(env) (list target)
          `((assign ,target
                    (op make-compiled-procedure)
                    (label ,proc-entry)
                    (reg env)))))
        (compile-lambda-body exp proc-entry))
       after-lambda))))
---
