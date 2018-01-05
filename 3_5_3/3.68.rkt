#lang racket/load
(require sicp)
(require (prefix-in strm: racket/stream))
(require "3_5_3/stream.rkt")
; 21:50 ->　22:10

(define (interleave s1 s2)
  (if (stream-null? s1)
      s2
      (cons-stream (stream-car s1)
                   (interleave s2 (stream-cdr s1)))))

(define (pairs s t)
  (interleave
   (stream-map (lambda (x) (list (stream-car s) x))
               t)
   (pairs (stream-cdr s) (stream-cdr t))))

; 問題なく機能するんじゃないかなあ。
; 紙に書いてみたけど、こういう順序になるはず。

; 1, 3, 5, 8
;    2, 6, 10
;       4, 9
;          7

; テストしよう。
(define (stream-head s n)
  (define (iter s n)
    (if (<= n 0)
      'done
      (begin
        (display (stream-car s))
        (newline)
        (iter (stream-cdr s) (- n 1)))))
  (iter s n))

(stream-head (pairs integers integers) 10)

; !?
; 無限ループになった。
; 理由を考えてみる。

; 以下、自分の考察。
; 元のpairsはこの形。

(define (pairs s t)
  (cons-stream
   (list (stream-car s) (stream-car t))
   (interleave
    (stream-map (lambda (x) (list (stream-car s) x))
                (stream-cdr t))
    (pairs (stream-cdr s) (stream-cdr t)))))


; 最大の違いは初項を持っていることかな。
; 初項を持っていないと、carを知りたい、となった時でさえ、
; 再帰が必要になってしまうのでは。
; carが決まっているなら、carに関しては即座に知る事が出来る。
; cdr を知りたいなら再帰。
; cdr の carは即座に知ることが出来る。以下無限ループ。
; 一方、初項が決まってない場合、
; carを知るのにも再帰、cdrのcarを知るのにも再帰、
; で無限に再帰が必要になってしまう。
; 恐らくそういうことだと思われる。
;
; 答えを見た。別に自分のも間違いじゃないが、
; ただ重要なポイントが抜けてたかな。
; cons-streamを使うとcdrは即時評価されない。
; stream-cdrを使う事で初めて呼び出される。
; という事を上の考察に付け加えてたら満点だったかな。まあ合ってることにしよう。

; もっと上手い説明を思いついた。
; cons-streamを使わない再帰は、ストリームじゃなくてただの再帰。
; 終了条件がないただの再帰は無限ループするに決まっている！
