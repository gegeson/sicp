11:07->11:23
11:30->11:34
a
(and (supervisor ?person (Bitdiddle Ben))
     (address ?person ?where))
b
(and (salary ?person ?amount1)
     (salary (Bitdiddle Ben) ?amount2)
     (lisp-value < ?amount1 ?amount2))
c
わからなかった。答え見た
SQL力がない

再現してみるが、写経ではなく、
問題を分割していこう
「コンピュータ部門に監督されている人」
をまず考えると…
(and (supervisor ?x ?y)
     (job ?y (computer . ?z)))
↑これ。
これで間違いない

この否定
「コンピュータ部門以外の人に監督されている人」
は…
(and (supervisor ?x ?y)
     (not (job ?y (computer . ?z))))
↑こうなるはず
これに、上司の名前と職務を追加すればいいので

↓これ！
(and (supervisor ?x ?y)
     (not (job ?y (computer . ?z)))
     (job ?y ?job))
ネットで見た答えとも一致した。
やはり問題の分割が大事だな
