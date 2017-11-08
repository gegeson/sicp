#lang debug racket
(require sicp)
(require racket/trace)
;5:47->5:59
;6:06->6:55
;7:05->7:40
;7:43->8:00
;8:19->8:26
;ネットの解答ちら見したらもっと簡潔に書けるみたいなので再挑戦である

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

(define (insert-iter keys value)
  (cond
    [(null? (cdr keys)) (cons (car keys) value)]
    [else
        (cons (car keys) (cons (insert-iter (cdr keys) value) nil))
     ]
  ))


(define (insert! keys value table)
  (let ((subtable (assoc (car keys) (cdr table))))
    ;(printf "keys ~a value ~a table ~a subtable ~a \n" keys value table subtable)
         (cond
           [(null? keys) (set-cdr! table value)]
           [else
              (if subtable
                (insert! (cdr keys) value subtable)
                (set-cdr! table (cons (insert-iter keys value) (cdr table)))
                )
            ])
           )
)

(define x (list '*table*))
(insert! '(memo nyaa uh) 22 x)

(insert! '(study english A) 11 x)
(insert! '(study english B) 12 x)
(insert! '(study math +) 10 x)
(insert! '(study math *) 111 x)
(insert! '(neko nyaa oh) 22 x)
(display x)
(newline)
(lookup '(study english A) x)
(lookup '(study english B) x)
(lookup '(study math +) x)
(lookup '(neko nyaa oh) x)
(lookup '(neko nyaa n) x)
;;x
(define tb (list '*table*))
(insert! '(japan tokyo 2009/2/13) 20.1 tb)
(insert! '(japan osaka 2009/2/13) 22.0 tb)
(insert! '(japan osaka 2009/2/14) 23.0 tb)
(insert! '(usa newyork 2009/2/13) 14.5 tb)
(lookup '(japan tokyo 2009/2/13) tb)
(lookup '(japan osaka 2009/2/13) tb)
(lookup '(japan osaka 2009/2/14) tb)
(lookup '(usa newyork 2009/2/13) tb)
(lookup '(usa tokyo 2009/2/13) tb)
;
(display tb)

;(*table* (usa (newyork (2009/2/13 . 14.5))) (japan (osaka (2009/2/13 . 22.0)) (tokyo (2009/2/13 . 20.1))))
;
;(*table* (usa (newyork (2009/2/13 . 14.5))) (japan (tokyo (2009/2/13 . 20.1)) (osaka (2009/2/13 . 22.0) (2009/2/14 . 23.0))))
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
