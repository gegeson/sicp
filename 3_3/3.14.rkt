#lang debug racket
(require sicp)
(require racket/trace)
;21:02->21:22
(define (mystery x)
  (define (loop x y)
    (if (null? x)
      y
      (let ((temp (cdr x)))
        (set-cdr! x y)
        (loop temp x))))
  (loop x nil)
  )

;をトレースチャレンジ！
;(loop '(a b c d) nil)
;x: '(a b c d)
;y: nil
;temp <- '(b c d)
;x <- '(a)
;
;(loop '(b c d) '(a))
;x: '(b c d)
;y: '(a)
;temp <- '(c d)
;x <- (b a)
;
;(loop '(c d) (b a))
;x: '(c d)
;y: '(b a)
;temp <- (d)
;x <- (c b a)
;
;(loop (d) (c b a))
;x: (d)
;y: (c b a)
;temp <- nil
;x <- (d c b a)
;
;(loop nil (d c b a))
;=>(d c b a)
;よって逆転したリストを返す
;適用後はv, wともに(d c b a)になるのでは？
(define v '(a b c d))
(define w (mystery v))
(display v)
;=>(a)
(newline)
(display w)
;=>(d c b a)
;違った。
;わかった。よく見ると、xは2回目のloop呼び出しでyに渡されている。
;しかもyは一切書き換えられてないので、ここでのyの値がvになるということだ。
