; 16:11->16:24
; 元のもの
(define (list-of-values exps env)
  (if (no-operands? exps)
      '()
      (cons (eval (first-operand exps) env)
            (list-of-values (rest-operands exps) env))))
; 要するに、
; x = 2, y = 3 の環境で
; (+ (sqrt 2) (* x y))
; みたいのが与えられた時に
; ((sqrt 2) (* x y))
; を
; (1.4142…　6)
; に変換して返す関数なんだろうな。
; んで、引数を評価する順番を固定したい。

; ここにletを使う、と書いてあったのでこういうことではなかろうか。
; http://kinokoru.jp/archives/711

(define (list-of-values exps env)
  (if (no-operands? exps)
      '()
    (let ((first (eval (first-operand exps) env)))
      (let ((rest (list-of-values (rest-operands exps) env)))
      (cons first rest)
        )
      )))

; 逆に、後ろから評価したいのなら
; こうかな
(define (list-of-values exps env)
  (if (no-operands? exps)
      '()
    (let ((rest (list-of-values (rest-operands exps) env)))
      (let ((first (eval (first-operand exps) env)))
      (cons first rest)
        )
      )))

; 合ってるっぽい？
; http://www.serendip.ws/archives/1808
