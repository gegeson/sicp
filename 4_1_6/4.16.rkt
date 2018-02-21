21:09->22:07

だるいのでメタ循環評価器の起動はせず
bに関しては必要な関数だけ定義してテストした

a
特記事項なし

(define (lookup-variable-value var env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
             (env-loop (enclosing-environment env)))
            ((eq? var (car vars))
             (if (eq? (car vals) '*unassigned*)
               (error "Unbound variable" var)
               (car vals)
               )
             )
            (else (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable" var)
        (let ((frame (first-frame env)))
             (scan (frame-variables frame)
                   (frame-values frame)))))
  (env-loop env))
---
b

(define (scan-out-define body)
  (let* ((definitions (filter definition? body))
         (not-definition (filter (lambda (x) (not (definition? x))) body))
         (vars (map definition-variable definitions))
         (vals (map definition-value definitions))
         (bindings (map (lambda (v) (list v '*unassigned*)) vars))
         (sets (map (lambda (v e) (list 'set! v e)) vars vals)))
         (cons 'let (cons bindings (append sets not-definition))))
  )

(define a '((define u e1) (define v e2) e3))
(scan-out-define a)
>'(let ((u *unassigned*) (v *unassigned*)) (set! u e1) (set! v e2) e3)

書き換えると
>'(let ((u *unassigned*) (v *unassigned*))
    (set! u e1)
    (set! v e2)
    e3)

ということは、できてる。
結局、cons, list, appendに一番悩まされた。

(define b
  '((define (f a) (* a a))
   (define (g a) (* a 2))
   e))

(scan-out-define b)

>'(let ((f *unassigned*) (g *unassigned*))
   (set! f (lambda (a) (* a a)))
   (set! g (lambda (a) (* a 2)))
   e)

OKOK

ググるとめっちゃややこしくやってる人が多い。
でもこういう時こそmapとfilterの使いどきじゃない？

→解答見てたらmap-filterでやってる人がいたけど、
今のでは内部定義が出てこないケースを無視してた事に気が付いた。
そこを修正してみよう。

(define (scan-out-define body)
  (if (pair? body)
    (let* ((definitions (filter definition? body))
           (not-definition (filter (lambda (x) (not (definition? x))) body))
           (vars (map definition-variable definitions))
           (vals (map definition-value definitions))
           (bindings (map (lambda (v) (list v '*unassigned*)) vars))
           (sets (map (lambda (v e) (list 'set! v e)) vars vals)))
      (cons 'let (cons bindings (append sets not-definition)))
      )
    body)
  )
> (define (c 1) 5)
> (scan-out-define c)
#<procedure:c>

> (define v (* 3 3))
>  (scan-out-define v)
9
よし。
>  (scan-out-define a)
'(let ((u *unassigned*) (v *unassigned*)) (set! u e1) (set! v e2) e3)

>  (scan-out-define b)
'(let ((f *unassigned*) (g *unassigned*))
   (set! f (lambda (a) (* a a)))
   (set! g (lambda (a) (* a 2)))
   e)
a, bも相変わらず動いてるので、今度こそ完成。
---
c

明らかにmake-procedureに組み込んだほうが良いと思う。
何故なら、make-procedureなら一度変換したらあとでbodyを呼ぶ時に変換し直す必要がないが、
procedure-bodyに組み込むと呼び出す度に変換しなくてはいけなくなる。

(define (make-procedure parameters body env)
  (list 'procedure parameters (scan-out-define body) env))
