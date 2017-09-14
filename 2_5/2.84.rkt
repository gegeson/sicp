#lang racket/load
(require sicp)
(require racket/trace)
;21:14->21:27
;21:29->22:28
;方針
;型の高さを示すリストを作り、
;それを元に任意の二つの型の高さを比較する関数を作る
;また、与えられた複数の型から、
;一番高い位置にある型はどれかを見つける関数も作る
;型が最大の変数と全ての変数を受け取り、
;それそれが最大のものと型が一致するまでraiseを繰り返す関数

;all_equal, coercion-iter, coercionを削除
;uniform-height, highestなどを追加
;apply-generic書き換え
;higher? how-highは不要だったが、一応残しておこう

(define (attach-tag type-tag contents)
  (cons type-tag contents))

(define (type-tag datum)
  ;(display "type-tag datum ")(display datum)(newline)
  (cond
    ((number? datum) 'scheme-number)
    ((pair? datum) (car datum))
      (else (error "Bad tagged datum -- TYPE-TAG" datum))))

(define (contents datum)
  ;(display "contents datum ")(display datum)(newline)
  (cond
    ((number? datum) datum)
    ((pair? datum)(cdr datum))
      (else (error "Bad tagged datum -- CONTENTS" datum))))


;;; 演算テーブルと型変換テーブルを別々で作成する

(define (put-table table key1 key2 item)
  (if (not (hash-has-key? table key1))
	  (hash-set! table key1 (make-hash))
	  true)
  (hash-set! (hash-ref table key1) key2 item))

(define (get-table table key1 key2)
  (define (not-found . msg)
;	(display msg (current-error-port))
;	(display "\n")
	false)
  (if (hash-has-key? table key1)
	  (if (hash-has-key? (hash-ref table key1) key2)
		  (hash-ref (hash-ref table key1) key2)
		  (not-found "Bad key -- KEY2" key2))
	  (not-found "Bad key -- KEY1" key1)))

(define *op-table* (make-hash))
(define (put op type item)
  (put-table *op-table* op type item))
(define (get op type)
  (get-table *op-table* op type))

(define *coercion-table* (make-hash))
(define (put-coercion type1 type2 item)
  (put-table *coercion-table* type1 type2 item))
(define (get-coercion type1 type2)
(get-table *coercion-table* type1 type2))
;;;; ---------------------------
;;;; type-tag system
;;;; ---------------------------

(define (attach-tag type-tag contents)
  (cons type-tag contents))

#|
(define (type-tag datum)
  (if (pair? datum)
      (car datum)
      (error "Bad tagged datum -- TYPE-TAG" datum)))

(define (contents datum)
  (if (pair? datum)
      (cdr datum)
      (error "Bad tagged datum -- CONTENTS" datum)))
|#

;;;; ---------------------------
;;;;  generic operators
;;;; ---------------------------


(define (add x y) (apply-generic 'add x y))
(define (sub x y) (apply-generic 'sub x y))
(define (mul x y) (apply-generic 'mul x y))
(define (div x y) (apply-generic 'div x y))

(define (real-part z) (apply-generic 'real-part z))
(define (imag-part z) (apply-generic 'imag-part z))
(define (magnitude-part z) (apply-generic 'magnitude-part z))
(define (angle-part z) (apply-generic 'angle-part z))

(define (numer r) (apply-generic 'numer r))
(define (denom r) (apply-generic 'denom r))

(define (equ? x y) (apply-generic 'equ? x y))
(define (zero? x) (apply-generic 'zero? x))


;;;; ---------------------------
;;;; rectangular and polar package
;;;; ---------------------------

(define (install-rectangular-package)
  ;; internal
  (define (real-part z)
	(car z))
  (define (imag-part z)
	(cdr z))
  (define (magnitude-part z)
  	(let ((x (real-part z))
  		  (y (imag-part z)))
  	  (sqrt (+ (* x x) (* y y)))))
  (define (angle-part z)
    (atan (imag-part z) (real-part z)))
  (define (make-from-real-imag x y)
	(cons x y))
  (define (make-from-mag-ang r a)
    (cons (* r (cos a)) (* r (sin a))))

  ;; interface
  (define (tag x) (attach-tag 'rectangular x))
  (put 'real-part '(rectangular) real-part)
  (put 'imag-part '(rectangular) imag-part)
  (put 'magnitude-part '(rectangular) magnitude-part)
  (put 'angle-part '(rectangular) angle-part)
  (put 'make-from-real-imag 'rectangular
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'rectangular
       (lambda (r a) (tag (make-from-mag-ang r a))))

  'done)

(define (install-polar-package)
  ;; internal
  (define (magnitude-part z) (car z))
  (define (angle-part z) (cdr z))
  (define (make-from-mag-ang r a) (cons r a))
  (define (real-part z)
    (* (magnitude-part z) (cos (angle-part z))))
  (define (imag-part z)
    (* (magnitude-part z) (sin (angle-part z))))
  (define (make-from-real-imag x y)
    (cons (sqrt (+ (* x x) (* y y)))
          (atan y x)))

  ;; interface
  (define (tag x) (attach-tag 'polar x))
  (put 'real-part '(polar) real-part)
  (put 'imag-part '(polar) imag-part)
  (put 'magnitude-part '(polar) magnitude-part)
  (put 'angle-part '(polar) angle-part)
  (put 'make-from-real-imag 'polar
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'polar
       (lambda (r a) (tag (make-from-mag-ang r a))))

  'done)

;; constructors
(define (make-from-real-imag x y)
  ((get 'make-from-real-imag 'rectangular) x y))
(define (make-from-mag-ang r a)
  ((get 'make-from-mag-ang 'polar) r a))

(install-rectangular-package)
(install-polar-package)


;;;; ---------------------------
;;;; complex package
;;;; ---------------------------

(define (install-complex-package)
  ;; internal
  (define (add-complex z1 z2)
    (make-from-real-imag (+ (real-part z1) (real-part z2))
                         (+ (imag-part z1) (imag-part z2))))
  (define (sub-complex z1 z2)
    (make-from-real-imag (- (real-part z1) (real-part z2))
                         (- (imag-part z1) (imag-part z2))))
  (define (mul-complex z1 z2)
    (make-from-mag-ang (* (magnitude-part z1) (magnitude-part z2))
                       (+ (angle-part z1) (angle-part z2))))
  (define (div-complex z1 z2)
    (make-from-mag-ang (/ (magnitude-part z1) (magnitude-part z2))
                       (- (angle-part z1) (angle-part z2))))

  ;; interface
  (define (tag z) (attach-tag 'complex z))
  (put 'add '(complex complex)
       (lambda (z1 z2) (tag (add-complex z1 z2))))
  (put 'sub '(complex complex)
       (lambda (z1 z2) (tag (sub-complex z1 z2))))
  (put 'mul '(complex complex)
       (lambda (z1 z2) (tag (mul-complex z1 z2))))
  (put 'div '(complex complex)
       (lambda (z1 z2) (tag (div-complex z1 z2))))
  (put 'make-from-real-imag 'complex
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'complex
       (lambda (r a) (tag (make-from-mag-ang r a))))
  (put 'equ? '(complex complex)
       (lambda (x y)
               (and (= (real-part x) (real-part y)) (= (imag-part x) (imag-part y)))))
  (put 'zero? '(complex)
       (lambda (x)
               (and (= (real-part x) 0) (= (imag-part x) 0))))
  ;; ex 2.77
  (put 'real-part '(complex) real-part)
  (put 'imag-part '(complex) imag-part)
  (put 'magnitude-part '(complex) magnitude-part)
  (put 'angle-part '(complex) angle-part)
  'done)

;; constructors
(define (make-complex-from-real-imag x y)
  ((get 'make-from-real-imag 'complex) x y))
(define (make-complex-from-mag-ang r a)
  ((get 'make-from-mag-ang 'complex) r a))

(install-complex-package)


;;;; ---------------------------
;;;; rational package
;;;; ---------------------------

(define (install-rational-package)
  ;; internal
  (define (numer x) (car x))
  (define (denom x) (cdr x))
  (define (make-rat n d)
    (let ((g (gcd n d)))
      (cons (/ n g) (/ d g))))
  (define (add-rat x y)
    (make-rat (+ (* (numer x) (denom y))
                 (* (numer y) (denom x)))
              (* (denom x) (denom y))))
  (define (sub-rat x y)
    (make-rat (- (* (numer x) (denom y))
                 (* (numer y) (denom x)))
              (* (denom x) (denom y))))
  (define (mul-rat x y)
    (make-rat (* (numer x) (numer y))
              (* (denom x) (denom y))))
  (define (div-rat x y)
    (make-rat (* (numer x) (denom y))
              (* (denom x) (numer y))))

  ;; interface
  (define (tag x) (attach-tag 'rational x))

  (define (raise-rat x)
  (make-real (/ (* (numer x) 1.0) (denom x))))

  (put 'numer 'rational
	   (lambda (r) (numer r)))
  (put 'denom 'rational
	   (lambda (r) (denom r)))
  (put 'add '(rational rational)
       (lambda (x y) (tag (add-rat x y))))
  (put 'sub '(rational rational)
       (lambda (x y) (tag (sub-rat x y))))
  (put 'mul '(rational rational)
       (lambda (x y) (tag (mul-rat x y))))
  (put 'div '(rational rational)
       (lambda (x y) (tag (div-rat x y))))
  (put 'make 'rational
       (lambda (n d) (tag (make-rat n d))))
  (put 'equ? '(rational rational)
       (lambda (x y)
               (and (= (numer x) (numer y)) (= (denom x) (denom y)))))
  (put 'zero? '(rational)
       (lambda (x) (= (numer x) 0)))
       (put 'raise '(rational)
          (lambda (x) (raise-rat x)))
  'done)

;; constructor
(define (make-rational n d)
  ((get 'make 'rational) n d))

(install-rational-package)


;;;; ---------------------------
;;;; scheme number package
;;;; ---------------------------

(define (install-scheme-number-package)
  ;; interface
  (define (tag x) (attach-tag 'scheme-number x))
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
  (put 'equ? '(scheme-number scheme-number)
       (lambda (x y) (= x y)))
  (put 'zero? '(scheme-number)
       (lambda (x) (= x 0)))
  (put 'raise '(scheme-number)
       (lambda (x) (make-rational x 1)))
  'done)

;; constructor
(define (make-scheme-number n)
  ((get 'make 'scheme-number) n))

(install-scheme-number-package)




;; 実数算術演算パッケージ
(define (install-real-package)
  (define (tag x)
    (attach-tag 'real x))
  (put 'add '(real real)
       (lambda (x y) (tag (+ x y))))
  (put 'sub '(real real)
       (lambda (x y) (tag (- x y))))
  (put 'mul '(real real)
       (lambda (x y) (tag (* x y))))
  (put 'div '(real real)
       (lambda (x y) (tag (/ x y))))
  (put 'equ? '(real real)
       (lambda (x y) (= x y)))
  (put '=zero? '(real)
       (lambda (x) (= x 0.0)))
  (put 'make 'real
       (lambda (x) (tag x)))
  (put 'raise '(real)
       (lambda (x) (make-complex-from-real-imag x 0)))
  'done)

(define (make-real n)
  ((get 'make 'real) n))

(install-real-package)

(define (raise x) (apply-generic 'raise x))

;ゴリ押しなやり方だが、apply-genericは可変長引数のインターフェイスとして残すが、
;内部でやる再帰はapply-generic-iterを使うようにすると、
;可変長でも対応可能になる
(define (apply-generic op . args)
  ;(display "apply-generic ")(display op)(display " ")(display args)(newline)
  (define (apply-generic-iter op args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
        (apply proc (map contents args))
        (apply-generic-iter op (uniform-height (highest? args) args))))))
    (apply-generic-iter op args))

(define type-tower '(complex real rational scheme-number))

(define (how-high t tower)
    (cond
        ((null? tower) (error "設定されていない型です" t))
        ((equal? t (car tower)) (length tower))
        (else
          (how-high t (cdr tower))
         )
      )
  )
(define (higher? a1 a2)
(let ((t1-height (how-high (type-tag a1) type-tower))
      (t2-height (how-high (type-tag a2) type-tower)))
  (if (> t1-height t2-height)
       a1
      a2
      )
    )
  )
(define (highest? args)
  (define (highest-iter1 args type)
        (cond
          ((null? args) nil)
          ((equal? (type-tag (car args)) type) (car args))
          (else
            (highest-iter1 (cdr args) type)
           )
          )
    )
  (define (highest-iter2 args tower)
    (cond
      ((null? tower) (error "異常な型" args))
      (else
       (let ((highest (highest-iter1 args (car tower))))
          (if (null? highest)
            (highest-iter2 args (cdr tower))
            highest)
         ))
    ))
  (highest-iter2 args type-tower)
)

(define (uniform-height highest other)
  (define (uniform-height-iter highest another)
    (if (equal? (type-tag highest) (type-tag another))
      another
      (uniform-height-iter highest (raise another))
      )
    )
  (cond
    ((null? other) nil)
    (else (cons (uniform-height-iter highest (car other))
                (uniform-height highest (cdr other))))
    )
  )

;以下のテスト用コードは以下から拝借したもの
;http://www.serendip.ws/archives/1070
(put 'add '(scheme-number scheme-number scheme-number)
     (lambda (x y z) (+ x y z)))

;これは自分で追加
(put 'add '(real real real)
    (lambda (x y z) (+ x y z)))

(put 'add '(complex complex complex)
     (lambda (x y z) (add (add (cons 'complex x)
                               (cons 'complex y))
                          (cons 'complex z))))

(define (add . args) (apply apply-generic (cons 'add args)))
;ここまで拝借

(define (scheme-number->scheme-number n) n)
(define (rational->rational n) n)
(define (real->real n) n)
(define (complex->complex z) z)

(put-coercion 'scheme-number 'scheme-number
               scheme-number->scheme-number)
(put-coercion 'rational 'rational
              rational->rational)
(put-coercion 'real 'real
              real->real)
(put-coercion 'complex 'complex complex->complex)

;; Coercion

(define (scheme-number->complex n)
  (make-complex-from-real-imag (contents n) 0))

(put-coercion 'scheme-number 'complex scheme-number->complex)


(newline)
(display (uniform-height (make-complex-from-real-imag 2 2) (list (make-real 2))))
(newline)
(display (add (make-real 2) (make-rational 1 2) (make-complex-from-real-imag 2 2)))
(newline)
(display (add (make-scheme-number 1) (make-rational 2 5) (make-real 2.1)))
;出来てる！

;テストコードを拝借
;http://www.serendip.ws/archives/1087
(define i 2)
(define r (make-real 2.0))
(define ra (make-rational 1 2))
(define c (make-complex-from-real-imag 1 3))

(newline)
(display (add i r))
(newline)
(display (add i ra))
(newline)
(display (add r c))
;出来てる！

;テストコードを拝借
;http://uents.hatenablog.com/entry/sicp/024-ch2.5.2.md
(newline)
(display (add (make-complex-from-real-imag 1 0)
             (add (make-scheme-number 2)
                  (add (make-rational 3 1) (make-scheme-number 4)))))
;これもできてる。完璧だ
