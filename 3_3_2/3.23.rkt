#lang debug racket
(require sicp)
(require racket/trace)
;O(1)で扱うには、
;リストのそれぞれが、次の値だけでなく前の値も持つようにしなければならない
;双方向リストにする必要があるわけで結構巨大な変更では…？
;22m
;25m
;22:34->22:59(25m)
;23:05->23:27(22m)
;23:38->23:41
(define (get-value trio)
  (car trio))
(define (get-next trio)
  (cddr trio))

(define (set-next! trio item)
  (set-cdr! (cdr trio) item))

(define (get-prev trio)
  (cadr trio))
(define (set-prev! trip item)
  (set-car! (cdr trip) item))
(define (front-deque deque) (car deque))
(define (rear-deque deque) (cdr deque))

(define (empty-deque? deque)
  (null? (front-deque deque)))
(define (make-deque) (cons nil nil))

(define (set-front-deque! deque item)
  (set-car! deque item))
(define (set-rear-deque! deque item)
  (set-cdr! deque item))
;
(define (rear-insert-deque! deque item)
    (let ((new-pair (cons item (cons nil nil))))
    (cond
      [(empty-deque? deque)
       (set-front-deque! deque new-pair)
       (set-rear-deque! deque new-pair)
       deque]
      [else
        (set-prev! new-pair (rear-deque deque))
        (set-next! (rear-deque deque) new-pair)
        (set-rear-deque! deque new-pair)
       deque
       ]
      )
    ))
(define (front-insert-deque! deque item)
  (let ((new-pair (cons item (cons nil nil))))
    (cond
      [(empty-deque? deque)
       (set-front-deque! deque new-pair)
       (set-rear-deque! deque new-pair)
       deque]
      [else
       (set-next! new-pair (front-deque deque))
       (set-prev! (front-deque deque) new-pair)
       (set-front-deque! deque new-pair)
       deque]
      )
    )
  )
(define (front-delete-deque! deque)
  (cond [(empty-deque? deque)
         (error "a" deque)]
    [else
     (set-front-deque! deque (cddr (front-deque deque)))
     deque]))

(define (rear-delete-deque! deque)
 (cond [(empty-deque? deque)
        (error "a" deque)]
   [else
    (set-next! (get-prev (rear-deque deque)) nil)
    (set-rear-deque! deque (get-prev (rear-deque deque)))
    deque]))
(define (print-deque deque)
  (define (iter lst)
    (cond
      [(null? (get-next lst)) (printf "~a)\n" (get-value lst))]
      [else
       (begin
        (printf "~a " (get-value lst))
        (iter (get-next lst)))
       ]
      ))
  (if (empty-deque? deque)
    (display "()\n")
    (begin (display "(")
           (iter (front-deque deque))))
  )

(define q (make-deque))
(newline)
(rear-insert-deque! q 'a)
(newline)
(print-deque q)
(newline)
(rear-insert-deque! q 'b)
(newline)
(print-deque q)
(newline)
(rear-insert-deque! q 'c)
(newline)
(print-deque q)
(newline)
(front-delete-deque! q)
(newline)
(print-deque q)
(newline)
(rear-delete-deque! q)
(newline)
(print-deque q)
(newline)
(rear-insert-deque! q 'a)
(newline)
(print-deque q)
(newline)
(rear-insert-deque! q 'b)
(newline)
(print-deque q)
(newline)
(rear-delete-deque! q)
(newline)
(print-deque q)
(newline)
(rear-delete-deque! q)
(newline)
(print-deque q)
(newline)
(front-delete-deque! q)
(newline)
(print-deque q)
(newline)
;(rear-delete-deque! q) 例外発生
(newline)
(display "-------------------------------")
(define q2 (make-deque))
(newline)
(front-insert-deque! q2 'a)
(newline)
(print-deque q2)
(newline)
(front-insert-deque! q2 'b)
(newline)
(print-deque q2)
(newline)
(front-insert-deque! q2 'c)
(newline)
(print-deque q2)
(newline)
(rear-delete-deque! q2)
(newline)
(print-deque q2)
(newline)
