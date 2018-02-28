18:58->19:12
19:23->19:41
とりあえず読むだけ。
二周読んで朧気ながら分かってきた。

+10m
20:51->21:20
22:11->22:23
22:33->22:55
+5m
下に疑問点の解消を思考過程付きで書いてみた。
思考過程付きなので雑。結論だけ書くともっと短くなるけど、思考過程を敢えてそのままにした

(define (factorial n)
  (if (= n 1)
    1
    (* (factorial (- n 1)) n)))

これが評価される時、この節のバージョンでは、
1回目に評価された時は言わずもがな、再帰をくぐって二回目に評価された時も

(define (analyze-if exp)
  (let ((pproc (analyze (if-predicate exp)))
        (cproc (analyze (if-consequent exp)))
        (aproc (analyze (if-alternative exp))))
    (lambda (env)
      (if (true? (pproc env))
          (cproc env)
          (aproc env)))))

これの返り値のラムダにenvを渡したものが出てくるということか。
再帰をくぐってもう一度式に出会った時に、再びevalのcondの長い場合分けをくぐらずともいきなりここに来る、と。
なるほどなるほど。
---
翌日
---
いや、まだわかっていなかった。
改めて、理解のために上のfactorialを全部構文解析で変換することをやってみよう。

まず、これは、
(define (factorial n)
  (if (= n 1)
    1
    (* (factorial (- n 1)) n)))

