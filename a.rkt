(define (count-pairs3 x)
  (define lst nil)
    (define (sub x)
      (cond
        [(not (pair? x)) 0]
        [(and (has (car x) lst) (has (cdr x) lst))
         0]
         [(and (not (has (car x) lst)) (has (cdr x) lst))
          (begin (set! lst (cons (car x) lst))
                ;(printf "lst ~a \n " lst)
                 (+ 1 (sub (car x))))]
        [(and (not (has (cdr x) lst)) (has (car x) lst))
         (begin (set! lst (cons (cdr x) lst))
                ;(printf "lst ~a \n" lst)
                (+ 1 (sub (cdr x))))]
        [(eq? (car x) (cdr x))
         (begin (set! lst (cons (car x) lst))
                (+ (sub (car x)) (sub (cdr x)) 1))
         ]
        [else
          (begin (set! lst (cons (car x) (cons (cdr x) lst)))
          ; (printf "lst ~a \n" lst)
           (+ (sub (car x)) (sub (cdr x)) 2))]
        ))
    (sub x)
    )
