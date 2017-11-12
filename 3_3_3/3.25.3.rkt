#lang debug racket
(require sicp)
(require racket/trace)
;3.26の解き方が思い浮かばないなあ、と思ったので、
;3.26の準備を兼ねて3.25を解いているサイトを参考に写経
;10:45->11:30
;サイトにあるのはミスがあって動かなかったが、GitHubにあるのは動いた
;https://github.com/uents/sicp/blob/master/ch3/ch3.3.3.scm
;9:22->9:44
;9:48->10:04

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

(define (make-tree record next)
  (cons record next))
(define (record tree)
  (car tree))
(define (next tree)
  (cdr tree))
(define (set-record! tree record)
  (set-car! tree record))
(define (set-next! tree next)
  (set-cdr! tree next))

(define (assoc-tree tree k)
  (cond
    [(null? tree) #f]
    [(equal? k (key (record tree))) tree]
    [else
      (assoc-tree (next tree) k)
     ]
    ))

(define (adjoin-tree! tree key-list v)
  (define (make-deep-record key-list)
    (if (null? (cdr key-list))
      (make-record (car key-list) v)
      (make-record (car key-list)
                   (make-tree (make-deep-record (cdr key-list))
                              nil))))
  (set-next! tree
    (make-tree (make-deep-record key-list)
               (next tree))))

(define (make-table-tree)
  (make-tree (make-record '*table* nil) nil))

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

;(lookup-table tbl (list 1 2))
 ;"one two"
;(lookup-table tbl (list 1 1))
; ;#f
;(lookup-table tbl (list 2 1))
; ;#f

(lookup-table tbl (list 2 4))
 ;"two three"
