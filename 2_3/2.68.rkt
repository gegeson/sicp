#lang racket/load
(require sicp)
(require racket/trace)
(require "2_3/2.67lib.rkt")
;9:46->9:57
(define sample-tree
 (make-code-tree (make-leaf 'A 4)
                 (make-code-tree
                  (make-leaf 'B 2)
                    (make-code-tree (make-leaf 'D 1)
                                    (make-leaf 'C 1)))))
(define sample-message '(0 1 1 0 0 1 0 1 0 1 1 1 0))

(define (encode message tree)
  (if (null? message)
    nil
    (append (encode-symbol (car message) tree)
            (encode (cdr message) tree))))
