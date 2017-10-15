#lang debug racket
(require sicp)
(require racket/trace)
;17m
;11:50->12:02
環境モデルニガテ……。
よくわかってないので調べた
こちらを参照。
https://wizardbook.wordpress.com/2010/12/16/exercise-3-20/

(define (cons x y)
  (define (set-x! v) (set! x v))
  (define (set-y! v) (set! y v))
  (define (dispatch m)
    (cond
      [(eq? m 'car) x]
      [(eq? m 'cdr) y]
      [(eq? m 'set-car!) set-x!]
      [(eq? m 'set-cdr!) set-y!]
      [else
       (error "Undefine operation: CONS" m)
       ]
      ))
  dispatch)

(define (car z) (z 'car))
(define (cdr z) (z 'cdr))
(define (set-car! z new-value)
  ((z 'set-car!) new-value) z)
(define (set-cdr! z new-value)
  ((z 'set-cdr!) new-value) z)

(define x (cons 1 2))
(define z (cons x x))

(set-car! (cdr z) 17)
(car x)

(cdr z)の呼び出しで、まずdispatchクロージャ/環境zのmに'cdr が渡されて、
dispatchクロージャ/環境xが返される
(set!-car! x 17)の呼び出しで、
まずdispatchクロージャ/環境xのmに'set-car!が渡される。
引数はnew-value = 17。これがxに適用される。
'set-car! 引数new-value=17を伴ったままset-x!呼び出しになる。
ここで, v = 17
そして,目的の値が17に変化する。
最後に(car x)でdispatchクロージャ/環境xに対してmに'carが渡されて終わり
ということだと思う。

来週は環境モデルの復習からやりたいな。
