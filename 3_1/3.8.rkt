#lang debug racket
(require sicp)
(require racket/trace)
;20:49->21:04
;
(define f
  (let ((p_x 0) (pp_x 0))
    (printf "定義時？ lambdaの外\n")
    (lambda (x)
      (begin (printf "定義時？ lambdaの中\n")(set! pp_x p_x) (set! p_x x) pp_x))
  ))
;挙動が理解できないのでちょっと実験。
;疑問なのは、p_x, pp_xの初期化はなぜ一度だけなのか？ということ

;実験結果。
;f内の「定義時？lambdaの外」は、fを一度も呼び出差なくとも表示された。
;つまり、letは定義時に実行される。
;1章を読み返すと、letは以下の操作と等しい。
;以下でも、「定義時？lambdaの外」はやはり表示されている。
;し　か　も　
;(f 0), (f 1)を実行しても再度「定義時？lambdaの外」が表示されることはない（1回だけになる）
;ただし、「定義時？lambdaの中」は呼び出した回数と同じだけ表示される
;つまり、p_x <- 0, pp_x <- 0 の初期化は定義時だけに行われる（と推測できる）ため、
;再度呼び出す時に0に代入し直しという事は起きない。
;だからこのfで正しく動くということらしい。
;要するに、関数本体の外で行われる処理は、定義時にただ一度だけ行われるという事らしい。

;(define f
;  ((lambda (p_x pp_x)
;          (printf "定義時？ lambdaの外\n")
;           (lambda (x)
;                   (begin (printf "定義時？ lambdaの中\n")
;                          (set! pp_x p_x) (set! p_x x) pp_x)
;                   )
;           ) 0 0)
;  )
(display (f 0)) ;0
(newline)
(display (f 1)) ;0
(newline)
;0+0 = 0
;上と下4行は同時に実行するべきではない
;（参照透明性がないため、同時に動かした場合と排他的に動かした場合とで挙動が変わる）
;(display (f 1)) ;0
;(newline)
;(display (f 0)) ;1
;(newline)
;;0+1=1

;(display (+ (f 0) (f 1)))
;これだけを動かすと0を出力
(newline)
;(display (+ (f 1) (f 0)))
;これだけを動かすと1を出力
