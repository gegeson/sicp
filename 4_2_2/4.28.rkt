15:28->15:58

引数はともかく、演算子だけはその時点で評価しておきたい。
何故？
例を考えよ、という問題。

(define (unless condition usual-value exceptional-value)
  (if condition
    exceptional-value
    usual-value))

(define (factorial n)
  (unless (= n 1)
    (* n (factorial (- n 1)))
    1))

上のfactorialが強制しないと動かなくなる？　という事を考えたけどそんなことはなかった。
呼び出すときには再帰的にforceが行われるんだから、そんなことはないよなあ。

(define (try a b) (if (= a 0) 1 b))
これはどうだろう。
同じだった。
---
わからない。例が思い浮かばない。
---
答えを見た。
高階手続きがポイントであるらしい。
以下より参照。
http://wat-aro.hatenablog.com/entry/2016/01/07/193530

(define (foo bar)
  (bar 'a))

"引数はすべてthunkなので(bar 'a)でbarをevalしても手続きとならない．
applyでoperatorをactual-valueを使わないと手続きを引数に取る場合に困る．"

実際にやってみた。
---
;;; L-Eval input:
(define (foo bar)
  (bar 'a))

;;; L-Eval value:
ok

;;; L-Eval input:
(foo display)
Unknown procedure type -- apply {thunk display #0={{{foo false true car cdr cons null? assoc + - * / = < > printf display} {procedure {bar} {{bar {quote a}}} #0#} #f #t {primitive #<procedure:mcar>} {primitive #<procedure:mcdr>} {primitive #<procedure:mcons>} {primitive #<procedure:null?>} {primitive #<procedure:massoc>} {primitive #<procedure:+>} {primitive #<procedure:->} {primitive #<procedure:*>} {primitive #<procedure:/>} {primitive #<procedure:=>} {primitive #<procedure:<>} {primitive #<procedure:>>} {primitive #<procedure:printf>} {primitive #<procedure:mdisplay>}}}}
---
(foo display)はどういう実行順序をたどるだろうか。
まず、呼び出し時にdisplayはサンク化される。
(foo display)呼び出しの時に初めてそれぞれがforceされ、
fooの定義に飛び、
((thunk display env) 'a)
こうなる。
これは上の実験結果と一致しているな。
で……評価された結果がこの形になって、
更にここがevalでapplication?に振り分けられて、
再びapplyに渡る、という順序だと思うけど、
thinkは実行できないからエラーが出てる、ということかなあ。
-----
通常版でうまくいく理由がわからなくなってきた…
考える。
