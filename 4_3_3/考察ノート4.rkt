18:57->19:00
19:02-> 20:00

>(define x 1)
という前提で以下を入力した時に、
>(begin (set! x 2) (amb))
どのように処理が流れるかをトレースしたい。
---
(lambda (a-value fail2)
       (b env succeed fail2))
まず、beginで↑が成功継続としてanalyze-assignmentに渡される。

analyze-assignmentの中では加工されるから、
(set! x 2)が持つ成功継続の具体形はこんな感じになると思う
ここでbは(amb)解析後のクロージャ
(lambda (val fail2) ; *1*
       (let ((old-value
               (lookup-variable-value var env)))
            (set-variable-value! var val env)
        (b env デフォルト成功継続
          (lambda () ; *2*
                    (set-variable-value! var
                                         old-value
                                         env)
                    (fail2)))))
---
analyze-assignmentのvproc呼び出しが成功すると、
analyze-self-evaluatingでは単に引数succeedが呼ばれるので…
次はこいつが呼ばれることになる。
bは(amb)である。
---
(lambda (val fail2) ; *1*
        (let ((old-value
                (lookup-variable-value var env)))
             (set-variable-value! var val env)
         (b env デフォルト成功継続
           (lambda () ; *2*
                     (set-variable-value! var
                                          old-value
                                          env)
                     (fail2)))))
---
vprocは2であり、普通の値なので、これに渡されるはず
---
(define (analyze-self-evaluating exp)
  (lambda (env succeed fail)
          (succeed exp fail)))

---
副作用とか取り除くと、この形
今度はこれがanalyze-ambに引っかかる
---
(b env デフォルト成功継続
 (lambda () ; *2*
           (set-variable-value! 'x
                                1
                                env)
           (デフォルト失敗継続)))
---
今度は、
即座に(null? choices)が呼ばれるから、
失敗継続の引数が呼ばれて、処理は、
変数を巻き戻して終了する

あああああああああ！！！！！！！！！
そういうことか！！！！！！！！！
わかった。
と、思う。
でもこれがワンステップ、ひとつかみで理解は出来ない、まだ。
一日にしては理解進んだからいいか
