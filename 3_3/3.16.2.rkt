#lang debug racket
(require sicp)
(require racket/trace)
;7:47->9:21
;ググったら何もかもが違う（問題文の意味を理解できてない）。かすりもしてない。
;悲しい。
;でもトレースしたのはプログラム理解の役に立った。
;ペアが3つ、ということの意味を履き違えてた。図がないとどう誤解してたか説明しづらいが…
;'((a b) (a b) (a b))みたいなやつをペアが3つのリスト、と解釈していた。
;朧気に覚えている解答を見ないで再現することを試みる。
(define (count-pairs x)
  (if (not (pair? x))
    0
    (+ (count-pairs (car x))
       (count-pairs (cdr x))
       1)))
(display (count-pairs '(a b c)))
(newline)
;うん、これが3なのはいい。あとループしたリストが答えを返さない事も。
;問題は対が3つでどうやったら6とか7とかになるのか。
;ループしてたら無限ループするので、自分を参照する、というのは論外。
;じゃあ、carとcdrが同じものを指すしかないだろう。
;試しにやってみよう。まず適当に。
(define a1 (cons 'a 'a))
(define a2 (cons a1 a1))
(define a3 (cons 'a a2))
(display (count-pairs a3))
;4になった。でもなんで？
(newline)
;わかりづらいのでベタに書くと
(display (count-pairs (cons 'a (cons (cons 'a 'a) (cons 'a 'a)))))
;まず、(count-pairs (cons 'a a2)) ここで+1
;(count-pairs (cons a1 a1)) ここで+1
;(cons 'a 'a)ここで+1。これは2回出てくるので、+2。
;合わせて+4、ということだ。

;ん？でもこのロジックなら、全部'aである必要はどこにもないな。
(newline)
(display (count-pairs (cons 'a (cons (cons 'b 'c) (cons 'd 'e)))))
;うん。4になっている。
;ただ、これだと多分、対の数が3つにならないな。
;対の数が3つって制限があったのは、共有状態に限定して考えるためか。
;共有してなくてもいいなら自由度高すぎて多分答えが一意に定まらないんだろう。

;う〜ん。6, 7はどうやって作るんだろう。試しにこうしてみる。
(define a4 (cons a2 a2))
(newline)
(display (count-pairs a4))
;なんかわからんが7になったぞ。
;これもベタに書くと
(newline)
(display (count-pairs (cons (cons (cons 'a 'a) (cons 'a 'a)) (cons (cons 'a 'a) (cons 'a 'a)))))
;こうだな。
;図を書いてみると、たしかに対の数は3つだ。
(newline)
(display (count-pairs (cons (cons (cons 'a 'b) (cons 'c 'd)) (cons (cons 'e 'f) (cons 'g 'h)))))
(newline)
;これも、シンボルを別にしても変わってない。（もちろん対の数は増えるので、題意には沿わないが）
;実験はこの辺にして考えよう。
;まず(count-pairs (cons a2 a2))ここで+1
;(count-pairs (cons a1 a1))ここで+1。（ここ以下の結果は、上を踏まえると二回起きるので、二倍になる。）
;(count-pairs (cons 'a 'a))ここで+1。これはcar, cdrの2回出てくるので、+2。
;よって1+(1+2)*2=7、というわけだ。確かにシンボルが同じかどうかは関係ないな。

;さて、6はどうやって作れるだろう。

;こんなのを考えてみたが、5になった
(define a5 (cons a2 a1))
(count-pairs a5)
;3+1+1なので当たり前か
(count-pairs '(a nil))
;を、これが2になるか。じゃあ…
(define a6 (cons 'a nil))
(define a7 (cons a6 a6))
(define a8 (cons a6 a7))
(count-pairs a8) ;=>5
;う〜〜〜〜〜〜ん。
;3を作って3を2倍、という方針は…と思ったが、2倍にしても必ず1足す操作が追加されるんだったな。
;むずい。
(define a9 (cons 'a 'a))
(define a10 (cons 'a 'a))
(define a11 (cons a10 a9))
(display "a ")
(count-pairs a11)
;色々実験したが、
;二つのリストで2を作る→2*2+1 = 5
;二つのリストで3を作る→3*2+1 = 7
;となってどうしてもうまくいかない。答えを見る。

;！？
;そもそも、6は問われていなかった…だと！？

;代わりに4を考えればいいらしい。4は途中で作れたなあ。。。
;やってみる。
(define a12 (cons 'a 'a))
(define a13 (cons a12 nil))
(define a14 (cons a13 a12))
(count-pairs a14)
;4が出来た。
;簡易トレース。
;まず、a12は1を生成。
;a13は1+1を生成。
;a14はa13 + a12 + 1。これは2+1+1なので4。

;無限ループについては前回のこの関数を使う方針で間違ってないと思う。
(define (last-pair x)
  (if (null? (cdr x))
      x
    (last-pair (cdr x)))
  )
(define (make-cycle x)
  (set-cdr! (last-pair x) x)
  x)
(define a15 (cons 'a (cons 'b (cons 'c nil))))
(define a15-cycle (make-cycle a15))
(count-pairs a15-cycle)
;うん。
