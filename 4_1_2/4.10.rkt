15:53->15:57

代入を、
(set! x y)
じゃなくて
(x <- y)
にしたい。
多分簡単。
他はそのまま。


;;;; 代入を (<var> <- <value>) の形に変形
(define (assignment? exp)
  (if (pair? exp)
    (eq? (cadr exp) '<-)))

(define (assignment-variable exp) (car exp))

(define (assignment-value exp) (caddr exp))

これは触らなくても大丈夫そう。→大丈夫だった
(define (eval-assignment exp env)
  (set-variable-value! (assignment-variable exp)
                       (_eval (assignment-value exp) env)
                       env)
  'ok)

実験室は"mc/4.10.mc.rkt"
らくしょ〜

;;; M-Eval input:
(define x 1)

;;; M-Eval value:
ok

;;; M-Eval input:
x

;;; M-Eval value:
1

;;; M-Eval input:
(x <- 2)

;;; M-Eval value:
ok

;;; M-Eval input:
x

;;; M-Eval value:
2

;;; M-Eval input:
(x <- 3)

;;; M-Eval value:
ok

;;; M-Eval input:
x

;;; M-Eval value:
3
