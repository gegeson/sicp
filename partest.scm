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

; (print (length '(1 2 3 4)))

; (print (length '(1 2 3 4 6)))

; (print (length '(1 2 3 4)))
; (print (length '(1 2 3 4)))

(define atom?
  (lambda (x)
    	(and (not (pair? x))
          	(not (null? x))
          )
    ))

(define member*
  	(lambda (a l)
     	(cond
        	((null? l) #f)
         	((atom? (car l))
           	(or (equal? (car l) a)
                (member* a (cdr l))
                )
           )
          (else (or (member* a (car l))
                    (member* a (cdr l))))
        )
     )
  )

(print (member* "chips" '(("potato") ("chips" (("with") "fish") ("chips")))))
(print (member* "with" '(("potato") ("chips" (("with") "fish") ("chips")))))
(print (member* "potato" '(("potato") ("chips" (("with") "fish") ("chips")))))
(print (member* "fish" '(("potato") ("chips" (("with") "fish") ("chips")))))
(print (member* "ringo" '(("potato") ("chips" (("with") "fish") ("chips")))))
