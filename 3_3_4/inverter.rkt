;30m

※重大なことに気が付いたのでメモ※
！！！！！！以下の結果・考察は誤りです！！！！！！
(inverter in-1 out)
(set-signal! in-1 1)
(propagate)
(set-signal! in-1 0)
(propagate)
結果
'ok
in-1 0 New-value = 1
'done
'done
in-1 2 New-value = 0
'done
out 4 New-value = 1
'done


入力同様、出力についても0から値が変わらないとアクションとして認識されないので、
インバータ単体は"最初だけ"実質4のディレイ。

補足
ディレイのあとにシグナルを変更し、シグナルが変化しているならセットされたアクションを呼び出す、
という順序なので、変化がない場合ディレイだけ変化してprobeの出力がない、ということが起きる。

これにまつわる問題が3.29.rktにあった。
！！！！！！ここまでの結果は誤りです！詳しくは下！！！！！！
※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※

→これ、3.31のためにプログラムを一部書き換えた版をコピペした事が原因の誤った動作で
そこを修正すると
in-1 0 New-value = 0
out 0 New-value = 0
'ok
in-1 0 New-value = 1
'done
out 2 New-value = 1
out 2 New-value = 0
'done
in-1 2 New-value = 0
'done
out 4 New-value = 1
'done
[Finished in 0.4s]
という風にちゃんと期待する動作になった。
これ、3.31はもう半分解けたのでは？
(define (accept-action-procedure! proc)
  (set! action-procedures (cons proc action-procedures))
  (proc))

と書くと、値が変わっていようがいまいが一回の呼び出しは保証されるが、

(define (accept-action-procedure! proc) ;; for ex 3.31
  (set! action-procedures (cons proc action-procedures)))
と書くと、値が変わったときしか呼び出しが起きないので、こういう事が起こりうる。

-------------------------------------------
なら、こいつはどうだ？

(probe 'in-1 in-1)
(probe 'out out)
(inverter in-1 out)
(propagate)

in-1 0 New-value = 0
out 0 New-value = 0
'ok
out 2 New-value = 1
'done
[Finished in 0.609s]

これを3.31 verでやってみても
'ok
'done
が表示されるだけ。
つまり、何も値が変化していなくとも、最初の時点でinverterアクションを起動させている、という点で違う。
