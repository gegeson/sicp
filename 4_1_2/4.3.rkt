; 18:40->18:57
; 19:03->19:53

データ主導ってなんだっけ？
思い出せない。2章を読み返す。

put 演算　型　引き出したい関数
という風に型に関する関数を登録しておき、
get 演算　型
という風にその型に対する演算を呼び出す、
というのがデータ主導だった。
これをやると、型を追加しても登録さえしておけば都度都度場合分けの更新を行わずに済む、という手法だった。

「式の型としては、複合式の car を使ってよい」
という記述がイミフだったが、これは単に型を取ってくる関数は言語に用意されてる方のcarでいいよ、
という意味かな？

「self-evaluating?」と「variable?」
は2.73同様データ主導で扱えないと思うけど、
それ以外は「set!」とか「define」とかを型として扱えばなんとでもなる気がするな。

出来た。
application?は問題4.2のcallが必須だ。
偶然視界に入って気づけた。
"mceval/4.3.mceval.rkt"
にて実験した。

(define (install-eval-package)
  (define (quoted? exp env)
    (text-of-quotation exp)
    )
  (define (assignment? exp env)
    (eval-assignment exp env))
  (define (definition? exp env)
    (eval-definition exp env))
  (define (if? exp env)
    (eval-if exp env))
  (define (lambda? exp env)
    (make-procedure (lambda-parameters exp)
      (lambda-body exp) env)
    )
  (define (begin? exp env)
    (eval-sequence (begin-actions exp) env))
  (define (cond? exp env)
    (eval (cond->if exp) env))
  (define (application? exp env)
     (apply (eval (operator exp) env)
     (list-of-values (operands exp) env)))
  (put 'eval 'quote quoted?)
  (put 'eval 'set! assignment?)
  (put 'eval 'define definition?)
  (put 'eval 'if if?)
  (put 'eval 'lambda lambda?)
  (put 'eval 'begin begin?)
  (put 'eval 'cond cond?)
  (put 'eval 'call application?)
  )

(define (operator exp) (cadr exp))
(define (operands exp) (cddr exp))

(install-eval-package)

(define (eval exp env)
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
        (else
          ((get 'eval (car exp)) exp env)
         )
    )
)

出来てるっぽいな

以下、実験の様子
+ とかが使えないみたいなので出来ることは狭い

;;; M-Eval input:
(define x 2)

;;; M-Eval value:
ok

;;; M-Eval input:
x

;;; M-Eval value:
2

;;; M-Eval input:
(quote aiueo)

;;; M-Eval value:
aiueo

;;; M-Eval input:
(set! x 5)

;;; M-Eval value:
ok

;;; M-Eval input:
x

;;; M-Eval value:
5

;;; M-Eval input:
(if true 2 1)

;;; M-Eval value:
2

;;; M-Eval input:
(if false 2 1)

;;; M-Eval value:
1

;;; M-Eval input:
(call (lambda (x) x) 2)

;;; M-Eval value:
2

;;; M-Eval input:
(begin 1 2)

;;; M-Eval value:
2

;;; M-Eval input:
(cond (true 1) (else 2))

;;; M-Eval value:
1

;;; M-Eval input:
(cond (false 1) (true 3) (else 2))

;;; M-Eval value:
3
