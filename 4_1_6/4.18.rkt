#lang racket/load
(require (prefix-in strm: racket/stream))
(require "3_5_4/stream.rkt")

ここと一致。合ってるっぽい？
http://wat-aro.hatenablog.com/entry/2015/12/25/212221

こことも一致。
http://d.hatena.ne.jp/tetsu_miyagawa/20131214/1387029694

21:21->21:54
まあ、頭だけで考えても仕方ないので、実際に変換した上で実行してみましょうか。

準備
(define (integral delayed-integrand initial-value dt)
  (define int
    (cons-stream initial-value
                 (let ((integrand (force delayed-integrand)))
                   (add-streams (scale-stream integrand dt)
                                int))))
  int)


まずこれを
(define (_solve f y0 dt)
  (define y (integral (delay dy) y0 dt))
  (define dy (stream-map f y))
  y)

これに変換すると…
(lambda ⟨vars⟩
  (let ((u '*unassigned*)
        (v '*unassigned*))
    (set! u ⟨e1⟩)
    (set! v ⟨e2⟩)
  ⟨e3⟩))

こう。
(define (solve1 f y0 dt)
          (let ((y '*unassigned*)
                (dy '*unassigned*))
            (set! y (integral (delay dy) 0.1 dt))
            (set! dy (stream-map f y))
            y))

(display (stream-ref (solve1 (lambda (x) x) 1 0.0001) 10000))
>0.2718145926825202
ふむ。

ではこちらは？
(lambda ⟨vars⟩
  (let ((u '*unassigned*) (v '*unassigned*))
    (let ((a ⟨e1⟩) (b ⟨e2⟩))
      (set! u a)
      (set! v b))
    ⟨e3⟩))

; こうなる。
(define (solve2 f y0 dt)
    (let ((y '*unassigned*)
          (dy '*unassigned*))
      (let ((a (integral (delay dy) y0 dt))
            (b (stream-map f y)))
        (set! y a)
        (set! dy b)
        y)))

(display (stream-ref (solve2 (lambda (x) x) 1 0.0001) 10000))
>stream-empty?: contract violation
  expected: stream?
  given: '*unassigned*

まあ当たり前。

以下解答。
solve1では。yの定義で dyの'*unassigned* の初期化が上手くdelayで隠されている形になる。
dyの定義を評価するためにyを調べるときには、定義順序のお陰でyが定義済みだし。
一方、solve2では、(stream-map f y)を y: '*unassigned* について調べるからおかしなことになる。
