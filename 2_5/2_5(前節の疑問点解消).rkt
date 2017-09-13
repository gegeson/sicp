#lang racket/load
(require sicp)
(require racket/trace)
;19:14->19:47
恥ずかしながら、ここ(2章5節)で出会った疑問点を解消するために2章4節を読み返すことで、
データ主導について初めて理解できた事があった
でも進まずに読み返すだけじゃ多分わからなかったので、無理やり進めたことは正解かもしれない
(わんこら式勉強法の教え「無理やりページを進める」である)

例えば
(define (install-scheme-number-package)
  (define (tag x)
    (attach-tag 'scheme-number x))
  (put 'add '(scheme-number scheme-number)
       (lambda (x y) (tag (+ x y))))
  (put 'sub '(scheme-number scheme-number)
       (lambda (x y) (tag (- x y))))
  (put 'mul '(scheme-number scheme-number)
       (lambda (x y) (tag (* x y))))
  (put 'div '(scheme-number scheme-number)
       (lambda (x y) (tag (/ x y))))
  (put 'make 'scheme-number
       (lambda (x) (tag x)))
  'done)

ここの'(scheme-number scheme-number)という記述がよくわからなかったが、
引数が複数ある演算については、型タグを複数（引数の数だけ）受け取るのだ
それを踏まえれば2章4節で理解できなかったこの関数の挙動にも合点がいく

(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (error
            "No method for these types -- APPLY-GENERIC"
            (list op type-tags))))))

これで、引数に対し(type-tags (map type-tag args))としてるのは何故だろう？と思っていた。
いつも型タグは一つなのでは？と思っていた。
だが違う。複数引数を受け取った時、それぞれの型タグをリストにしてtype-tagsに渡し、
それを元にgetで適切な演算を引っ張ってきているのだ。
上の例なら、
引数argsが　('scheme-number 1) ('scheme-number 2)だった場合、
type-tagsは('scheme-number　'scheme-number)になり、
procは、opが'add なら二つを足した上で型タグ'scheme-number を付ける演算となる。
そして、(map contents args)はargsから(1 2)だけを取り出す。
これらにprocを施すことで演算終了。

すっきりした！！
