#lang racket/load
(require sicp)
(require (prefix-in strm: racket/stream))
(require "3_5_1/stream.rkt")
; 18:36 -> 18:50
; -------------------------------
; 比較するために、ストリームを使わないとどうなるかチェック
; 実行結果を見ると、ストリームを使わない版ではlist-ref呼び出し前の時点でlistの中身が表示されている。
; 一方、ストリームを使う版では、5, 7だけが表示されている。
; これは遅延評価しない場合では定義時に_xのすべてが評価されるのに対し、
; 遅延評価する場合では、stream-refが要求している値以外は評価しないため、5, 7しか表示されない。
; ------------------------------
; ぐぐったところ、結果がなんかどこ見ても違う。
; https://wizardbook.wordpress.com/2010/12/20/exercise-3-51/
; ↑などを見ると↓こんな結果を出している。言われてみればこれの方が正しい気がするなあ。でも実装の問題だし深入りしないでおこう。
; ---------------------
; (define x (stream-map show (stream-enumerate-interval 0 10)))
; 0
;
; (stream-ref x 5)
; 1
; 2
; 3
; 4
; 5
;
; (stream-ref x 7)
; 6
; 7
; ----------------------
; http://d.hatena.ne.jp/tetsu_miyagawa/20131005/1380923143
; ググったら、Racketのstreamパッケージではこうなる、ということらしい。
; -----------------------
(define (show x)
  (display-line x)
  x)

(define _x
  (map show
              (list 0 1 2 3 4 5 6 7 8 9 10)))
(newline)
(display "list-ref呼び出し前")
(newline)
(display (list-ref _x 5))
(newline)
(display (list-ref _x 7))
(newline)

(define x
  (stream-map show
              (stream-enumerate-interval 0 10)))

(stream-ref x 5)
(stream-ref x 7)
