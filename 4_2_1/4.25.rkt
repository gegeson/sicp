21:37->21:48

(define (unless condition usual-value exceptional-value)
  (if condition
    exceptional-value
    usual-value))

(define (factorial n)
  (unless (= n 1)
    (* n (factorial (- n 1)))
    1))

(factorial 5)
適用順序では、
(= 5 1)
(* 5 factorial (- 5 1))
1
この三つが評価されるが、二番目がまだ求まってないので、実際には上二つが評価される。
これが続き、
これが評価される
(= 4 1)
(* 4 factorial (- 4 1))
これが評価され、…以下無限ループ。
(= 3 1)
(* 3 factorial (- 3 1))
つまり、
引数の評価で再帰を使ってしまう事で、評価が就留しない事になる
（評価を終了させるには引数の評価を終わらせる必要があるが、引数を評価すると新たに引数を評価する必要があるため）
実際に実験しよう。
→うん、無限ループした。

正規順序評価では、可能な限り引数の評価を遅らせるので、
(factorial 5)の実行は、
引数が評価される前にunlessが実行されｍifに飛んで
これが評価される
(if (= 5 1)
  1
  (* 5 (factorial (- 5 1))))

更に(factorial 4)が評価され、
(if (= 4 1)
  1
  (* 4 (factorial (- 4 1))))

ちょっと省略し最終的にここに来る。
(if (= 1 1)
  1
  (* 1 (factorial (- 1 1))))
