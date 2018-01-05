#lang racket/load
(require sicp)
(require (prefix-in strm: racket/stream))
(require "3_5_3/stream.rkt")
; 11:37 -> 11:59
(define (average x y) (/ (+ x y) 2))

(define (sqrt-improve guess x)
  (average guess (/ x guess)))

(define (sqrt-stream x)
  (define guesses
    (cons-stream
     1.0
     (stream-map (lambda (guess) (sqrt-improve guess x))
                 guesses)))
  guesses)

i(1)をimprove1回適用
i2(1)をimprove2回適用
とすると、自分自身にimproveを適用したものを一つずらしてくっつける、という処理なので、
guesses      1   i(1)   i2(1) i3(1)
guesses 1  i(1)  i2(1)  i3(1)
こういう感じ。

一方これでは…

(define (sqrt-stream2 x)
    (cons-stream
     1.0
     (stream-map (lambda (guess) (sqrt-improve guess x))
                 (sqrt-stream2 x))))

sqrt-stream2を毎回呼んでいるので、
1から計算し直す事を繰り返すのではないかなあ。
メモ化との関係については、
多分、上だと処理に名前を付けているからメモ化が効くけど、下だと異なる呼び出しと見做されてメモ化が効かないんじゃないかなあ。
だからメモ化しない場合だとどちらも同じく無駄な計算をする。

あんまり自信ないし答え見る

→合ってるっぽい。
メモ化の実装のところを読み直すと、
当たり前ながら、メモ化は対象が変わらない場合にしか機能しないんだなあ。
同じ手続きである時のみに機能する。だからまあ当たり前のことか。

「ストリームに名前をつける」 => 「同じ名前のストリームはメモ化及びメモ読み込みが行われる」
