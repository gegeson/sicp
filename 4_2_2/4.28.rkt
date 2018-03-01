15:28->15:58
+19m
18:14->18:19

引数はともかく、演算子だけはその時点で評価しておきたい。
何故？
例を考えよ、という問題。
---
（役に立たない考察だったのでカット）
---
わからない。例が思い浮かばない。
---
答えを見た。
高階手続きがポイントであるらしい。
色々見たが、以下で氷解した。
http://community.schemewiki.org/?sicp-ex-4.28

(define (g x) (+ x 1))
(define (f g x) (g x))

つまり、
引数は何であれthunk化されるが、
引数が関数であり、尚且つ上のようにfの中で引数gを使っている場合、
(g x)の適用の時にthunk化されたまま評価する、という事をやろうとしてしまう。
これは無理。
だから強制するべし、ということだと思う。

実際にやってみた。
---
;;; L-Eval input:
(define (g x) (+ x 1))

;;; L-Eval value:
ok

;;; L-Eval input:
(define (f g x) (g x))

;;; L-Eval value:
ok

;;; L-Eval input:
(f g 10)
Unknown procedure type -- apply {thunk g #0={{{f g false true car cdr cons null? assoc + - * / = < > printf display} {procedure {g x} {{g x}} #0#} {procedure {x} {{+ x 1}} #0#} #f #t {primitive #<procedure:mcar>} {primitive #<procedure:mcdr>} {primitive #<procedure:mcons>} {primitive #<procedure:null?>} {primitive #<procedure:massoc>} {primitive #<procedure:+>} {primitive #<procedure:->} {primitive #<procedure:*>} {primitive #<procedure:/>} {primitive #<procedure:=>} {primitive #<procedure:<>} {primitive #<procedure:>>} {primitive #<procedure:printf>} {primitive #<procedure:mdisplay>}}}}
----
説明通りの結果になってる！
---
この問題と解答のお陰で理解できたが、
遅延が起きるタイミングは関数適用で引数が渡された時の引数に限られるんだな。

逆に遅延の強制が起こるのは、
・関数適用の時（関数に限る）
・基本手続きに引数が渡された時
・if文の条件節
・出力
だけなんだ（コードでも確認）。

なるほどおお
