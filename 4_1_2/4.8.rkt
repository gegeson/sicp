21:26->22:01

これを
(define (fib n)
  (let fib-iter ((a 1)
                 (b 0)
                 (count n))
    (if (= count 0)
        b
        (fib-iter (+ a b) a (- count 1)))))

こう変換する…
(define (fib n)
  (define (fib-iter a b count)
  (if (= count 0)
      b
      (fib-iter (+ a b) a (- count 1))))
  (fib-iter 1 0 n))

と言いたいところだけど、多分これじゃ足りなくて、

こうかな。
(define (fib n)
  (begin
   (define (fib-iter a b count)
           (if (= count 0)
             b
             (fib-iter (+ a b) a (- count 1))))
         (fib-iter 1 0 n)))

名前があるからラムダじゃ無理…いや不可能ではないが、Yコンビネータの実装なんて流石に求めてないだろうし。

(define (let2-var exp)
  (cadr exp))

(define (let2-params exp)
  (map car (let2-bindings exp))
  )

(define (let2-args exp)
  (map caadr (let2-bindings exp))
  )

(define (let2-bindings exp)
  (caddr exp))

(define (let2-body exp)
  (cadddr exp))

(define (make-define name params body)
  (list 'define (cons name params) body))

(define (make-begin seq) (cons 'begin seq))

(define (let->define_and_apply exp)
  (make-begin
   (list (make-define (let2-var exp) (let2-params exp) (let2-body exp))
         (cons (let2-var exp) (let2-args exp))))
  )

(define (let->combination exp)
  (cond
    ((= (length exp) 3)
         (let ((_lambda (make-lambda #RR(let-vars exp) #RR(let-body exp))))
           (cons _lambda (let-exps exp))
           ))
    ((= (length exp) 4) (let->define_and_apply exp))
    (else
      (error "letの構文がおかしいです" exp)
      ))
  )

実験室は"mc.4.8.mc.rkt"
出来たー。
'- と '=
の登録を忘れてて動かなかった。
しかしデバッグ環境を整えたお陰でプログラム自体に間違いはないという確信を持てたのですぐ気づけた。
デバッグ環境さまさまだ


;;; M-Eval input:
(define (fib n)
  (let fib-iter ((a 1)
                 (b 0)
                 (count n))
    (if (= count 0)
        b
        (fib-iter (+ a b) a (- count 1)))))

;;; M-Eval value:
ok

;;; M-Eval input:
(fib 1)

;;; M-Eval value:
1

;;; M-Eval input:
(fib 2)

;;; M-Eval value:
1

;;; M-Eval input:
(fib 3)

;;; M-Eval value:
2

;;; M-Eval input:
(fib 4)

;;; M-Eval value:
3

;;; M-Eval input:
(fib 5)

;;; M-Eval value:
5

;;; M-Eval input:
(fib 6)

;;; M-Eval value:
8

;;; M-Eval input:
(fib 7)

;;; M-Eval value:
13

;;; M-Eval input:
(fib 8)

;;; M-Eval value:
21
