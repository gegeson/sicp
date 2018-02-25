20:39->21:09

わかった。
Alyssaのは、いきなりラムダに包んでるから、
実行の段階にならないと構文解析が実行されない。
そして実行の度に構文解析が実行される。
これは困る。構文解析の意味がない。
本文版では、それぞれのに環境を渡した関数適用の集まりを持ったラムダを作っているので、
ちゃんと構文解析済みになる、ということだと思う。

答えを見た。
http://www.serendip.ws/archives/2122
気づかなかったけど、本文版では引数一つの時は関数そのままを返してるんだな。

ほかも見たがよくわからん。
が、ラムダの中が評価されるのは実行される段になってからなのは間違いないから、
上の考察で合ってるはず。

ここの下のほうが似たようなこと言ってる。
https://wizardbook.wordpress.com/2011/01/04/exercise-4-23/

Alyssa版
;; EXERCISE 4.23
(define (analyze-sequence exps)
  (define (execute-sequence procs env)
    (cond ((null? (cdr procs)) ((car procs) env))
          (else ((car procs) env)
                (execute-sequence (cdr procs) env))))
  (let ((procs (map analyze exps)))
    (if (null? procs)
        (error "Empty sequence -- ANALYZE"))
    (lambda (env) (execute-sequence procs env))))

本文版
(define (analyze-sequence exps)
  (define (sequentially proc1 proc2)
    (lambda (env) (proc1 env) (proc2 env)))
  (define (loop first-proc rest-procs)
    (if (null? rest-procs)
        first-proc
        (loop (sequentially first-proc (car rest-procs))
              (cdr rest-procs))))
  (let ((procs (map analyze exps)))
    (if (null? procs)
        (error "Empty sequence -- ANALYZE"))
    (loop (car procs) (cdr procs))))
