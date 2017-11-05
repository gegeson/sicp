#lang debug racket
(require sicp)
(require racket/trace)
;20:12->20:32
;20:41->20:44
;21:17->21:42
;22:13->22:27
;22:46->23:50

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

(define (assoc-iter1 keys subtable)
  (cond
    [(eq? subtable #f) #f]
    [(null? keys) subtable]
    [else
     (let ((newtable (assoc (car keys) (cdr subtable))))
         (assoc-iter1 (cdr keys) newtable))
     ]
    )
  )
(define (assoc-iter2 keys subtable)
  (cond
    [(eq? subtable #f) #f]
    [(null? keys) subtable]
    [else
     (let ((newtable (assoc (car keys) (cdr subtable))))
       (if newtable
         (assoc-iter2 (cdr keys) newtable)
         subtable))
     ]
    )
  )
(define (lookup keys table)
  (let ((record (assoc-iter1 keys table)))
    (if record
        (cdr record)
       #f
      )))

(define (get-left-keys key keys)
  (cond
    [(null? keys) #f]
    [(equal? key (car keys)) (cdr keys)]
    [else (get-left-keys key (cdr keys))])
  )

(define (insert-new! keys value)
  (if (null? (cdr keys))
    (cons (car keys) value)
    (cons (car keys) (cons (insert-new! (cdr keys) value) nil))
    )
  )

(define (insert! keys value table)
  (let ((subtable (assoc-iter2 keys table)))
    (let ((left-keys (get-left-keys (car subtable) keys)))
      (cond
        ;[(and (not left-keys) (null? (cdr subtable)))
        ; (append subtable (insert-new! left-keys value))]
        [left-keys
             (set-cdr! subtable  (cons (insert-new! left-keys value) (cdr subtable)))]
        [else (set-cdr! table (cons (insert-new! keys value) (cdr table)))])
      )
    )
    'ok
  )

;(define (insert! keys value)
;  (let ((record-or-table (assoc-iter2 keys value)))))

;(define (insert! key-1 key-2 value table)
;  (let ((subtable (assoc key-1 (cdr table))))
;    (if subtable
;        (let ((record (assoc key-2 (cdr subtable))))
;          (if record
;              (set-cdr! record value)
;              (set-cdr! subtable
;                        (cons (cons key-2 value)
;                              (cdr subtable)))))
;        (set-cdr! table
;                  (cons (list key-1
;                              (cons key-2 value))
;                        (cdr table)))))
;  'ok)

;(trace assoc-iter2)
;(trace insert!)
(define x (list '*table*))
(insert! '(memo nyaa) 22 x)
x
(insert! '(study english) 11 x)
(insert! '(study math) 10 x)
(insert! '(neko nyaa) 22 x)
x

;(mcons '*table* (mcons (mcons 'memo (mcons (mcons 'nyaa 22) '())) '()))
(assoc-iter2 '(study math) x)
(assoc-iter2 '(study nyaa) x)
;(car (assoc-iter2 '(study nyaa) x))
;(caadr (assoc-iter2 '(nekoneko neko) x))
(lookup '(study math) x)
(lookup '(study nyaa) x)
;(insert-new! '(English A) 5)
