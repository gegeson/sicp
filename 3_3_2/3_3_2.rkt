#lang debug racket
(require sicp)
;(require racket/trace)
;19:59->20:25
(define (front-ptr queue) (car queue))
(define (rear-ptr queue) (cdr queue))
(define (set-front-ptr! queue item)
  (set-car! queue item))
(define (set-rear-ptr! queue item)
  (set-cdr! queue item))
(define (empty-queue? queue)
  (null? (front-ptr queue)))
(define (make-queue) (cons nil nil))

(define (front-queue queue)
  (if (empty-queue? queue)
  (error "FRONT called with and empty queue" queue)
  (car (front-ptr queue)))
)
;
(define (insert-queue! queue item)
    (let ((new-pair (cons item nil)))
    (cond
      [(empty-queue? queue)
       (set-front-ptr! queue new-pair)
       (set-rear-ptr! queue new-pair)
       queue]
      [else
        (set-cdr! (rear-ptr queue) new-pair)
        (set-rear-ptr! queue new-pair)
       queue
       ]
      )
    ))
(define (delete-queue! queue)
  (cond [(empty-queue? queue)
         (error "a" queue)]
    [else
     (set-front-ptr! queue (cdr (front-ptr queue)))
     queue]))
