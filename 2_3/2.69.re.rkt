#lang racket/load
(require sicp)
(require racket/trace)
(require "2_3/2.69lib.rkt")
;バランス木を作る事を目指し、再挑戦。
;->結局うまいやり方は思いつかず。
;adjoin-setを使う、というヒントを見ても使い方が思い浮かばず。
;しょうがないので答えを見た。

;13:33->14:27
;14:30->14:53
;14:57->15:14

;調べた所、どうやら、本文にあった　2.18のハフマン木を生成するプロセスがヒントになっているようだ。
;ソートして二つのペアからノードを作り、またソートすることを繰り返せば良い。

;以下本文より引用
;最初の葉    {(A 8)  (B 3)  (C 1)  (D 1)  (E 1)  (F 1)  (G 1)  (H 1)}
;合体        {(A 8)  (B 3)  ({C D} 2)  (E 1)  (F 1)  (G 1)  (H 1)}
;合体        {(A 8)  (B 3)  ({C D} 2)  ({E F} 2)  (G 1)  (H 1)}
;合体        {(A 8)  (B 3)  ({C D} 2)  ({E F} 2)  ({G H} 2)}
;合体        {(A 8)  (B 3)  ({C D} 2)  ({E F G H} 4)}
;合体        {(A 8)  ({B C D} 5)  ({E F G H} 4)}
;合体        {(A 8)  ({B C D E F G H} 9)}
;最後の合体  {({A B C D E F G H} 17)}

;以下、下のURLから引っ張ってきた模範解答
;http://d.hatena.ne.jp/tanakaBox/20071221/1198183713
(define (successive-merge set)
  (if (null? (cdr set))
      (car set)
      (successive-merge
       (adjoin-set (make-code-tree
                     (car set)
                     (cadr set))
                   (cddr set)))))

(define (generate-huffman-tree pairs)
  (successive-merge (make-leaf-set pairs)))

(display (generate-huffman-tree '((A 8) (B 3) (C 1) (D 1) (E 1) (F 1) (G 1) (H 1))))
(newline)

;これは何をやっているのか？
;ペアを合成してソートする、というアルゴリズムに疑問はないが、
;なぜこれで木が作れてしまっているのか？がわからない。
;…
;……よく考えてみると、この手続きは、
;「木を一つの要素として扱う」「木と葉を同列に並べてソートをする」
;という事をやっている。
;adjoin-setによって挿入する時も、未完成の木を葉と木のリストの残りに挿入する、という事をやっているわけ。
;その繰り返しで、最終的に「(Lead A 8)とそれ以外全部の木」からなるリストが生まれ、
;最後にmake-code-treeで一つになる、という流れになっている。
;普通の再帰のイメージとは違って、ノード・葉を考えれば要素数は減っていかないが、
;塊（葉・木）が大きくなる代わりに塊の数が減っていく。
;そこで、塊が一つか二つになった時を終了条件とすれば良い。
;そういう特殊さがイメージ理解を妨げていたような気がする…

;これを踏まえて、自分でソート関数から作って書こうとして失敗したバージョンに再挑戦してみた。

(define (insert x pairs)
    (cond
        ((null? pairs) (cons x nil))
        ((< (weight x) (weight (car pairs))) (cons x pairs))
        (else
         (cons (car pairs) (insert x (cdr pairs)))
         )
      )
  )
(define (insert-sort pairs)
    (cond
      ((null? pairs) nil)
      (else
       (insert (car pairs) (insert-sort (cdr pairs))))
      )
  )

(define (my-successive-merge leaves)
    (cond
        ((null? leaves) nil)
        ((= (length leaves) 2)
         (make-code-tree (car leaves) (cadr leaves)))
        (else
          (my-successive-merge
           (insert-sort
            (cons (make-code-tree (car leaves) (cadr leaves)) (cddr leaves))))
         )
       )
    )
;変数が保存できればどうにかなると思うが、出来ないので思いつかない…
;->ネットの解答を見て得た理解を踏まえてリトライ。
(define (my-generate-huffman-tree pairs)
  (my-successive-merge (make-leaf-set pairs)))

(display (generate-huffman-tree '((A 8) (B 3) (C 1) (D 1) (E 1) (F 1) (G 1) (H 1))))
(newline)
;まず、ネットからコピペしたバージョン
;((leaf A 8)
; ((((leaf H 1) (leaf G 1) (H G) 2)
;   ((leaf F 1) (leaf E 1) (F E) 2)
;   (H G F E) 4)
;  (((leaf D 1) (leaf C 1) (D C) 2)
;   (leaf B 3) (D C B) 5)
;  (H G F E D C B) 9)
; (A H G F E D C B) 17)
(display (my-generate-huffman-tree'((A 8) (B 3) (C 1) (D 1) (E 1) (F 1) (G 1) (H 1))))
(newline)
;次に、自分のをベースにネットのを参考にしたバージョン
;=>形は違うが、うまいことバランス木になっている。成功！
;((leaf A 8)
; ((((leaf C 1) (leaf D 1) (C D) 2)
;   ((leaf H 1) (leaf G 1) (H G) 2)
;   (C D H G) 4)
;  (((leaf F 1) (leaf E 1) (F E) 2)
;   (leaf B 3) (F E B) 5)
;  (C D H G F E B) 9)
; (A C D H G F E B) 17)
