9:44->10:11
10:20->10:23

 (for x a b body)

これで、
body
の中身でxがaからbまで値が変わっていく、
というのを実装してみたい。

格闘のあと。失敗作。
(define (for x a b body)
    (let ((x a))
      (define iter
        (if (x <= b)
          (begin body
                 (set! x (+ x 1))
                 (iter))
          'break)
        )
      (iter))
    )
格闘したが、やり方がわからない。諦め。
仕様を変えてみる。

> (for ([i '(1 2 3)]
        [j "abc"]
        #:when (odd? i)
        [k #(#t #f)])
    (display (list i j k)))

(1 a #t)(1 a #f)(3 c #t)(3 c #f)

こんなものが既にracketにあるらしいので、これを目指してみる。
とりあえず簡略版のこの形を目指す。

(for (i list1)
  body
  )

もしbodyが
(lambda (i) body)
のような形で渡されるのなら、もう話は解決するような…。

(display i)
を
(lambda (i) (display i))
に変換する方法…あ。

わかった。
引数でiが与えられてるんだから不可能じゃないぞ。
機械的に出来る。

(for (i (1 2 3))
  (display i)
  )
ここからまず
(lambda (i) (display i))
これに変換。
あとは、
(begin
((lambda (i) (display i)) 1)
((lambda (i) (display i)) 2)
((lambda (i) (display i)) 3)
)
こうすればOK。
再帰的にmake-begin適用すれば行ける。
この応用で、最初に考えた仕様もできそうだな…？

(for i 1 3
  (display i)
  )
これも、単純に

(lambda (i) (display i))
として、変数 aに1を代入して

((lambda (i) (display i)) a)
(set! a (+ a 1))

((lambda (i) (display i)) a)
(set! a (+ a 1))

((lambda (i) (display i)) a)
(set! a (+ a 1))
aが3を越えたので終了。

というふうにすれば実現可能だな。
なるほど。
普通の関数だけで実装する、という発想じゃダメで、
S式を組み立てて評価する、という発想が大事なんだな。
これを元に作ってみよう。
実装は"4.9.foreach.rkt"にて。
