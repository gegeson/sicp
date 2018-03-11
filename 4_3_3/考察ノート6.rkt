22:10->22:22
22:23->22:45

今度はこれを解釈するべし

(define (require p)
  (if (not p) (amb)))

(define (even)
  (let ((x (amb 1 2 3 4 5 6 7)))
    (require (even? x))
    x))

とりあえず x = 1で失敗継続((amb 2 3 4 5 6 7) へのtry-next)を持ったまま
x = 1を評価する
ifのクロージャが引き出されることになるのかな
ifで(even? 1)が評価されて、
primitiveの適用なので成功継続が呼ばれる。

それはこいつ
(lambda (pred-value fail2)
        (if (true? pred-value)
            (cproc env succeed fail2)
            (aproc env succeed fail2)))
trueとfail2 = ((amb 2 3 4 5 6 7) へのtry-next)が渡されて、
(cproc env succeed fail2)が呼ばれる。
これは、
((amb)のクロージャ env デフォルトsucceed ((amb 2 3 4 5 6 7) へのtry-next))
であり、
(amb)は評価即失敗なので、
((amb 2 3 4 5 6 7) へのtry-next)
が呼ばれて、次は2を見ることになる
同じ流れを辿り、代替式が評価されるが、
代替式は 'false だから、
(amb 3 4 5 6 7)へのtry-nextを失敗継続として持ったまま、
(succeed false (try-next (amb 3 4 5 6 7)))
が呼ばれる
ここで評価が止まったりしないんだろうか、ということが気になる。
letだから途中の値が捨てられるのかな。
→letの中身はanalyze-sequenceに渡される模様。
捨てられるという理解で問題ない。ただし失敗継続は引き継がれる。
そして次にxが評価される。
(2 env succeed ((amb 3 4 5 6 7)へのtry-next))
という形になり、
成功してsuccedが呼ばれて2が表示される。

デフォルト成功継続は上手い形をしていて
(lambda (val next-alternative)
        (announce-output output-prompt)
        (user-print val)
        (internal-loop next-alternative))
失敗継続（この場合だと、次の(amb 3 4 5 6 7)）
がnext-alternativeとしてinternal-loopに渡されて終了する
そして、try-againが入力された時にnext-alternativeが呼ばれるようになっているので、
try-againで計算を続行してくれる

(define (analyze-if exp)
  (let ((pproc (analyze (if-predicate exp)))
        (cproc (analyze (if-consequent exp)))
        (aproc (analyze (if-alternative exp))))
       (lambda (env succeed fail)
               (pproc env
                      ;; pred-value を得るための
                      ;; 述語の評価の成功継続
                      (lambda (pred-value fail2)
                              (if (true? pred-value)
                                  (cproc env succeed fail2)
                                  (aproc env succeed fail2)))
                      ;; 述語の評価の失敗継続
                      fail))))

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
