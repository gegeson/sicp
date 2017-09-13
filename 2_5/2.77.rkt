#lang racket/load
(require "2_5/get_put.rkt")
;20:22->22:14

なぜかパッケージとインストールを別にすると上手く動かない。
（この原因究明にかなり時間かかった）(つまずきポイントその一)
しょうがないので同居。
また、magnitudeを呼び出す時どうしてもパッケージでない何かが呼び出される
という謎の現象にも遭遇した。どうやら組み込みのmagnitudeが呼び出されているらしい
少ししてgetに渡してないという初歩的ミスに気付いたが、
その後でも同じようなエラーが延々と出続ける。（つまり、パッケージが読み込めていない）
パッケージの読み込む順序が原因なのか？と思ったがそうではないらしい。
なんなのかさっぱりわからず、
1時間半以上費やしてもゴールが見えないので、正しく動かすことはこの節に関しては諦める…
->その後
ダメ元で、2.77.re.rkにて
https://github.com/uents/sicp/blob/master/ch2/ch2.5.1.scm
をほぼそのままコピペ（get, putは公式配布のもの）したら、（get, putが同じファイルに存在するなら）動いた……
何が原因かさっぱりわからんが、get, putを同じ所に書かなかった事が最後の原因だった

z = ('complex 'rectangular 3 4)
(magnitude z)
= (magnitude ('complex 'rectangular 3 4))
= (apply-generic 'magnitude ('complex 'rectangular 3 4))
= (apply 'magnitude (('rectangular 3 4)))
= ('magnitude ('rectangular 3 4))
= (apply-generic 'magnitude ('rectangular 3 4))
= (apply 'magnitude ((3 4)))
= (sqrt (+ (square 3) (square 4)))
= 5
apply-genericは2回呼び出される
