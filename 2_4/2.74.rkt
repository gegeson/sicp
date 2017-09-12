#lang racket/load
(require sicp)
(require racket/trace)
;パッケージごと作るのはダルいが…今度やろうかな。
;できそうな感触はある
;get-recordで検索ロジックを記述してしまった、
;などの小さいミスはあった（修正済み）が大枠は正しく解けた

;11:30->11:58
;3m+5m
;2.74.a
;dbのどこがkeyでどこが値なのかを型情報によって判定できるようになっている必要がある
;型情報にtype-tag-dbでアクセスできるようになっていればOK
(define (type-tag-db db) (car db))
(define (type-tag-record record) (car record))

(define (get-record db name)
    ((get 'get-record (type-tag-db db)) db name))

;2.74.b
;recordに型情報が付いていて、type-tag-recordでアクセスできればよい
(define (get-salary record)
  ((get 'get-salary-in-record (type-tag-record record)) record)
  )

;2.74.c
(define (find-employee-record dbs name)
  (cond
    ((null? dbs) #f)
    (else
     (let ((record (get-record (car dbs) name)))
       (if record
         record
         (find-employee-record (cdr dbs) name)
         )
       ))
    )
  )

;2.74.d
;新しい型を操作する演算をパッケージに追記し、またその型と演算のセットをテーブルにputする
;また、新しく追加するファイル・レコードにはtype-tagが付いている必要がある。
