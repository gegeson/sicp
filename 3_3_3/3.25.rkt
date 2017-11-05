#lang debug racket
(require sicp)
(require racket/trace)
;20:12->20:32
;2041->20:44
;(define (make-table)
;  (let ((local-table (list '*table*)))
;    (define (assoc key records)
;      (cond
;        [(null? records) #f]
;        [(equal? key (caar records)) (car records)]
;        [else (assoc key (cdr records))]
;        ))
;    (define (assoc-iter keys subtable)
;      (cond
;        [(null? keys) subtable]
;        [else
;         (let ((newtable (assoc (car keys) (cdr subtable))))
;           (assoc-iter (cdr keys) newtable))
;         ]
;        )
;      )))
(define (assoc key records)
  (cond
    [(null? records) #f]
    [(equal? key (caar records)) (car records)]
    [else (assoc key (cdr records))]
    ))
(define (assoc-iter keys subtable)
  (cond
    [(eq? #f subtable) #f]
    [(null? keys) subtable]
    [else
     (let ((newtable (assoc (car keys) (cdr subtable))))
       (assoc-iter (cdr keys) newtable))
     ]
    )
  )
(trace assoc-iter)


(define (insert! key-1 key-2 value table)
  (let ((subtable (assoc key-1 (cdr table))))
    (if subtable
        (let ((record (assoc key-2 (cdr subtable))))
          (if record
              (set-cdr! record value)
              (set-cdr! subtable
                        (cons (cons key-2 value)
                              (cdr subtable)))))
        (set-cdr! table
                  (cons (list key-1
                              (cons key-2 value))
                        (cdr table)))))
  'ok)

(define x (list '*table*))
(insert! 'memo 'nyaa 22 x)
(insert! 'study 'english 11 x)
(insert! 'study 'math 10 x)
(insert! 'neko 'nyaa 22 x)
(assoc-iter '(study math) x)
