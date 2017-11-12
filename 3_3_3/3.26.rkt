#lang debug racket
(require sicp)
(require racket/trace)
;treeに関係するゲッター・セッターと
;assoc-tree,
;adjoin-treeさえ書き換えれば
;あとは変更せずに上手く動く、らしい。
;http://uents.hatenablog.com/entry/sicp/031-ch3.3.3.md
;とりあえずゲッター・セッターは写経
;11:57
;25m+5m
;12:41->12:58
;13:00->13:06
;理解は出来た。次は再現
(define (make-record k v)
  (cons k v))
(define (key record)
  (car record))
(define (value record)
  (cdr record))
(define (set-key! record k)
  (set-car! record k))
(define (set-value! record v)
  (set-cdr! record v))

(define (make-tree record left right)
  (list record left right))
(define (record tree)
  (car tree))
(define (left tree)
  (cadr tree))
(define (right tree)
  (caddr tree))
(define (set-record! tree record)
  (set-car! tree record))
(define (set-left! tree left)
  (set-car! (cdr tree) left))
(define (set-right! tree right)
  (set-car! (cddr tree) right))

;この検索がやっているのは、
;現在見える範囲でのtree、
;つまりtreeの内valueを除いた部分からの検索である
(define (assoc-tree tree k)
  (cond
    [(null? tree) #f]
    [(equal? k (key (record tree))) tree]
    [(< k (key (record tree))) (assoc-tree (left tree) k)]
    [else
     (assoc-tree (right tree) k)]))

;これに渡されるのは、
;(t (assoc-tree tree (car key-list)))
;でtがfになった時のtree、
;つまり、(car key-list)を持たない木構造である
;木のどこかにkeyを挿入するのに適切なnilの位置があるので、まずそれを探す
(define (adjoin-tree! tree key-list v)
  (define (make-deep-tree key-list)
    (if (null? (cdr key-list))
      (make-tree (make-record (car key-list) v)
                 nil nil)
      (make-tree (make-record (car key-list)
                              (make-deep-tree (cdr key-list)))
                 nil nil)))
  (cond
    [(< (car key-list) (key (record tree)))
     (if (null? (left tree))
       (set-left! tree (make-deep-tree key-list))
       (adjoin-tree! (left tree) key-list v))]
     [(> (car key-list) (key (record tree)))
      (if (null? (right tree))
        (set-right! tree (make-deep-tree key-list))
        (adjoin-tree! (right tree) key-list v))]
    [else
     		 (error "adjoin-tree! -- tree key value" tree key-list v)
     ]
    )
  )

;ここの値はなんでもいい。非常に大きな値にすると常に初手左、
;非常に小さな値にすると常に初手右になる・
  (define (make-table-tree)
    (make-tree (make-record -1000 nil) nil nil))

(define (make-table)
  (let ((the-tree (make-table-tree)))
    (define (lookup key-list)
      (define (iter tree key-list)
        (if (null? key-list)
          #f
          (let ((t (assoc-tree tree (car key-list))))
            (if t
              (if (null? (cdr key-list))
                (value (record t))
                (iter (value (record t)) (cdr key-list)))
              #f))))
      (iter the-tree key-list))
      (define (insert! key-list v)
        (define (iter tree key-list)
          (if (null? key-list)
            #f
            (let ((t (assoc-tree tree (car key-list))))
              (if t
                (if (null? (cdr key-list))
                  (set-value! (record t) v)
                  (iter (value (record t)) (cdr key-list)))
                (adjoin-tree! tree key-list v))))
          )
        (iter the-tree key-list))
      (define (print)
        (begin
         (display the-tree (current-error-port))
         (newline (current-error-port))))
     (define (dispatch m)
   	  (cond ((eq? m 'lookup-proc) lookup)
   			((eq? m 'insert-proc!) insert!)
   			((eq? m 'print-proc) print)
   			(else (error "dispatch -- unknown operation" m))))
   	dispatch))

(define (lookup-table table key)
  ((table 'lookup-proc) key))
(define (insert-table! table key value)
  ((table 'insert-proc!) key value))
(define (print-table table)
  ((table 'print-proc)))


;;; test

(define tbl (make-table))
(insert-table! tbl (list 5 2) "five two")
(print-table tbl)
(insert-table! tbl (list 2 3) "two three")
(print-table tbl)
(insert-table! tbl (list 7 5) "seven five")
(print-table tbl)
(insert-table! tbl (list 1 7) "one seven")
(print-table tbl)
(insert-table! tbl (list 5 8) "five eight")
(print-table tbl)
(insert-table! tbl (list 2 9) "two nine")
(print-table tbl)
(insert-table! tbl (list 7 1) "seven one")
(print-table tbl)
 ;((*table*) (2 (3 . two three) (4 . two four)) (1 (2 . one two) (4 . one four) (3 . one three)))

(lookup-table tbl (list 5 2))
 ;"one two"
(lookup-table tbl (list 2 3))
 ;#f
(lookup-table tbl (list 7 5))
 ;#f
(lookup-table tbl (list 1 47))
 ;"two three"
