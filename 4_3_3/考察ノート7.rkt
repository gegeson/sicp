今度これやってみよう

12:29->12:58

(define (require p)
  (if (not p) (amb)))

(define x false)
(define y false)

(begin
  (set! x (amb 0 1))
  (set! y (amb 0 1))
  (set! y (+ y 1))
  (require (= y 2))
  (x y))
(0 1)
(1 1)
が表示されて終わるはず。
---
(set! x (amb 0 1))呼び出しにより、
(amb 1)がxの失敗継続にセットされる。
(set! y (amb 0 1))呼び出しにより、
(amb 1)がyの失敗継続にセットされる。
---
---
sequentiallyにbeginのそれぞれが渡される
---
a1: (set! x (amb 0 1))
a2: (set! y (amb 0 1))
a3: (set! y (+ y 1))
a4: (require (= y 2))
a5: (x y)
---
(lambda (env succeed fail)
        (a1 env
           ;; a を呼び出す時の成功継続
           (lambda (a1-value fail2)
                   (a2 env succeed fail2))
           ;; a を呼び出す時の失敗継続
           fail))
---
(vproc env
       (lambda (val fail2) ; *1*
             ((set-variable-value! var val env)
              ((a2 env default-succeed
                (lambda () ; *2*
                      (set-variable-value! 'x
                                           false
                                           env))
                      (fail2)))
       default-fail)))
---
vprocはsucceed呼んで値返して終わり
→じゃない。(amb 0 1)だった。
0を評価し、
(amb)が空になったら受け取った失敗継続を返し、
(amb 1)に進む失敗継続を与えて次に進む
(try-next (cdr choices))はクロージャの中で呼ばれるため、
最初に与えられた
(lambda () ; *2*
      (set-variable-value! 'x
                           false
                           env))
という失敗継続を失うことはない。
---
結局、こうなる。
ただしtry-nextが持つfailはxを初期値に巻き戻しつつデフォルト失敗継続を呼ぶ失敗継続となっている。
---
((a2 env default-succeed
  (lambda ()
          (try-next (cdr (0 1))))
---
上のクロージャ版の下がa12として
これが評価される
---
(lambda (env succeed fail)
        (a12 env
           ;; a を呼び出す時の成功継続
           (lambda (a12-value fail2)
                   (a3 env succeed fail2))
           ;; a を呼び出す時の失敗継続
           fail))
---
同じ処理を辿ってこうなる。
ただしこのtry-nextが持つfailは、
yの値を巻き戻しつつ、
「xの値を巻き戻しつつ、デフォルト失敗継続を呼ぶfailを持つ(try-next (cdr (0 1)))を呼ぶ失敗継続」を呼ぶ
---
(a3 env default-succeed
  (lambda ()
          (try-next (cdr (0 1)))))
---
(set! y (+ y 1))
を読むとこうなる
---
(a4 env default-succeed
  (lambda () ; *2*
        (set-variable-value! 'y
                             0
                             env)
      ((lambda ()
          (try-next (cdr (0 1))))))
---
ここでyは1なのでなんやかんやで失敗継続が呼ばれる
yの値が一旦0に戻った上で1が代入されて、次に行く
失敗継続は空(amb)を呼ぶ
あとは略すけどイメージできるぞ
---
