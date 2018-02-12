10:58->11:27
考察・方針については"./4.9.for.考察.rkt"を参照。
実験室は"mc/4.9.foreach.mc.rkt"
出来たー。

forって名前だけど実質foreach。
せっかくなので普通のforも作ろうかな、ということで"./4.9.for.rkt"で挑戦
→失敗。おぞましいので削除。whileも試したけどこれも失敗。
代わりに変数が複数あってもOKなバージョンの"./4.9.foreach2.rkt"をトライ。
→こっちは成功。

これを動かすことが目標。
(for (i (1 2 3))
  (display i)
  )

(define (for? exp)
    (tagged-list? exp 'for))

(define (for-i-list exp) (cadr exp))

(define (for-i exp) (car (for-i-list exp)))

(define (for-list exp) (cadr (for-i-list exp)))

(define (for-body exp) (caddr exp))

(define (for->apply_lambda exp)
  (let* ((i (for-i exp))
         (lst (for-list exp))
         (body (for-body exp)))
    (define (iter lst)
      (if (null? lst)
        nil
        (cons
         (list (make-lambda (list i) (list body)) (car lst))
         (iter (cdr lst)))))
    (make-begin (iter lst)))
  )

;;; M-Eval input:
(for (i (1 2 3))
  (display i)
  )
123
;;; M-Eval value:
#<void>

;;; M-Eval input:
(for (k (1 2 3))
  (display k)
  )
123
;;; M-Eval value:
#<void>

;;; M-Eval input:
(for (i (1 2 3))
  (begin
   (display i)
   (display "\n"))
  )
1
2
3

;;; M-Eval value:
#<void>
