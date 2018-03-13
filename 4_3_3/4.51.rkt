6:58->7:09
巻き戻しをなくすだけでは…？

(define (permanent-assignment? exp)
  (tagged-list? exp 'permanent-set!))

(define (analyze-permanent-assignment exp)
  (let ((var (assignment-variable exp))
        (vproc (analyze (assignment-value exp))))
       (lambda (env succeed fail)
               (vproc env
                      (lambda (val fail2) ; *1*
                              (let ((old-value
                                      (lookup-variable-value var env)))
                                   (set-variable-value! var val env)
                                   (succeed 'ok fail2)))
                      fail))))
うむ、出来ている
;;; Amb-Eval input:
(define x 0)

;;; Starting a new problem
;;; Amb-Eval value:
ok

;;; Amb-Eval input:
(begin (set! x 1) (set! x 2) (amb))

;;; Starting a new problem
;;; There are no more values of
(begin (set! x 1) (set! x 2) (amb))

;;; Amb-Eval input:
x

;;; Starting a new problem
;;; Amb-Eval value:
0

;;; Amb-Eval input:
(begin (permanent-set! x 1) (permanent-set! x 2) (amb))

;;; Starting a new problem
;;; There are no more values of
(begin (permanent-set! x 1) (permanent-set! x 2) (amb))

;;; Amb-Eval input:
x

;;; Starting a new problem
;;; Amb-Eval value:
2
---
(define (require p)
 (if (not p) (amb)))

(define (an-element-of items)
 (require (not (null? items)))
 (amb (car items) (an-element-of (cdr items))))
---
これも実行してみる。
countが積もり積もっていく。
---
 (define count 0)

 (let ((x (an-element-of '(a b c)))
       (y (an-element-of '(a b c))))
   (permanent-set! count (+ count 1))
   (require (not (eq? x y)))
   (list x y count))
---
set!なら、失敗したら巻き戻すんだから、
常に1かな→合ってた
---
(define count 0)

(let ((x (an-element-of '(a b c)))
      (y (an-element-of '(a b c))))
  (set! count (+ count 1))
  (require (not (eq? x y)))
  (list x y count))
