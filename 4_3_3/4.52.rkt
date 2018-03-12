18:57->19:26
+7m
+3m
実験室は"amb/4.52.rkt"
---
最終的に、
デフォルト成功継続のこいつに値を渡して出力することになるのは確実
(lambda (val next-alternative)
        (announce-output output-prompt)
        (user-print val)
        (internal-loop next-alternative))
---
失敗時に成功継続にfail-caseを渡せばいいだけじゃね
多分こんな感じになる
→動いた
遅延評価の必要があった
---
(define (if-fail? exp)
  (tagged-list? exp 'if-fail))
(define (if-succeed exp)
  (cadr exp))
(define (if-fail exp)
  (caddr exp))

(define (analyze-if-fail exp)
  (let ((succeed-case (analyze (if-succeed exp)))
        (fail-case (if-fail exp)))
       (lambda (env succeed fail)
               (succeed-case env
                      (lambda (val fail2)
                           (succeed val fail2))
                             (lambda ()
                                     (succeed fail-case fail))))))
---
ググった感じ、失敗ケースでは俺のは「値」を即座に返してるけど、
みんなは式の計算というワンクッション置いた上で返してる。
あとsucceedを囲む必要も多分無い
だからベター版はこうだ
---
(define (analyze-if-fail2 exp)
  (let ((succeed-case (analyze (if-succeed exp)))
        (fail-case (analyze (if-fail exp))))
       (lambda (env succeed fail)
               (succeed-case env succeed
                             (lambda ()
                                     (fail-case env succeed fail))))))
---
(define (require p)
 (if (not p) (amb)))

(define (an-element-of items)
 (require (not (null? items)))
 (amb (car items) (an-element-of (cdr items))))

(if-fail (let ((x (an-element-of '(1 3 5))))
          (require (even? x))
          x)
        'all-odd)

(if-fail (let ((x (an-element-of '(1 3 5 8))))
          (require (even? x))
          x)
        'all-odd)

(if-fail (let ((x (an-element-of '(1 2 3 5 8 9))))
          (require (even? x))
          x)
        'all-odd)
-----------
;;; Amb-Eval input:
(if-fail (let ((x (an-element-of '(1 3 5))))
          (require (even? x))
          x)
        'all-odd)

;;; Starting a new problem
;;; Amb-Eval value:
(quote all-odd)

;;; Amb-Eval input:
(if-fail (let ((x (an-element-of '(1 3 5 8))))
          (require (even? x))
          x)
        'all-odd)

;;; Starting a new problem
;;; Amb-Eval value:
8
