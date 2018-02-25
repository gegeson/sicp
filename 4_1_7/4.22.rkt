20:08->20:38

いろいろ考えたけど、condの実装見た限りではほぼ4.6から変更なしでいい気がする…
（紆余曲折の果てに微妙に名前変えてるが、実質4.6と同じもの）

あとはanalyzeに
((let? exp) (analyze (let->application exp)))
この一文を追加しただけ

これで一応動いている

きのこる庭のヒントと
ここ的に、これでいいっぽいな。
http://www.serendip.ws/archives/2105

(define (make-lambda parameters body)
  (cons 'lambda (cons parameters body)))

(define (let? exp) (tagged-list? exp 'let))

(define (let-var-exp-pairs exp)
  (cadr exp)
  )

(define (let-vars exp)
  (map car (let-var-exp-pairs exp)))

(define (let-exps exp)
  (map cadr (let-var-exp-pairs exp)))

(define (let-body exp)
  (cddr exp))

(define (let->application exp)
  (let ((vars (let-vars exp))
         (body (let-body exp)))
  (cons (make-lambda vars body) (let-exps exp)))
  )
