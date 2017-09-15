題意がどうしても理解できず、いきなり答えを見た。
どうやら、引数に型タグ付きを数を渡す、つまり
(magnitude-part (make-complex-from-real-imag (make-integer 4) (make-integer 3)))
こうやるとこれまではエラーが出てしまうが、
その理由は型タグ付きの数でsquareとか出来ないからであり（magnitudeではsqrtを使う）
逆に言えば型タグ付きの数でsquareやsqrt,sinなどが使えるようになれば上の式が動くようになる
こちらを参照した
http://uents.hatenablog.com/entry/sicp/024-ch2.5.2.md
