17:38->18:00
考察は"4.7.考察.rkt"にて。
ここでは主に
let*->nested-lets
の実装を行う。

(let* ((x 3) (y (+ x 2)) (z (+ x y 5)))
  (* x z))

これを

(let ((x 3))
  (let ((y (+ x 2)))
    (let ((z (+ x y 5)))
      (* x z)
      )
    ))

こうすればいいだけでは。
単に再帰的に変換していけばいいだけな気がするぞ。

幾つか小さなバグがあったものの、修正出来て完成！
考察に間違いはなかった！

(define (let*-pairs exp)
  (cadr exp)
  )
(define (let*-body exp)
  (caddr exp)
  )
(define (make-let pairs body)
  (list 'let (list pairs) body)
  )
(define (let*->nested-lets exp)
  (define (iter pairs body)
    (if (null? (cdr pairs))
      (make-let (car pairs) body)
      (make-let (car pairs) (iter (cdr pairs) body)))
    )
  (let ((pairs (let*-pairs exp))
        (body (let*-body exp)))
    (iter pairs body)
    )
  )


;;; M-Eval input:
(let* ((x 3) (y (+ x 2)) (z (+ x y 5)))
  (* x z))

;;; M-Eval value:
39

(๑•̀ㅂ•́)و✧
