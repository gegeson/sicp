; (define (length l)
; 	(cond
;    	((null? (car l)) 0)
;     ((equal? (car l) 1) 0)
;   	  (else
;     	  (+ 1 (length (cdr l))))))
; (print (length '(1 2 3 4)))
; (print (length '(a i u)))
; (print (length '(1 2 3 4 5 6)))
; (print (length  '(1 2 3)))
; (print (length '(a v c)))

(define length
  (lambda (l)
    (cond
      ((null? (car l)) 0)
      (else
        (+ 1 (length (cdr l)))
        )
      )
    )
  )

(print (length '(1 2 3 4)))