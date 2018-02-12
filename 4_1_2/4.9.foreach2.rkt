13:20->13:38
考察・方針については"./4.9.for.考察.rkt"を参照。
foreachの、引数複数版。

これを動かすことが目標。
もちろん三つでも四つでも使える。

(for ((i (1 2 3))
      (j (4 5 6)))
  (begin (display i)
         (display " ")
         (display j)
         (display "\n"))
  )

実験室は"mc/4.9.foreach2.mc.rkt"

(define (for? exp)
    (tagged-list? exp 'for))

(define (for-i-list exp) (cadr exp))

(define (for-vars exp) (map car (for-i-list exp)))

(define (for-lists exp) (map cadr (for-i-list exp)))

(define (for-body exp) (caddr exp))

(define (for->apply_lambda exp)
  (let* ((vars (for-vars exp))
         (lsts (for-lists exp))
         (body (for-body exp)))
    (define (iter lsts)
      (if (null? (car lsts))
        nil
        (cons
         (cons (make-lambda vars (list body)) (map car lsts))
         (iter (map cdr lsts)))))
    (make-begin (iter lsts)))
  )

出来た。

;;; M-Eval input:
(for ((i (1 2 3))
      (j (4 5 6)))
  (begin (display i)
         (display " ")
         (display j)
         (display "\n"))
  )
1 4
2 5
3 6

;;; M-Eval value:
#<void>

;;; M-Eval input:
(for ((i (1 2 3))
      (j (4 5 6))
      (k (7 8 9)))
  (begin (display i)
         (display " ")
         (display j)
         (display " ")
         (display k)
         (display "\n"))
  )
1 4 7
2 5 8
3 6 9

;;; M-Eval value:
#<void>
