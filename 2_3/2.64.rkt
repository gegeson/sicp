#lang racket
(require sicp)
(require racket/trace)
;（未測定部分を25mと換算)
; 19:45->19:52
;partial-treeは、順序つきリストと、「リストの何番目までを木に変換するか」を示す数nを受け取り、
;最初からn個めまでの要素について、左の部分、真ん中、右の部分にリストを分け、
;左の部分を左部分木、真ん中をエントリー、右の部分を右部分木とした木、及び木に変換しなかったリストの残りを返す、
;という操作を行う。


(define (list->tree elements)
  (car (partial-tree elements (length elements))))

(define (partial-tree elts n)
  (if (= n 0)
      (cons '() elts)
      (let ((left-size (quotient (- n 1) 2)))
        (let ((left-result (partial-tree elts left-size)))
          (let ((left-tree (car left-result))
                (non-left-elts (cdr left-result))
                (right-size (- n (+ left-size 1))))
            (let ((this-entry (car non-left-elts))
                  (right-result (partial-tree (cdr non-left-elts)
                                              right-size)))
              (let ((right-tree (car right-result))
                    (remaining-elts (cdr right-result)))
                (cons (make-tree this-entry left-tree right-tree)
                      remaining-elts))))))))

;リスト(1 3 5 7 9 11)は、
;       5
;    /     \
;  1        9
;   \      /  \
;    3   7    11
;という形になる。
;(1 3)ではleft-sizeが0になる事に注意。

;計算ステップは、
;T(n) = 2* T(n/2) + O(1)
;の式の結果である。前回の結果を利用し、
;T(n) = O(n)
