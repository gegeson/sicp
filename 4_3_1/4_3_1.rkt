21:20->21:41
やる気がなくてもとりあえず読むの精神
→やる気がなくても読んでよかった。面白い

"prime-sum-pair 手続きは、1.1.7 節の最初で記述した、
平方根関数を定義しようとした役に立たない “Lisp もどき” に怪しいぐらいそっくりに見えるかもしれません。
実は、あの考え方による平方根手続きは、実際に非決定性プログラムとして定式化できます。
探索メカニズムを評価器に組み込むことで、
純粋に宣言的な記述と、答えを計算する方法の命令的な仕様との間の区別は曖昧になってきます。4.4 節では、この路線をさらに進めていきます。"

ええ！？
あの平方根定義で実現できるパラダイムが研究されてる、って話があったのは覚えてるけど、
まさかあのまんまで本当に定義できるの！？
衝撃だよ。

非決定性計算、というのがなんだかよくわからないまま読み始めたが、疑問は色々消えたかも。
要するに、バックトラックによって解を探索するというだけで、
一応「何が返ってくるかがは予想できない」わけではないんだな

(prime-sum-pair '(1 4 5 8) '(9 16 110))

(define (square x) (* x x))

(define (smallest-divisor n)
  (find-divisor n 2))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))))

(define (divides? a b)
  (= (remainder b a) 0))

(define (prime? n)
  (= n (smallest-divisor n)))

  (define (require p)
    (if (not p) (amb)))

  (define (an-element-of items)
    (require (not (null? items)))
    (amb (car items) (an-element-of (cdr items))))

  (define (an-integer-starting-from n)
    (amb n (an-integer-starting-from (+ n 1))))


    (define (prime-sum-pair list1 list2)
      (let ((a (an-element-of list1))
            (b (an-element-of list2)))
        (require (prime? (+ a b)))
        (list a b)))
