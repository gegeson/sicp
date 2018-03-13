7:35->7:44
pprocがfalseなら失敗
trueなら成功する

(define (require? exp) (tagged-list? exp 'require))
(define (require-predicate exp) (cadr exp))

((require? exp) (analyze-require exp))

(define (analyze-require exp)
  (let ((pproc (analyze (require-predicate exp))))
    (lambda (env succeed fail)
      (pproc env
        (lambda (pred-value fail2)
          (if (not pred-value)
              (fail2)
          (succeed 'ok fail2)))
          fail))))
---
動いてる
ピタゴラス数生成も動いてたのでこれで合ってるかな
ググった所
(not pred-value)
より
(not (true? pred-value))
のほうがいいっぽい。
そう言えばそんな話あったな
---
(define (an-element-of items)
 (require (not (null? items)))
 (amb (car items) (an-element-of (cdr items))))

(define count 0)

 (let ((x (an-element-of '(a b c)))
       (y (an-element-of '(a b c))))
   (set! count (+ count 1))
   (require (not (eq? x y)))
   (list x y count))
