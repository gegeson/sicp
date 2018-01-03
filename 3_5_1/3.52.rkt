#lang racket/load
(require sicp)
(require (prefix-in strm: racket/stream))
(require "3_5_1/stream.rkt")
; かなり早い段階で解けたと思いこんで答えを見たが、メモ化しない場合についてはボロボロだった
; 19:45 -> 20:36
; 20:40 -> 21:11
; 21:21 -> 21:37
; 10:29 -> 10:41
; ------------------------
; 初めて新しい要素に到達した時だけメモが行われる。
; accumを呼ぶことによって次の要素を作るようにしているので、
; メモ化をしない場合、毎回seqを作り直すようになるため、
; accumがその分多く呼ばれることになる。ということだと思う
; -------------------------
; まずseqの正体を掴んでおく
; -------------------------
(define _sum 0)
(define (_accum x) (set! _sum (+ x _sum)) _sum)
(define (enumerate-interval low high)
  (if (> low high)
      nil
      (cons low (enumerate-interval (+ low 1) high))))

(define _seq
  (map _accum
              (enumerate-interval 1 20)))
(display _seq)
(newline)
; (1 3 6 10 15 21 28 36 45 55 66 78 91 105 120 136 153 171 190 210)
; ------------------------
;   本番
; ------------------------
(define sum 0)
(define (accum x) (set! sum (+ x sum)) sum)
(define seq
  (stream-map accum
              (stream-enumerate-interval 1 20)))
(define y (stream-filter even? seq))
(define z (stream-filter (lambda (x) (= (remainder x 5) 0)) seq))

(display (stream-ref y 7))
(newline)
(display sum)

; とりあえずメモ化する場合について。
; seq = (1 3 6 10 15 21 28 36 45 55 66 78 91 105 120 136 153 171 190 210)
; である。
; この中から偶数だけ抜き取ったものが y であり、
; y = (3 10 28 36 66 78 120 136…)
; (stream-ref y 7) は 136
; （この説明の順序は遅延評価の流れとは一致していない）
; seqはここまでしか進まないので、
; sum = 136
(newline)
(display-stream z)
(newline)
(display sum)

; この値はメモ化しないなら
; sum = 210
; メモ化しないなら
; sum = 136+210
; で、かつ最初から表示される？
; と思ったけど調べたらだいぶ違う。

; 以下のサイトを読んだ。
; http://d.hatena.ne.jp/tetsu_miyagawa/20131005/1380923143
; なるほど。
; y, zの定義時でもストリームは実は一つ目の要素を取得するまでは走る。
; メモ化しない場合、そこでもseqの先端からy, zの一つ目まで、でもやり直しが生じる分、
; sumは 136+210 よりもっと積もり積もっていくみたいだ。

; 初めて新しい要素に到達した時だけメモが行われる。

; filterでは、accumを呼ぶことによって次の要素を作るようにしている。
; メモ化をしない場合、毎回seqを1以降から作り直すようになるため、
; accumがその分多く呼ばれることになる。ということだと思う
; メモ化しない場合にy呼び出しで(accum 1)が呼ばれずに(accum 2)から始まるのは、
; seq定義の時点でseqの先頭は作られていてfilterで先頭から作り直す必要が無いため。
; 同じように、y定義、z定義でもメモ化ではないがそこまでが固定されるので、
; (stream-ref y 7)は4から、
; (display-stream z)は5から、
; になるのだろうと思う。
; こちらのサイトの画像も参考になる。
; http://www.serendip.ws/archives/1563
; 改めて考えると、
; seqの続きを作るためにaccumを呼ぶ必要があり、accumを呼ぶ副作用としてsumが増える、
; という事がポイントだと思う。
; メモ化する場合だとseqの続きを作る上でリセットしないので、毎回1から作る必要がなくなり、
; accumは必要なだけ呼ばれることになり、sumは必要以上に増えない。
; メモ化しない場合だとseqの続きを作ってはリセット、作ってはリセットとするので、
; その都度accumを呼ぶことになり、sumはどんどん大きくなる。

; いや〜しかし自力じゃ絶対気付かなかっただろうなこれ。
; 気付く人達すごい。何をやればそうなれるんだ
