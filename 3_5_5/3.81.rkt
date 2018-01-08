#lang racket/load
(require sicp)
(require (prefix-in strm: racket/stream))
(require "3_5_5/stream.rkt")
; 16:15->16:29
; 16:37->16:49
; 16:54->17:05

; 出来た。
; 完成形は下の方。

; a, f(a), f(f(a)), …

(define (rand-update x)
  (let ((a 27) (b 26) (m 127))
    (modulo (+ (* a x) b) m)))

; 失敗1
(define (random-stream-generater rand-init)
  (cons-stream rand-init
   (cons-stream
    (rand-update rand-init)
      (stream-cdr (random-stream-generater (rand-update rand-init))))))

; (stream-head (random-stream 7) 10)

; 問題文見たら入力がストリームだって書いてる。
; つまりこれボツだ。作り直そう。

; こうかな
; 失敗2
(define (random-stream2 s)
  (cons-stream (rand-update (stream-car s))
               (random-stream2 (stream-cdr s))))

; (stream-head (random-stream2 integers) 10)

; こんな風に格闘してたけど、正直問題の要求がよくわからないのでどうしようもない。
; ヒントだけ拾いに行こう。

; http://uents.hatenablog.com/entry/sicp/040-ch3.5.5.md
; "題意がわかりにくいけど、引数のストリームの要素が定数だったらその定数に初期化、"
; "要素が'generate シンボルだったら乱数を生成するような手続きを実装すればよいらしい。"

; ？
; これでもわからなかったので、更にインターフェイスだけ見てみる（答えは見てないよ！ほんとだよ！）
; (define s
;            (rand-stream
;             (list->stream (list 100 'generate 'generate 'generate
;                            100 'generate 'generate 'generate))))
;=> '(100 86 1 60 100 86 1 60)
; なるほど。今度こそ理解できたと思う。

(define (random-stream s)
  (define (iter s before)
    (if (eq? (stream-car s) 'generate)
      (cons-stream (rand-update before) (iter (stream-cdr s) (rand-update before)))
      (cons-stream (stream-car s) (iter (stream-cdr s) (stream-car s)))))
  (iter s (stream-car s)))

(define s
           (random-stream
            (list->stream (list 200 'generate 'generate 'generate
                           200 'generate 'generate 'generate))))

(stream-head s 8)

; 200
; 92
; 97
; 105
; 200
; 92
; 97
; 105

; 出来てる！

; http://uents.hatenablog.com/entry/sicp/040-ch3.5.5.md
; つかこの人、答えみたら破壊的代入を使っている…
