11:27->12:14
12:15->12:38
12:44->12:58
+3
13:31->13:52

((x y z).(1 2 3))
から
((x . 1) (y . 2) (z . 3))
に変化する

多分、この三つの修正だけで大丈夫

(define (add-binding-to-frame! var val frame)
  (set! frame (cons (cons var val) frame)))

; 修正後
(define (make-frame variables values)
  (map cons variables values))

; 修正後
(define (frame-variables frame) (map car frame))
(define (frame-values frame) (map cdr frame))

まったく動かない。defineは出来てるはずなのに、lookupで見に行く時になると消えている。
多分set!じゃなくてset-car!、set-cdr!じゃなきゃ変更がスコープ抜けることで帳消しになるんだと思う。
埒が明かなさ過ぎる。答えみるぞ。

参考
http://www.serendip.ws/archives/1875
add-binding-to-frame! がこれになった途端、defineが上手く動いた。
先頭に置くことを妥協してでも確実にset-cdr!で変化をさせているということか。
(define (add-binding-to-frame! var val frame)
  (set-cdr! frame (cons (cons var val) (cdr frame))))

しかし再定義・代入がダメ。ここは原因がわかる。自力でやってみよう。

代入がダメなのは、scanで受け取る引数をmapで生成した上で書き換えてるからだと思う。
別なリストを作って別なリストを代入してるので、元のが書き換わらない。
scanを書き換えればOK。

この二つを削除し、
(define (frame-variables frame) (map car frame))
(define (frame-values frame) (map cdr frame))

この三つを追加し、
(define (first-pair frame)
  (car frame))
(define (pair-variable pair)
  (car pair))
(define (pair-value pair)
  (cdr pair))

scanを以下のように変更する事で上手く行った。
（三つとも似たような変更になっている）
scanの引数をfにしているのは、
frameにするとdefine-variable!に渡すフレームが環境の末端になってしまい上手く行かないから。

(define (lookup-variable-value var env)
  (define (env-loop env)
    (define (scan f)
      (cond ((null? f)
             (env-loop (enclosing-environment env)))
            ((eq? var (pair-variable (first-pair f)))
             (pair-value (first-pair f)))
            (else (scan (cdr f)))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable" var)
        (let ((frame (first-frame env)))
             (scan frame))))
  (env-loop env))

(define (set-variable-value! var val env)
  (define (env-loop env)
    (define (scan f)
      (cond ((null? f)
             (env-loop (enclosing-environment env)))
            ((eq? var (pair-variable (first-pair f)))
             (set-cdr! (first-pair f) val))
            (else (scan (cdr f)))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable -- SET!" var)
        (let ((frame (first-frame env)))
             (scan frame))))
  (env-loop env))

(define (define-variable! var val env)
  (let ((frame (first-frame env)))
       (define (scan f)
         (cond ((null? f)
                  (add-binding-to-frame! var val frame))
                ((eq? var (pair-variable (first-pair f)))
                 (set-cdr! (first-pair f) val))
               (else (scan (cdr f)))))
       (scan frame)))

;;; M-Eval input:
(define x 2)

;;; M-Eval value:
ok

;;; M-Eval input:
x

;;; M-Eval value:
2

;;; M-Eval input:
(define y 3)

;;; M-Eval value:
ok

;;; M-Eval input:
y

;;; M-Eval value:
3

;;; M-Eval input:
(define x 5)

;;; M-Eval value:
ok

;;; M-Eval input:
x

;;; M-Eval value:
5

;;; M-Eval input:
(set! x 7)

;;; M-Eval value:
ok

;;; M-Eval input:
x

;;; M-Eval value:
7

;;; M-Eval input:
y

;;; M-Eval value:
3

;;; M-Eval input:
(set! y 9)

;;; M-Eval value:
ok

;;; M-Eval input:
y

;;; M-Eval value:
9

;;; M-Eval input:

((lambda (y x) y) x y)

;;; M-Eval value:
7
