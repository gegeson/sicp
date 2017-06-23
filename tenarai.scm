(define insertR
  	(lambda (new old lat)
     	(cond
        ((equal? old (car lat)) 
         	(cons old (cons new (cdr lat)))
         )
        (else
          	(cons (car lat) (insertR new old (cdr lat)))
          )
 
        )
     )
  )
(print (insertR  4 3 '(1 2 3 5 6)))