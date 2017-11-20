20m+
18:13->
3.32を解く過程で気付いたこと。個人的にちょっと面白かったので、問題と関係ないがまとめ。

3.32の実験において、
propagateを最後に一つだけ置いた時挙動がどう変わるか、そしてその理由は何か？について。

結論から言うと、結果は同じになる。それは何故か。
ざっくり書くと

in-1 0
in-2 1
out New-value = 0　がキューにセット
in-1 1
in-2 1
out New-value = 1　がキューにセット
in-1 1
in-2 0
out New-value = 0　がキューにセット

両方ともこの流れをたどる。
ポイントは、outが0から0に変わってもprobeに出力されない、ということ。
まず、キューあるいはデキュー（実質スタック）に(0, 1, 0)がセットされる。
キューは、左から右に読み込むとしよう。
すると、0→1→0　しかし最初の0は無視するので、与える結果は「1→0」
デキュー（実質スタック）は右から左に読み込む。
すると、やっぱり0→1→0　しかし最初の0は無視するので、与える結果は「1→0」
と、このように、行う処理は違っても同じ結果になる、というわけ。

(define in-1 (make-wire))
(define in-2 (make-wire))
(define out (make-wire))
(probe 'in-1 in-1)
(probe 'in-2 in-2)
(probe 'out out)
(and-gate in-1 in-2 out)

(set-signal! in-1 0)

(set-signal! in-2 1)

(set-signal! in-1 1)

(set-signal! in-2 0)

(propagate)

---結果（後入れ先出し）------------------------------
'ok
'done
in-2 0 New-value = 1
'done
in-1 0 New-value = 1
'done
in-2 0 New-value = 0
'done
out 3 New-value = 1
out 3 New-value = 0
'done
[Finished in 0.649s]
---結果（先入れ先出し）-----------------
'ok
'done
in-2 0 New-value = 1
'done
in-1 0 New-value = 1
'done
in-2 0 New-value = 0
'done
out 3 New-value = 1
out 3 New-value = 0
'done
[Finished in 0.39s]
