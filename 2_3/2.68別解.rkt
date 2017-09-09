#lang racket/load
(require sicp)
(require racket/trace)
(require "2_3/2.67lib.rkt")
;9:46->9:57
;11:24->12:01
;正しく動いているが、要件とは異なるので、やり直し

;これを使うべきだったが、使わずに解いてしまった。
;(define (encode message tree)
;  (if (null? message)
;    nil
;    (append (encode-symbol (car message) tree)
;            (encode (cdr message) tree))))
(define (encode-symbol message tree)
  (define (encode-symbol-1 message current-branch)
    (cond
      ((null? message) nil)
      ((leaf? current-branch) (encode-symbol-1 (cdr message) tree))
      (else
       (let ((right-symbols (symbols (right-branch current-branch)))
             (left-symbols (symbols (left-branch current-branch))))
         (cond
           ((element_of_symbols? (car message) right-symbols)
            (cons 1 (encode-symbol-1 message (right-branch current-branch))))
           ((element_of_symbols? (car message) left-symbols)
            (cons 0 (encode-symbol-1 message (left-branch current-branch))))
           (else
            (error "message not found in current-branch --ENCODE SYMBOL" message))
           ))
         )
      ))
  (encode-symbol-1 message tree)
  )
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

(display (encode-symbol '(A D A B B C A) sample-tree))
                    ;=>(0 1 1 0 0 1 0 1 0 1 1 1 0)、元の符号と一致
(define sample-message '(0 1 1 0 0 1 0 1 0 1 1 1 0))
                        ;(0 1 1 0 0 1 0 1 0 1 1 1 0)
