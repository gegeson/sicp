#lang debug racket
(require sicp)
(require racket/trace)
;19m
(define (make-queue)
  (let ((front-ptr nil)
        (rear-ptr nil))
    (define (dispatch m)
      (cond
        [(eq? m 'set-front-ptr!)
         (lambda (item) (set! front-ptr item))]
        [(eq? m 'set-rear-ptr!)
         (lambda (item) (set! rear-ptr item))]
        [(eq? m 'empty-queue?)
         (null? front-ptr)]
        [(eq? m 'front-queue) front-ptr]
        [(eq? m 'rear-ptr) rear-ptr]
        [(eq? m 'insert-queue!)
         (lambda (item)
                 (let ((new-pair (cons item nil)))
                   (cond
                     [(null? front-ptr)
                      (set! front-ptr new-pair)
                      (set! rear-ptr new-pair)
                      front-ptr]
                     [else
                        (set-cdr! rear-ptr new-pair)
                        (set! rear-ptr new-pair)
                      front-ptr])))]
        [(eq? m 'delete-queue!)
         (if (null? front-ptr)
           (error "a" front-ptr)
           (begin (set! front-ptr (cdr front-ptr))
           front-ptr))
         ]
         [else
         (error "a")
         ]
        )
      )
    dispatch))
(define q1 (make-queue))
(display ((q1 'insert-queue!) 'a))
;;((a) a)
(newline)
(display ((q1 'insert-queue!) 'b))
(newline)
(display (q1 'empty-queue?))
;;((a b) b)
(newline)
(display (q1 'delete-queue!))
;;((b) b)
(newline)
(display (q1 'delete-queue!))
;;(() b)
;(newline)
(newline)
(display (q1 'empty-queue?))

(newline)
(display ((q1 'insert-queue!) 'c))
(newline)
(display ((q1 'insert-queue!) 'a))
(newline)
(display (q1 'delete-queue!))
(newline)
(display ((q1 'insert-queue!) 'b))


;;単純に、carはキューのリスト、cdrはキューの終端を指すようにしているってだけの話
;(define (print-queue q) (car q))
;;とでもすればいいのでは
