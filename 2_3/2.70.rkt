#lang racket/load
(require sicp)
(require racket/trace)
;15:36->15:53
(require "2_3/2.70lib.rkt")

(define lyrics-words '((A 2) (NA 16) (BOOM 1) (SHA 3) (GET 2) (YIP 9) (JOB 2) (WAH 1)))
(define huffman-tree (generate-huffman-tree lyrics-words))
(display huffman-tree)
(newline)
(display (encode '(GET A JOB) huffman-tree))
(newline)
(display (encode '(SHA NA NA NA NA NA NA NA NA) huffman-tree))
(newline)
(display (encode '(GET A JOB) huffman-tree))
(newline)
(display (encode '(SHA NA NA NA NA NA NA NA NA) huffman-tree))
(newline)
(display (encode '(WAH YIP YIP YIP YIP YIP YIP YIP YIP YIP) huffman-tree))
(newline)
(display (encode '(SHA BOOM) huffman-tree))

(define my-huffman-tree (generate-huffman-tree lyrics-words))
(display my-huffman-tree)
(newline)
(display (encode '(GET A JOB) my-huffman-tree))
(newline)
(display (encode '(SHA NA NA NA NA NA NA NA NA) my-huffman-tree))
(newline)
(display (encode '(GET A JOB) my-huffman-tree))
(newline)
(display (encode '(SHA NA NA NA NA NA NA NA NA) my-huffman-tree))
(newline)
(display (encode '(WAH YIP YIP YIP YIP YIP YIP YIP YIP YIP) my-huffman-tree))
(newline)
(display (encode '(SHA BOOM) my-huffman-tree))
;huffman-treeによる結果
;(1 1 1 1 1 1 1 0 0 1 1 1 1 0)
;(1 1 1 0 0 0 0 0 0 0 0 0)
;(1 1 1 1 1 1 1 0 0 1 1 1 1 0)
;(1 1 1 0 0 0 0 0 0 0 0 0)
;(1 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0)
;(1 1 1 0 1 1 0 1 1)

;my-huffman-treeによる結果
;(1 1 1 1 1 1 1 1 1 0 1 1 0 1)
;(1 1 1 0 0 0 0 0 0 0 0 0)
;(1 1 1 1 1 1 1 1 1 0 1 1 0 1)
;(1 1 1 0 0 0 0 0 0 0 0 0)
;(1 1 0 0 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0)
;(1 1 1 0 1 1 0 0 1)
;不思議なことに、微妙に異なる結果なのにビット数は変わっていない。

(define lyrics '(GET A JOB SHA NA NA NA NA NA NA NA NA　GET A JOB SHA NA NA NA NA NA NA NA NA　WAH YIP YIP YIP YIP YIP YIP YIP YIP YIP SHA BOOM))
(newline)
(display (length (encode lyrics huffman-tree)))
;=>84。84ビットを要する。
(newline)
(display (length lyrics))
;固定長では、8つあるので一文字当たりlog(2^3)=3ビット必要
;歌詞は36wordsあるので, 3*36=108ビット必要になる。
