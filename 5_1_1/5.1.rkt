20:36->21:11
きったない図な上に間違ってたので解答は貼らず。
+と*は一つのレジスタなんだなあ。
iterで一つと考えてしまった。そこが敗因だ。
あと入れ替えじゃないなら中間変数不要だったんだな
まあ理解は出来たからいいか。

解答は以下を参照
http://uents.hatenablog.com/entry/sicp/071-ch5.1.md
http://www.serendip.ws/archives/2858

(define (factorial n)
  (define (iter product counter)
    (if (> counter n)
        product
        (iter (* counter product)
              (+ counter 1))))
  (iter 1 1))
