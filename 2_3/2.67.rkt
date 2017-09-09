#lang racket/load
(require sicp)
(require racket/trace)
(require "2_3/2.67lib.rkt")
;8:14->8:24
;8:27->8:40
;9:03->9:28
(define sample-tree
 (make-code-tree (make-leaf 'A 4)
                 (make-code-tree
                  (make-leaf 'B 2)
                    (make-code-tree (make-leaf 'D 1)
                                    (make-leaf 'C 1)))))
(define sample-message '(0 1 1 0 0 1 0 1 0 1 1 1 0))
;ADABBCA
(display (decode sample-message sample-tree))
