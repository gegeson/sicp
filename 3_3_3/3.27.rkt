#lang debug racket
(require sicp)
(require racket/trace)
;18:15->18:40
実行はダルそうなんでパス

1.環境構造について
環境構造苦手なんでパス。
いつか環境構造強化週間みたいの作る。
http://uents.hatenablog.com/entry/sicp/031-ch3.3.3.md
このサイトをいきなり読んだ。

2.なんでオーダーが突然O(n)になるのか？という問題について。
すっごい単純な話で
F(n)を計算した時に現れるF(m)のmは、
0からn-1のいずれかだが、
それぞれを計算する時、一度現れたことがあるなら二度目は計算済みとしてテーブルから取り出す事が出来る。
つまり、実際に行われる計算としては、F(0)〜F(n)をそれぞれ一回ずつ、で足りる。
そのため、展開される木構造再帰の葉の数は、途中で値がわかるものはそこで葉とすると、nに比例
オーダーは葉の数に比例するので、オーダーはnに比例、という論理のはず。

3.(memoize fib)ではどうなる？
これは駄目。
memoizeは関数を加工して、メモ化済みならメモから取り出すという処理をする関数を返している。
memo-fibはだからちゃんと機能しているが、memo-fibを(memoizie fib)と書いても、
行われる再帰がfibである以上、普通のfibになってしまう。



(define (memoize f)
  (let ((table (make-table)))
    (lambda (x)(memoize fib)
            (let ((prev-result
                   (lookup x table)))
              (or prev-result
                  (let ((result (f x)))
                    (insert! x result table)
                    result))))))

(define memo-fib
  (memoize
   (lambda (n)
           (cond
             [(= n 0) 0]
             [(= n 1) 1]
             [else (+ (memo-fib (- n 1))
              (memo-fib (- n 2)))]
             ))))

(memo-fib 3)
