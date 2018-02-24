; 20:26->20:48
; 20:50->20:57
#lang racket
; これを
'(letrec ((⟨var1⟩ ⟨exp1⟩)
         (⟨var2⟩ ⟨expn⟩))
  ⟨body⟩)

; こう、ということで合ってるんだよな
'(let ((var1 '*unassigned*)
      (var2 '*unassigned*))
  (set! var1 exp1)
  (set! var2 exp2⟩
  body⟩))

(define (make-let pairs body)
  (list 'let (list pairs) body)
)

(define (tagged-list? exp tag)
  (if (pair? exp)
      (eq? (car exp) tag)
      false))

(define (letrec? exp) (tagged-list? exp 'letrec))

(define (letrec-binding exp) (cadr exp))

(define (letrec-vars exp) (map car (letrec-binding exp)))
(define (letrec-exps exp) (map cadr (letrec-binding exp)))

(define (letrec-body exp) (caddr exp))

(define (letrec->let exp)
  (let* ((vars (letrec-vars exp))
        (exps (letrec-exps exp))
        (body (letrec-body exp))
        (init-vars (map (lambda (var) (list var '*unassigned*)) vars))
        (sets (map (lambda (var exp) (list 'set! var exp)) vars exps)))
      (cons 'let (cons init-vars (append sets (list body))))
    )
  )

; 出来たー。

(letrec->let '(letrec ((var1 exp1)
                      (var2 exp2))
               body))

'(let ((var1 *unassigned*)
       (var2 *unassigned*))
   (set! var1 exp1)
   (set! var2 exp2)
   body)

 (letrec->let '(letrec ((var1 exp1)
                       (var2 exp2)
                       (var3 exp3)
                       (var4 exp4))
                body))

'(let ((var1 *unassigned*)
       (var2 *unassigned*)
       (var3 *unassigned*)
       (var4 *unassigned*))
   (set! var1 exp1)
   (set! var2 exp2)
   (set! var3 exp3)
   (set! var4 exp4)
   body)

(letrec->let '(letrec ((fact
                              (lambda (n)
                                      (if (= n 1)
                                        1
                                        (* n (fact (- n 1)))))))
                      (fact 10)))

; 他、ここと同様のテストをした。"mc/4.20.a.mc.rkt"にて。
; http://www.serendip.ws/archives/2010
