13:20->13:34

(define (last-pair l)
  (if (null? (cdr l))
      (car l)
      (last-pair (cdr l))))

(rule (append-to-form () ?y ?y))
(rule (append-to-form (?u . ?v) ?y (?u . ?z))
(append-to-form ?v ?y ?z))

(assert!
 (rule (last-pair (?x) ?x)))
(assert!
 (rule (last-pair (?u . ?v) ?last)
       (last-pair ?v ?last)))

;;; Query input:
(last-pair (3) ?x)

;;; Query results:
(last-pair (3) 3)

;;; Query input:
(last-pair (1 2 3) ?x)

;;; Query results:
(last-pair (1 2 3) 3)

;;; Query input:
(last-pair (2 ?x) (3))

;;; Query results:
(last-pair (2 (3)) (3))

これは無限ループ。
(last-pair ?x (3))
なんでかは…多分、
?x がどういう形か決定できない状態では定めようがないからじゃないかなあ。
解が下手したら無限にあるから、無限ループになるのでは
