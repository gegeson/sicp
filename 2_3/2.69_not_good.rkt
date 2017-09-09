#lang racket/load
(require sicp)
(require racket/trace)
(require "2_3/2.67lib.rkt")
;12:30->12:34
;12:36->12:52
;12:53->13:01
;13:20->13:27
;アンバランスな木になって良くないので、改める。
;調べた所、どうやら205pの2.18のハフマン木を生成するプロセスがヒントになっているようだ。
(define sample-tree
 (make-code-tree (make-leaf 'A 4)
                 (make-code-tree
                  (make-leaf 'B 2)
                    (make-code-tree (make-leaf 'C 1)
                                    (make-leaf 'D 1)))))
(define sample-message '(0 1 1 0 0 1 0 1 0 1 1 1 0))

;〜方針〜
;((A 4) (B 2) (C 1) (D 1))を、make-leaf-setで
;((leaf D 1) (leaf C 1) (leaf B 2) (leaf A 4))に変換し
;更にそれを
;((leaf A 4) ((leaf B 2) ((leaf D 1) (leaf C 1) (D C) 2) (B D C) 4) (A B D C) 8)
;に変換する、という手続きを書く。

(define (get-last lst)
  (cond
    ((null? lst) nil)
    ((null? (cdr lst)) (car lst))
    (else (get-last (cdr lst))))
  )
(define (remove-last lst)
    (cond
      ((null? lst) nil)
      ((null? (cdr lst)) nil)
      (else (cons (car lst) (remove-last (cdr lst))))
      )
  )


(define (succesive-merge leaves)
  (cond
    ((= (length leaves) 1) (car leaves))
    (else
     (let ((rest_branch (succesive-merge (remove-last leaves))))
         (make-code-tree (get-last leaves) rest_branch))
     )
))
(define (generate-huffman-tree pairs)
  (succesive-merge (make-leaf-set pairs)))
(display sample-tree)
(newline)
(display "generate-huffman-tree ")
(newline)
(display (generate-huffman-tree '((A 4) (B 2) (C 1) (D 1))))
(newline)
;一致。成功！
;(display "generate-huffman-tree ")
;(newline)
;;図2.18でも検証
;(display (generate-huffman-tree '((A 8) (B 3) (C 1) (D 1) (E 1) (F 1) (G 1) (H 1))))
;(newline)

;=>
;((leaf A 8) ((leaf B 3)
;             ((leaf C 1)
;              ((leaf D 1)
;               ((leaf E 1)
;                ((leaf F 1)
;                 ((leaf G 1)
;                  (leaf H 1)
;                  (G H) 2)
;                 (F G H) 3)
;                (E F G H) 4)
;               (D E F G H) 5)
;              (C D E F G H) 6)
;             (B C D E F G H) 9)
;            (A B C D E F G H) 17)
;恐らく右に長いアンバランスな木になってしまっている。
;これは良くはないので、改める。
;調べた所、どうやら205pの2.18のハフマン木を生成するプロセスがヒントになっているようだ。
