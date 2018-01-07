#lang racket/load
(require sicp)
(require (prefix-in strm: racket/stream))
(require "3_5_3/stream.rkt")

; 自分のも重複なく列挙してることには間違いないので間違いではないはずだが、他の人の回答を見ると、
; もっとたくさんピタゴラス数を見つけられるものがある模様。
; 自分のだと(1, 1, k)をたくさん探すが、その方向にピタゴラス数は少ない（下手したら無い？）。
; 一方この解答だとピタゴラス数に近いものを優先して探すようだ。
; この方法では、
; 「1と(1, 1)以下にあるもの」と
; それぞれのストリームのcdr、つまり
; 「2と(2, 2)以下にあるものと
; 3と(3, 3)以下にあるものと…」
; を混ぜて数列を作っているらしい。

; 以下のサイトから拝借したものを少し改造したものが triples2
; http://uents.hatenablog.com/entry/sicp/038-ch3.5.3.md
; 目視で確認したが、300ぐらい呼び出しても一向に(1, 1, k)が出ないのが不安だな…
; 試しに(1, 1, k)をfilterで3つ表示させてみたら、停止
; 2つでも停止。つまり(1, 1, 2)にすらなかなか辿り着けてない
; これ本当にちゃんと漏れなく呼べてるんだろうか。
; あ、気付いた。これバグだ。この人間違えてる。これだとどうやっても(1, 1, k)は永遠に呼び出せない。
; (1, 1, 1)を呼ぶ→1, 2, …と[2以降、 2以降]でトリプルを作る + s, t, uそれぞれcdrして再帰
; ってやってるから(1, 1, 2)にたどり着くことはない。
; 公式解答を見てみたら、やはり少し違った。下に解説を書いた。

(define (interleave s1 s2)
  (if (stream-null? s1)
    s2
    (cons-stream (stream-car s1)
                 (interleave s2 (stream-cdr s1)))))

(define (pairs s t)
 (cons-stream
  (list (stream-car s) (stream-car t))
  (interleave
   (stream-map (lambda (x) (list (stream-car s) x))
               (stream-cdr t))
   (pairs (stream-cdr s) (stream-cdr t)))))

(define (pythagoras i j k)
  (= (+ (* i i) (* j j)) (* k k)))

  (define (stream-head s n)
  (define (iter s n)
    (if (<= n 0)
      'done
      (begin
        (display (stream-car s))
        (newline)
        (iter (stream-cdr s) (- n 1)))))
  (iter s n))

(define (triples2 s t u)
  (cons-stream
   (list (stream-car s) (stream-car t) (stream-car u))
   (interleave
    (stream-map (lambda (x) (cons (stream-car u) x))
                (pairs (stream-cdr s) (stream-cdr t)))
    (triples2 (stream-cdr s) (stream-cdr t) (stream-cdr u)))))

(define pythagoras-stream2
  (stream-filter
   (lambda (x)
           (pythagoras (car x) (cadr x) (caddr x))
           )
   (triples2 integers integers integers)
   )
  )
; 止まる。永遠に処理が終わらない。
; (stream-head (stream-filter
;               (lambda (x) (and (= (car x) 1) (= (cadr x) 1)))
;               (triples2 integers integers integers)) 2)

(stream-head pythagoras-stream2 5)

; これが公式解答。
; これは、(1, 1, 1)と
; 1 と (1, 1)よりあとのペアのストリーム
; + s, t, uそれぞれcdrした再帰のストリーム
; という風にやってるから問題ない。
; 漏れなく呼び出せている。
; 賢いコードだなあ。
(define (triples3 s t u)
  (cons-stream
   (list (stream-car s) (stream-car t) (stream-car u))
   (interleave
     (stream-map (lambda (x) (cons (stream-car s) x))
                 (stream-cdr (pairs t u)))
     (triples3 (stream-cdr s)
              (stream-cdr t)
              (stream-cdr u)))))

(stream-head (stream-filter
              (lambda (x) (and (= (car x) 1) (= (cadr x) 1)))
              (triples3 integers integers integers)) 2)

(define pythagoras-stream3
  (stream-filter
   (lambda (x)
           (pythagoras (car x) (cadr x) (caddr x))
           )
   (triples3 integers integers integers)
   )
  )

(stream-head pythagoras-stream3 5)
