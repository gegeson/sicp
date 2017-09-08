#lang racket
(require sicp)
(require racket/trace)
;16:36->16:47
;17:03->18:00 a
;18:08->18:36 b

(define (entry tree) (car tree))
(define (left-branch tree) (cadr tree))
(define (right-branch tree) (caddr tree))
(define (make-tree entry left right)
  (list entry left right))

(define (element-of-set x set)
    (cond
        ((null? set) #f)
        ((= x (entry set)) true)
        ((> x (entry set))
         (element-of-set x (right-branch set)))
         ((< x (entry set))
          (element-of-set x (left-branch set)))
      )
  )
(define (adjoin-set x set)
  (cond
      ((null? set) (make-tree x nil nil))
      ((= x (entry set)) set)
      ((> x (entry set))
       (make-tree (entry set)
                  (left-branch set)
        (adjoin-set x (right-branch set))))
      ((< x (entry set))
       (make-tree (entry set)
        (adjoin-set x (left-branch set))
        (right-branch set)))
    )
  )

;ここから一部間違っていた自分の解答

;どちらの処理も、左の部分木を計算しつつ右の部分木を計算する、という事をやっているので
;計算量 T(n)は　T(n) = 2* T(n/2)
; T(1) = 1とすると、
;(n/2^m) =  1 とmを置いた時、
;T(n) = T(n/2^m)*2^m
;m = lognだから、
;T(n) = n*T(1)
;よってこの二つの関数のオーダーはO(n)
;ここまで一部間違っていた自分の解答

;->違う！！1で使われているappendはO(n)だった。上の説明は2だけについては合っている。

;1について改めて計算すると、
;T(n) = 2*T(n/2) + O(n) 
;T(n) = 2^m*T(n/2^m) + m*O(n)
;T(n) = n+logn*O(n)
;T(n) = O(n*logn)
;となり、1の方が遅い
(define (tree->list-1 tree)
    (if (null? tree)
      nil
      (append (tree->list-1 (left-branch tree))
              (cons (entry tree)
                    (tree->list-1
                     (right-branch tree)))))
  )
(define (tree->list-2 tree)
    (define (copy-to-list tree result-list)
      (if (null? tree)
        result-list
        (copy-to-list (left-branch tree)
                      (cons (entry tree)
                            (copy-to-list
                             (right-branch tree)
                             result-list)))))
  (trace copy-to-list)
  (copy-to-list tree '())
  )
(trace tree->list-1)
;(trace tree->list-2)
(define tree1 (adjoin-set 5 (adjoin-set 1 (adjoin-set 11 (adjoin-set 9 (adjoin-set 3 (make-tree 7 nil nil)))))))
(display tree1)
(newline)
(define tree2  (adjoin-set 5 (adjoin-set 9 (adjoin-set 7 (adjoin-set 1 (make-tree 3 nil nil))))))
(display tree2)
(newline)
(define tree3  (adjoin-set 11 (adjoin-set 7 (adjoin-set 9 (adjoin-set 1 (adjoin-set 3 (make-tree 5 nil nil)))))))
;(tree->list-1 tree1) 13
;(tree->list-2 tree2) 10
