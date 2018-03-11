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
---
(define (analyze-assignment exp)
 (let ((var (assignment-variable exp))
       (vproc (analyze (assignment-value exp))))
      (lambda (env succeed fail)
              (vproc env
                     (lambda (val fail2) ; *1*
                             (let ((old-value
                                     (lookup-variable-value var env)))
                                  (set-variable-value! var val env)
                                  (succeed 'ok
                                           (lambda () ; *2*
                                                   (set-variable-value! var
                                                                        old-value
                                                                        env)
                                                   (fail2)))))
                     fail))))

(begin (set! x 2) (amb))が引数付きで呼ばれると

(set! x 2)が成功したら
初期の成功継続 + 成功した場合は 'ok を捨て、失敗したときに備えて巻き戻す機能つき成功継続
という成功継続が呼ばれ、ambに処理が移る。
失敗したらfailを渡す。
(set! x 2)は、
2を評価し、2の評価が成功したなら、
xに2を代入し、okを返す成功継続と、受け取った失敗継続をセットする。
また、成功継続の行き先で失敗した場合に備えて、
変数の値を巻き戻したあと受け取った失敗継続を呼ぶ失敗継続を成功継続に仕込んでおく。
(amb)は、
初期成功継続+set!で加工された成功継続

(define (analyze-amb exp)
  (let ((cprocs (map analyze (amb-choices exp))))
       (lambda (env succeed fail)
               (define (try-next choices)
                 (if (null? choices)
                     (fail)
                     ((car choices) env
                                    succeed
                                    (lambda ()
                                            (try-next (cdr choices))))))
               (try-next cprocs))))
