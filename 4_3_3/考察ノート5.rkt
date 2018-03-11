20:05->20:18
21:05->21:57
---
考察ノート5
---
今度は
(define x 0)
とした上で
以下を検証する
(begin (set! x 1) (set! x 2) (amb))
---
まず、sequentiallyの結果から。
---
最初
aが(set! x 1)のクロージャ
bが(set! x 2)のクロージャとして、以下
---
(lambda (env succeed fail)
 (a env
    (lambda (a-value fail2)
            (b env succeed fail2))
    fail))
---
次に、abが上、cが(amb)として、これ
---
(ab env
  (lambda (ab-value fail2)
          (c env デフォルト成功継続 fail2))
  デフォルト失敗継続)
---
こいつは、analyze-assignmentに渡る
---
(lambda (env succeed fail)
 (a env
    (lambda (a-value fail2)
            (b env succeed fail2))
    fail))
---
簡約していくとこの形になる
（副作用としてxの値を書き換える部分があるけど、色々略してる）
---
(vproc env
  (lambda (val fail2) ; *1*
  ; 成功継続
  (b env succeed (lambda () ; 成功継続の中の失敗継続
                       (set-variable-value! var
                         old-value
                         env)
                       (fail2))))
  fail)
---
vprocはこいつに引っかかる。そのため、普通に成功継続が呼ばれることになる。
---
(define (analyze-self-evaluating exp)
  (lambda (env succeed fail)
          (succeed exp fail)))
---
valは 1 。つまり
成功継続が呼ばれてこうなる
---
(b env succeed
   (lambda () ; 失敗継続
     (set-variable-value! 'x
       0
       env)
     (fail)))
---
更に進もう。
---
ここで失敗した場合→xを0に戻すだけ
この先で失敗した場合→xを1に戻してから0に戻す
（xだけでなくx, yの代入を扱っている場合などは両方必要になってくる）
---
(vproc env
  (lambda (val fail2) ; *1*
   (succeed 'ok
            ; ここから成功継続の中の失敗継続
            (lambda () ; *2*
                    (set-variable-value! 'x
                       1
                       env)
                       (fail2))))
            ; ここまで成功継続の中の失敗継続
         ; ここから失敗継続
         (lambda ()
             (set-variable-value! 'x
               0
               env)
             (fail)))
---
この上のものをラムダに包んだものこそが、最初に知りたかったabの正体である。
というわけで、上のに以下のような引数を与えて先に進む。
---
(ab env
  (lambda (ab-value fail2)
          (c env デフォルト成功継続 fail2))
  デフォルト失敗継続)
---
(vproc env
  (lambda (val fail2)
   (c env デフォルト成功継続
      (lambda ()
           (set-variable-value! 'x
              1
              env)
              (fail2))))
   (lambda ()
       (set-variable-value! 'x
         0
         env)
       (デフォルト失敗継続)))
---
vprocは2であり、普通に成功継続を呼ぶだけの処理なので…
(副作用は略してるが、xに2が代入されている)
---
(c env デフォルト成功継続
   (lambda ()
        (set-variable-value! 'x
           1
           env)
           ((lambda ()
                    (set-variable-value! 'x
                      0
                      env)
                    (デフォルト失敗継続)))))
---
こうなって、
cは(amb)なので即失敗継続側が呼ばれて、
(lambda ()
     (set-variable-value! 'x
        1
        env)
        ((lambda ()
                 (set-variable-value! 'x
                   0
                   env)
                 (デフォルト失敗継続))))

が実行されて終わり、か。
分かってきた気がする。
しばらくは色々な例のトレースをこんな感じにやっていきたいかも。
飽きてすぐ問題入るかも知れないけど。
