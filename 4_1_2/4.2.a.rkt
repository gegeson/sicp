; 8:12->8:18

(define x 3)
が
application?で引っかかってapplyしようとしてしまうのではないか。

;;; M-Eval input:
(define x 3)
Unbound variable define [,bt for context]

合ってるっぽい

(define (eval exp env)
 (cond ((self-evaluating? exp) exp)
       ((variable? exp) (lookup-variable-value exp env))
       ((quoted? exp) (text-of-quotation exp))
       ((application? exp)
        (apply (eval (operator exp) env)
               (list-of-values (operands exp) env)))
       ((assignment? exp) (eval-assignment exp env))
       ((definition? exp) (eval-definition exp env))
       ((if? exp) (eval-if exp env))
       ((lambda? exp)
        (make-procedure (lambda-parameters exp)
                        (lambda-body exp)
                        env))
       ((begin? exp)
        (eval-sequence (begin-actions exp) env))
       ((cond? exp) (eval (cond->if exp) env))
       (else
        (error "Unknown expression type -- EVAL" exp))))
