#lang racket/load
(require sicp)
(require racket/trace)
(require "2_3/2.67lib.rkt")
;12:06->12:09
;2.68別解でも正しく動いているが、要件とは異なるので、やり直し

(define (encode message tree)
  (if (null? message)
    nil
    (append (encode-symbol (car message) tree)
            (encode (cdr message) tree))))
(define (encode-symbol message tree)
    (cond
      ((leaf? tree) nil)
      (else
       (let ((right-symbols (symbols (right-branch tree)))
             (left-symbols (symbols (left-branch tree))))
         (cond
           ((element_of_symbols? message right-symbols)
            (cons 1 (encode-symbol message (right-branch tree))))
           ((element_of_symbols? message left-symbols)
            (cons 0 (encode-symbol message (left-branch tree))))
           (else
            (error "message not found in tree --ENCODE SYMBOL" message))
           ))
         )
      ))
(define (element_of_symbols? message symbols)
    (cond
        ((null? symbols) #f)
        ((equal? message (car symbols)) #t)
        (else
          (element_of_symbols? message (cdr symbols))
         )
      )
  )

(define sample-tree
 (make-code-tree (make-leaf 'A 4)
                 (make-code-tree
                  (make-leaf 'B 2)
                    (make-code-tree (make-leaf 'D 1)
                                    (make-leaf 'C 1)))))

(display (encode '(A D A B B C A) sample-tree))
                    ;=>(0 1 1 0 0 1 0 1 0 1 1 1 0)、元の符号と一致
(define sample-message '(0 1 1 0 0 1 0 1 0 1 1 1 0))
(newline)
(display (encode '(A D A F B C A) sample-tree))
;=>not found in tree --ENCODE SYMBOL F
;エラーがちゃんと出る
