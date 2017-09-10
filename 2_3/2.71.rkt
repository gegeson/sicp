#lang racket/load
(require sicp)
(require racket/trace)
;10:54->11:21
(require "2_3/2.70lib.rkt")
;n=5の時のハフマン木の生成の様子
;((L A 1) (L B 2) (L C 4) (L D 8) (L E 16))
;=((AB 3) (L C 4) (L D 8) (L E 16))
;=((ABC 7) (L D 8) (L E 16))
;=((ABCD 15)(L E 16))
;= ((ABCDE 31))
;つまり…
;                                        (ABCDE 31)
;
;                                /                     \
;
;                        (ABCD 15)                     (L E 16)
;
;                  /                 \
;
;              (ABC 7)                (L D 8)
;
;            /                \
;        (AB 3)               (L C 4)
;
;      /       \
;
;(L A 1)       (L B 2)
;
;こんな感じになる。
;n=10の時はスペースの問題で書けないので、図は省略するが、
;((L A 1) (L B 2) (L C 4) (L D 8) (L E 16)
;         (L F 32) (L G 64) (L H 128) (L I 256) (L J 512))
;（中略）
;= ((ABCDE 31) (L F 32) (L G 64) (L H 128) (L I 256) (L J 512))
;= ((ABCDEF 63) (L G 64) (L H 128) (L I 256) (L J 512))
;= ((ABCDEFG 127) (L H 128) (L I 256) (L J 512))
;= ((ABCDEFGH 255) (L I 256) (L J 512))
;= ((ABCDEFGHI 511) (L J 512))
;= ((ABCDEFGHIJ 1023))
;という流れなので、上のハフマン木とだいたい同じになると思われる
;よって、最も頻度の高い記号を符号化するのに必要なビット数は1
;最も頻度の低い記号を符号化するのに必要なビットについて
;まず、木の一番下だけ二つの葉で深さ1の木が作られ、
;それ以降は葉が一つ増える度に深さが一つ増えるため、
;深さn-1の木になる。（多分証明にはなってない）
;最も頻度の低い記号は深さn-1の一番下なので、符号化するにはn-1ビット必要になる。


(define huffman-tree (generate-huffman-tree '((A 1) (B 2) (C 4) (D 8) (E 16))))
(display (encode '(A) huffman-tree))
(newline)
(display (encode '(B) huffman-tree))
(newline)
(display (encode '(C) huffman-tree))
(newline)
(display (encode '(D) huffman-tree))
(newline)
(display (encode '(E) huffman-tree))
(newline)

(define huffman-tree2 (generate-huffman-tree '((A 1) (B 2) (C 4) (D 8) (E 16) (F 32) (G 64) (H 128) (I 256) (J 512))))
(display (encode '(A) huffman-tree2))
(newline)
(display (encode '(B) huffman-tree2))
(newline)
(display (encode '(C) huffman-tree2))
(newline)
(display (encode '(D) huffman-tree2))
(newline)
(display (encode '(E) huffman-tree2))
(newline)
(display (encode '(F) huffman-tree2))
(newline)
(display (encode '(G) huffman-tree2))
(newline)
(display (encode '(H) huffman-tree2))
(newline)
(display (encode '(I) huffman-tree2))
(newline)
(display (encode '(J) huffman-tree2))
