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
インバータ単体は実質4のディレイ。

補足
ディレイのあとにシグナルを変更し、シグナルが変化しているならセットされたアクションを呼び出す、
という順序なので、変化がない場合ディレイだけ変化してprobeの出力がない、ということが起きる。

これにまつわる問題が3.29.rktにあった。
