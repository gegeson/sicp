17:18->17:30
+2
とりあえず方針だけ考えてみる

実装
20:31->21:14

評価器がcadrとかassocとか動かせるようになったので、改めてテスト
22:36->22:42

=>構文であることをチェックする関数、及び=>構文を処理する関数を作って、
expand-clausesに仕込めばいいだけかな
場合分けをcondにして、
(cond-else-clause? first)
の次に
(cond-=>-clause? first)
とでもすればいい気がする。
…
condの途中で=>が出てきた場合は？

(cond ((= x 2) x)
      ((assoc 'b '((a 1) (b 2))) => cadr)
      (else false))

(if (= x 2)
  x
  (cond ((assoc 'b '((a 1) (b 2))) => cadr)
  (else false))

(if (= x 2)
  x
  (if (assoc 'b '((a 1) (b 2)))
      (cadr (assoc 'b '((a 1) (b 2))))
      (cond (else false)))
)

(if (= x 2)
  x
  (if (assoc 'b '((a 1) (b 2)))
      (cadr (assoc 'b '((a 1) (b 2))))
      false)
      )

↑こんなふうにすれば良さそう。
つまり、make-ifの変形版として => をifに変形するものを作りさえすれば多分万事うまく行く。
問題は引数のチェックぐらいかな。
本質的じゃないし引数チェックは飛ばすか。

これを
(define (expand-clauses clauses)
  (if (null? clauses)
      #f
      (let ((first (car clauses))
            (rest (cdr clauses)))
           (if (cond-else-clause? first)
               (if (null? rest)
                   (sequence->exp (cond-actions first))
                   (error "ELSE clause isn't last -- COND->IF"
                          clauses))
               (make-if (cond-predicate first)
                        (sequence->exp (cond-actions first))
                        (expand-clauses rest))))))

こうじゃ
(define (expand-clauses clauses)
  (if (null? clauses)
      #f
      (let ((first (car clauses))
            (rest (cdr clauses)))
           (cond
              ((cond-else-clause? first)
               (if (null? rest)
                   (sequence->exp (cond-actions first))
                   (error "ELSE clause isn't last -- COND->IF"
                          clauses)))
              ((cond-=>-clause? first)
                (make-if (cond-test first)
                  (list (cond-recipient first) (cond-test first))
                  (expand-clauses rest)))
               (else (make-if (cond-predicate first)
                        (sequence->exp (cond-actions first))
                        (expand-clauses rest)))))))

補助
(define (cond-=>-clause? clause)
  (eq? (cadr clause) '=>))

(define (cond-recipient clause)
  (caddr clause))

(define (cond-test clause)
  (car clause))

"mc/4.5.mc.rkt"にて実験。

出来てるぞい！
carなどがまだ使えないのが残念→調査した結果使えるようになった。舌に示す

;;; M-Eval input:
(cond (false 2) (true => (lambda (x) x)) (else 3))

;;; M-Eval value:
#t

;;; M-Eval input:
(cond (false 2) (true => (lambda (x) 1)) (else 3))

;;; M-Eval value:
1

;;; M-Eval input:
(cond (false 2) (false => (lambda (x) 1)) (else 3))

;;; M-Eval value:
3

改めてテスト
;;; M-Eval input:
(cond ((assoc 'b '((a 1) (b 2))) => cadr)
(else false))

;;; M-Eval value:
2

(๑•̀ㅂ•́)و✧
