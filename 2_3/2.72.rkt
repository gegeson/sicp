#lang racket/load
(require sicp)
(require racket/trace)
;11:42->12:06
(require "2_3/2.70lib.rkt")
;多分合ってるが、解答を調べるとみんな違うことを言っている。
;しかし、以下のURLで自分と同じ考え方で同じ答えを出した人が居たので、これでOKということにする！
;https://github.com/kana/sicp/blob/master/ex-2.72.scm

;この木の図を見ながら考える
;                                        (ABCDE 31)
;
;                                /                     \
;
;                        (ABCD 15)                     (L E 16)
;
;                  /                 \
;
;              (ABC 7)                (L D 8)
;
;            /                \
;        (AB 3)               (L C 4)
;
;      /       \
;
;(L A 1)       (L B 2)
;encodeにAを渡した場合、
;(ABCD 15)と(L E 16)を走査し、2ステップかかる（Aは定義上必ず先頭！なので）
;左に進み、(ABC 7)と(L D 8)を走査し、2ステップかかる
;左に進み、(AB 3)と(L C 4)を走査し、2ステップかかる
;左に進み、(L A 1)と(L B 2)を捜査し、(L A 1)を発見する。2ステップかかる
;よって一般には2*(n-1)ステップかかり、O(n)

;encodeにEを渡した場合、
;(ABCD 15)と(L E 16)を走査し、(L E 16)を発見する。5ステップかかる。
;よって、一般にはnステップかかり、O(n)
;以下URLとほぼ一致。
;https://github.com/kana/sicp/blob/master/ex-2.72.scm

(define huffman-tree (generate-huffman-tree '((B 2) (A 1) (E 16) (D 8) (C 4))))
(display huffman-tree)

(define (encode message tree)
  (if (null? message)
    nil
    (append (encode-symbol (car message) tree)
            (encode (cdr message) tree))))

(define (encode-symbol message tree)
    (cond
      ((leaf? tree) nil)
      (else
       (let ((right-symbols (symbols (right-branch tree)))
             (left-symbols (symbols (left-branch tree))))
         (cond
           ((element_of_symbols? message right-symbols)
            (cons 1 (encode-symbol message (right-branch tree))))
           ((element_of_symbols? message left-symbols)
            (cons 0 (encode-symbol message (left-branch tree))))
           (else
            (error "message not found in tree --ENCODE SYMBOL" message))
           ))
         )
      ))
(define (element_of_symbols? message symbols)
    (cond
        ((null? symbols) #f)
        ((equal? message (car symbols)) #t)
        (else
          (element_of_symbols? message (cdr symbols))
         )
      )
  )
