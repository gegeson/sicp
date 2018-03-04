21:02->21:07

元のバージョンと
(define (eval-sequence exps env)
  (cond ((last-exp? exps) (_eval (first-exp exps) env))
        (else (_eval (first-exp exps) env)
              (eval-sequence (rest-exps exps) env))))

改善版とで
(define (eval-sequence exps env)
  (cond ((last-exp? exps) (_eval (first-exp exps) env))
        (else (actual-value (first-exp exps) env)
              (eval-sequence (rest-exps exps) env))))

こいつの挙動は変わらない。
(define (for-each proc items)
  (if (null? items)
      'done
      (begin (proc (car items))
             (for-each proc (cdr items)))))

なんで？
(for-each (lambda (x) (newline) (display x))
          (list 57 321 88))
---
→単純に、evalが最終的にactual-valueに行くところを先取りしてるだけだから。
ラムダは手続きだから実行時に強制、リストはプリミティブに渡すから強制、というのを
先取りしてるだけ、だと思う。
つまり、プリミティブ関数に最終的に渡ってる、というところがポイントなのかなあ。
