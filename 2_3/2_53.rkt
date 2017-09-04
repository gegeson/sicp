; 21:21->21:36
#lang racket
(require racket/trace)
(define (memq item x)
  (cond ((null? x) false)
        ((eq? item (car x)) x)
        (else (memq item (cdr x)))))

;: (memq 'apple '(pear banana prune))
;: (memq 'apple '(x (apple sauce) y apple pear))


;; EXERCISE 2.53
(display (list 'a 'b 'c))
(newline)
;=>(a b c)
(display (list (list 'george)))
(newline)
;((george))
(display (cdr '((x1 x2) (y1 y2))))
(newline)
; ((y1 y2))
(display (cadr '((x1 x2) (y1 y2))))
(newline)
; (y1 y2)
(display (pair? (car '(a short list))))
(newline)
; false
(display (memq 'red '((red shoes) (blue socks))))
(newline)
; false
(display (memq 'red '(red shoes blue socks)))
; (red shoes blue socks)
