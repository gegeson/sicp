#lang debug racket
(require sicp)
(require racket/trace)
;5:47->5:59
;6:06->6:55
;7:05->

(define (make-table) (list '*table*))

(define (assoc key records)
  (cond
    [(null? records) #f]
    [(equal? key (caar records)) (car records)]
    [else (assoc key (cdr records))]
    ))

(define (lookup keys table)
  (cond
    [(null? keys) (cdr table)]
    [(null? table) #f]
    [else
     (let ((subtable (assoc (car keys) (cdr table))))
       (if subtable
         (lookup (cdr keys) subtable)
         #f)
       )
     ]
    )
  )

;(*table* (usa (newyork (2009/2/13 . 14.5))) (japan (osaka (2009/2/13 . 22.0)) (tokyo (2009/2/13 . 20.1))))

;(define (insert! keys value table)
;  (cond
;    [(null? keys) (set-cdr! table value)]
;    [(null? (cdr keys)) (set-cdr! table (cons (car keys) value))]
;    [else
;     (let ((subtable (assoc (car keys) (cdr table))))
;       (if subtable
;         (set-cdr! subtable (insert! (cdr keys) value subtable))
;         (set-cdr! table (cons (car keys) value)))
;       )
;     ]
;    )
;)

(define (insert-iter keys value)
  (cond
    [(null? (cdr keys)) (cons (car keys) value)]
    [else
        (cons (car keys) (cons (insert-iter (cdr keys) value) nil))
     ]
  ))
(define a (list 'a))
(set-cdr! a (insert-iter '(a b c) 5))
(newline)
;(mcons '*table* (mcons (mcons 'japan (mcons (mcons 'osaka (mcons (mcons '2009/2/13 22.0) '()))
;                                            (mcons (mcons 'tokyo (mcons (mcons '2009/2/13 20.1) '())) '()))) '()))


(define (insert! keys value table)
  (cond
    [(null? keys) (set-cdr! table value)]
    [(null? (cdr keys)) (set-cdr! table (cons (cons (car keys) value) nil))]
    [else
     (let ((subtable (assoc (car keys) (cdr table))))
       (if subtable
         (set-cdr! subtable (cons (car keys) (cons (insert! (cdr keys) value (cdr subtable)) nil)))
         (begin (set-cdr! table (cons (insert-iter keys value) nil)))
       ))
     ]
    )
)

;(trace assoc-iter2)
;(trace insert!)
;(define x (list '*table*))
;(insert! '(memo nyaa uh) 22 x)
;x
;(insert! '(study english A) 11 x)
;(insert! '(study english B) 12 x)
;(insert! '(study math +) 10 x)
;(insert! '(neko nyaa oh) 22 x)
;x
(define tb (list '*table*))
(insert! '(japan tokyo 2009/2/13) 20.1 tb)
;(insert! '(japan osaka 2009/2/13) 22.0 tb)
;(insert! '(japan osaka 2009/2/14) 23.0 tb)
;(insert! '(usa newyork 2009/2/13) 14.5 tb)
;(lookup '(japan tokyo 2009/2/13) tb)
;(lookup '(japan osaka 2009/2/13) tb)
;(lookup '(japan osaka 2009/2/14) tb)
;(lookup '(usa newyork 2009/2/13) tb)
;(lookup '(usa tokyo 2009/2/13) tb)

(display tb)

;(*table* (usa (newyork (2009/2/13 . 14.5))) (japan (osaka (2009/2/13 . 22.0)) (tokyo (2009/2/13 . 20.1))))
;
;gosh> (*table* (usa (newyork (|2009/2/13| . 14.5))) (japan (osaka (|2009/2/13| . 22.0)) (tokyo (|2009/2/13| . 20.1))))
;(mcons '*table* (mcons (mcons 'memo (mcons (mcons 'nyaa 22) '())) '()))
;(lookup '(study english A) x)
;(lookup '(study english B) x)
;(lookup '(study math +) x)
;(lookup '(neko nyaa oh) x)
;(lookup '(study english C) x)
;(car (assoc-iter2 '(study nyaa) x))
;(caadr (assoc-iter2 '(nekoneko neko) x))
;(insert-new! '(English A) 5)
