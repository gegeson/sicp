17:18->17:30
とりあえず方針だけ考えてみる

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
  false)
)

こうすれば良さそう。
つまり、make-ifの変形版として => をifに変形するものを作りさえすれば多分万事うまく行く。
問題は引数のチェックぐらいかな。
本質的じゃないし引数チェックは飛ばすか。

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
