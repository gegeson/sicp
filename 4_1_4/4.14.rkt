22:12->22:48
7:33->8:15
ふと先を読んだら面白そうだったので、4_1_3まだだけど解く

;;; M-Eval input:
(map + '(1 2 3))
; application: not a procedure;
;  expected a procedure that can be applied to arguments
;   given: (mcons 'primitive (mcons #<procedure:+> '()))

;;; M-Eval input:
(map (lambda (x) x) '(1 2 3))
; application: not a procedure;
;  expected a procedure that can be applied to arguments
;   given: (mcons 'procedure (mcons (mcons 'x '()) (mcons (mcons 'x '()) (mcons
;     (mcons (mcons (mcons 'false (mcons 'true (mcons 'car (mcons 'cdr (mcons
;     'cons (mcons 'null? (mcons 'map (mcons 'display (mcons '+ (mcons '-
;     (mcons '* (mcons '/ (mcons '= '())))))))))))...

色々考えたけど、実行するのが一番だった。
このエラーを見ると、+ は('primitive '+)に変換した上でmapを施そうとするからダメ、
(lambda (x) x)も ('procedure ((x) (x))に変換した上でmapを施そうとするからダメ、
ってことだと思う。
この感じだと多分高階関数全部ダメだと思う。
自分で定義した場合はなぜ上手くいくのか？明日考えてみる

翌日
(define (map f lst)
(cond ((null? lst) '())
  (else (cons (f (car lst)) (map f (cdr lst)))))
)
(map (lambda (x) (+ x 1)) '(1))
複合手続きは
application?で引っかかって、
(_apply (_eval (operator exp) env)
       (list-of-values (operands exp) env))
ここが評価される。
mapは
(_eval (operator exp) env)
に渡り、
(lambda (x) (+ x 1)) '(1)
は
(list-of-values (operands exp) env)
に渡る。

まず、
mapが評価される。
定義されているので、variable?で引っかかって、
'procedure 付きのmapが返る。

list-of-valueは引数をそれぞれ_evalに渡す。
(lambda (x) (+ x 1))はlambda?に引っかかる。
引数それぞれが評価されて変換され、
そしてapplyが始まる。
compound-procedure?
で引っかかる。

最後に、ここが呼ばれる。
(eval-sequence
  (procedure-body procedure)
  (extend-environment
    (procedure-parameters procedure)
    arguments
    (procedure-environment procedure)))

(procedure-body procedure)は手続きの中身、この場合ならmap定義の中身。

これは、
(extend-environment
  (procedure-parameters procedure)
  arguments
  (procedure-environment procedure))
手続きの仮引数と実引数のペアを受け取った環境に上乗せする、という意味だと思う。

つまり、普通に

(cond ((null? lst) '())
  (else (cons (f (car lst)) (map f (cdr lst)))))
を、
lst = '(1 2 3)
f = (lambda (x) (+ x 1))
として評価したケースと同じ所に行き着く。
これなら動いて当たり前。
mapに出会ったらもう一回評価だと思う。

まとめると、
プリミティブ関数（この場合map）は最終的に、実装言語側で処理しようとするが、
引数に関しては評価してから渡す事になる。
引数に関数を渡す場合、'premitive か 'procedure が付いたものをそのままmapの引数として適用しようとするので、
アウト。

一方、インタプリタ内で定義した場合では、
mapは定義されているので、mapの定義にまで遡って処理を行う。
具体的には、これを評価することになる。

(cond ((null? lst) '())
  (else (cons (f (car lst)) (map f (cdr lst)))))

更に具体的には、condの条件節、及びtrueになった場合の本文（という呼び方でいいのか？）を実行することになる。
また、null?, lst, ', cons, f, car, cdr は環境から参照される。
つまり、(map f lst)自体ではなく、それを定義された形に置き換えたものが必要に応じて呼ばれる。
言語化しづらいがそういう感じ。

ググった感じ合ってるっぽい。間違えてる人も見つけたが。
考え方がここと一致している。
https://wizardbook.wordpress.com/2010/12/29/exercise-4-14/
