21:14->21:21
数学ディレッタントなのでなんかの本で読んだことがある。
そのため思い出すだけで解けてしまう。

(define (run-forever) (run-forever))

(define (try p)
  (if (halts? p p)
    (run-forever)
    'halted))

(halts? p p)
は(p p)の停止性を調べる。

tryは、
(p p)が無限ループ→停止
(p p)が停止→無限ループ
という関数。

この場合、(try try)の停止性を調べることになる。

(try try)は、
もし(try try)が無限ループするなら停止する。
もし(try try)が停止するなら無限ループする。
どっちやねん。
矛盾しているので、停止/無限ループを判定する関数は存在し得ない。