これ
(lambda (env)
  (define-variable! factorial (vproc env) env)
  'ok)

vprocは
(lambda (n)
        (if (= n 1)
          1
          (* (factorial (- n 1)) n)))
上を解析したもの。

つまり、
(lambda (env) (make-procedure n bproc env))

bprocは
(if (= n 1)
  1
  (* (factorial (- n 1)) n))
を解析したもの。
つまり、
(lambda (env)
  (if (true? (pproc env))
      (cproc env)
      (aproc env)))
この辺からちょっと飛ばすが、

pprocは
(lambda (env)
        (execute-application
        (lambda (env) (lookup-variable-value = env))(
        (lambda (env) (lookup-variable-value n env)))
        (lambda (env) 1)))

cprocは
(lambda (env) 1)
aprocは
(lambda (env)
       (execute-application
       (lambda (env) (lookup-variable-value * env))
       ((lambda (env)
                (execute-application
                 (lambda (env) (lookup-variable-value factorial env))
                 ((lambda (env) (execute-application
                                 (lambda (env) (lookup-variable-value - env))
                                 ((lambda (env) (lookup-variable-value n env))
                                  (lambda (env) 1)))))))
        (lambda (env) (lookup-variable-value n env)))))
わけわからんな。aprocはそのまんまにしておくか。

ともかく、ここまでの成果を元に反映していくと

(lambda (env)
  (define-variable! factorial (vproc env) env)
  'ok)

(lambda (env)
  (define-variable! factorial
    ((lambda (env) (make-procedure n bproc env)) env)
    env)
  'ok)

(lambda (env)
  (define-variable! factorial
    ((lambda (env) (make-procedure n
      (lambda (env)
        (if (true? (pproc env))
            (cproc env)
            (aproc env))) env)) env)
    env)
  'ok)

以下は煩雑なので省略した版
(lambda (env)
  (define-variable! factorial
    ((lambda (env) (make-procedure n
      (lambda (env)
        (if (true? (pproc env))
            (cproc env)
            ((analyze (* (factorial (- n 1)) n)) env))) env)) env)
    env)
  'ok)
省略しなかった版
(lambda (env)
  (define-variable! factorial
    ((lambda (env) (make-procedure n
      (lambda (env)
        (if (true?
             ((lambda (env)
                     (execute-application
                     (lambda (env) (lookup-variable-value = env))(
                     (lambda (env) (lookup-variable-value n env)))
                     (lambda (env) 1))) env))
            ((lambda (env) 1) env)
            ((lambda (env)
                   (execute-application
                   (lambda (env) (lookup-variable-value * env))
                   ((lambda (env)
                            (execute-application
                             (lambda (env) (lookup-variable-value factorial env))
                             ((lambda (env) (execute-application
                                             (lambda (env) (lookup-variable-value - env))
                                             ((lambda (env) (lookup-variable-value n env))
                                              (lambda (env) 1)))))))
                    (lambda (env) (lookup-variable-value n env))))) env)
          )) env)) env)
    env)
  'ok)

こういうことになる。グロいが、ブラックボックスは消えた。

ひとたびenvが渡されれば、
連鎖的に次の解析結果に環境が渡ることを繰り返す。
ここで、もし最後の(aproc env)が評価されてfactorialに辿りつき、再帰が起こったらどうなるか。

defineの解析結果はこんな感じなので、
factorialに代入されている値は
これ↓の二行目のdefine-variable!の第二引数であり、
(lambda (env)
  (define-variable! factorial
    ((lambda (env) (make-procedure n
      (lambda (env)
        (if (true?
             ((lambda (env)
                     (execute-application
                     (lambda (env) (lookup-variable-value = env))(
                     (lambda (env) (lookup-variable-value n env)))
                     (lambda (env) 1))) env))
            ((lambda (env) 1) env)
            ((lambda (env)
                   (execute-application
                   (lambda (env) (lookup-variable-value * env))
                   ((lambda (env)
                            (execute-application
                             (lambda (env) (lookup-variable-value factorial env))
                             ((lambda (env) (execute-application
                                             (lambda (env) (lookup-variable-value - env))
                                             ((lambda (env) (lookup-variable-value n env))
                                              (lambda (env) 1)))))))
                    (lambda (env) (lookup-variable-value n env))))) env)
          )) env)) env)
    env)
  'ok)

(lookup-variable-value factorial env)
↑↑の中の↑に遭遇したときが再帰のタイミングであるので、そのタイミングで上の環境が返ってくる。
そして、再帰が起こるタイミングではenvが渡されてるに違いないから、実際にenvを持ってラムダの適用連鎖が起こる。

ここで疑問。
factorial（関数名）にもう一度出会う時に構文解析の無限ループにならないのか？
これは上をみれば明らか。
(lambda (env) (lookup-variable-value factorial env))
↑構文解析の時点で行われる解析はここまで。ラムダに包まれてるからここから先には進まないので大丈夫。

よし、今度こそ（メタ循環評価器における）構文解析を理解できたぞ。

最後の疑問。

再帰をくぐる時、なぜ引数が1ずつ減ってるのか。
同じ環境を渡すことを繰り返してるだけな気がするけど…。

(lambda (env)
  (execute-application (fproc env)
                       (map (lambda (aproc) (aproc env))
                            aprocs)))

ここで、1減った引数が評価されてexecute-applicationに渡り、
その1減った実引数と仮引数とのペアを今の環境に（一時的に）上乗せした環境を、
関数本体の解析結果、つまり
(lambda (env) body)
この形に渡すことで次の評価に進む。

新たに気付いたこと。
構文解析する版だと必ず再帰の度に変数が積み重なっていく気がする。
しかし調べるとそうなってない。なぜ？
→よく見たら、envは参照していないなここ
手続きの持つ環境 + 今の実引数と仮引数のペア、であって、
手続きの持つ環境が更新されてるわけではないから、変わらないんだな

じゃあenvは？
→env自身がexecute-applicationに渡されているわけではない。
envに基づいた仮引数/実引数ペアの結果を、関数が持つ環境に付け加えている。
そうして作られた環境が新たにenvになるだけであり、
envに環境が付け加えられるわけではない。

結論:手続きの持つ環境・envともに、再帰の引数が積み重なるわけではない。

追記
ではなぜ再帰から返ってくる時にかつての変数が記憶されているのか？
→これは、環境フレームで記憶しているのではなく、インタプリタを動かしている側が記憶している。
再帰で空間計算量を食うのはそのため。
