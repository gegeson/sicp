#lang debug racket
(require sicp)
(require racket/trace)
;13:42->13:59
;写経して読んだ後に自力で再現してみるテスト
;→ほぼ再現できた！
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
      (assoc-tree (right tree) k)
     ]
    )
  )
;これに渡されるのは、
;(t (assoc-tree tree (car key-list)))
;でtがfになった時のtree、
;つまり、(car key-list)を持たない木構造である
;木のどこかにkeyを挿入するのに適切なnilの位置があるので、まずそれを探す
(define (adjoin-tree! tree key-list v)
  (define (make-deep-tree key-list)
    (cond
      [(null? (cdr key-list))
       (make-tree (make-record (car key-list) v)
                  nil nil)]
      [else
        (make-tree (make-record (car key-list)
                                (make-deep-tree (cdr key-list)))
                   nil nil)
       ]
      )
    )
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
     (error "等しい値が見つからなかったからここが呼ばれるのに、等しいってのはおかしいぞい")
     ]
    )
)

(define (make-table-tree)
  (make-tree (make-record -100000 nil) nil nil))

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
(insert-table! tbl (list 1 2) "one two")
(print-table tbl)
(insert-table! tbl (list 1 3) "one three")
(print-table tbl)
(insert-table! tbl (list 2 3) "two three")
(print-table tbl)
(insert-table! tbl (list 1 4) "one four")
(print-table tbl)
(insert-table! tbl (list 2 4) "two four")
(print-table tbl)
 ;((*table*) (2 (3 . two three) (4 . two four)) (1 (2 . one two) (4 . one four) (3 . one three)))

(lookup-table tbl (list 1 2))

(lookup-table tbl (list 1 1))
 ;#f
(lookup-table tbl (list 2 1))
 ;#f

(lookup-table tbl (list 2 4))
 ;"two three"
