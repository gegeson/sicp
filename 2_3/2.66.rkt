#lang racket/load
(require sicp)
(require racket/trace)
;19:27->19:53
(require "2_3/2.66lib.rkt")
;テストデータ及び2.66lib.rktの一部は
;http://d.hatena.ne.jp/awacio/20100816/1281968955
;より

;本質的じゃない部分が長すぎる場合は今回みたいに分ける癖を付けたい

(define (lookup_tree given_key set_of_tree)
  (cond ((null? set_of_tree) #f)
        ((equal? given_key (key (entry set_of_tree)))
         (entry set_of_tree))
         ((> given_key (key (entry set_of_tree)))
          (lookup_tree given_key (right-branch set_of_tree)))
          ((< given_key (key (entry set_of_tree)))
            (lookup_tree given_key (left-branch set_of_tree)))
    )
  )

(define records (list->tree (list
				   (make-record 1 "保毛川 保毛雄")
				   (make-record 3 "保毛川 保毛美")
				   (make-record 5 "不賀本 不賀之")
				   (make-record 7 "不賀本 不賀子")
				   (make-record 9 "茂賀 文太")
				   (make-record 11 "茂賀 文子"))))
(display (lookup_tree 1 records))
(newline)
(display (lookup_tree 3 records))
(newline)
(display (lookup_tree 5 records))
(newline)
(display (lookup_tree 7 records))
(newline)
(display (lookup_tree 9 records))
(newline)
(display (lookup_tree 11 records))
(newline)
(display (lookup_tree 12 records))
(newline)
