#lang debug racket
(require sicp)
(require racket/trace)
;20:44->20:59
(define (make-monitored f)
  (let ((counter 0))
    (define (dispatch m)
      (cond
        ((eq? 'how-many-calls? m) counter)
        ((eq? 'reset-count m) (begin (set! counter 0) 0))
        (else
         (begin (set! counter (+ counter 1)) (f m)))
        ))
    dispatch))
(define s (make-monitored sqrt))
(s 100)
(s 'how-many-calls?)

(s 100)
(s 'how-many-calls?)

(s 100)
(s 'how-many-calls?)

(s 100)
(s 'how-many-calls?)
(s 'reset-count )
(s 100)
(s 'how-many-calls?)

(s 100)
(s 'how-many-calls?)

(s 100)
(s 'how-many-calls?)

(s 100)
(s 'how-many-calls?)
