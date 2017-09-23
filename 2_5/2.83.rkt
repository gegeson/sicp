#lang debug racket
(require sicp)
(require racket/trace)
;13:31->14:01
;17:20->17:58（ギブアップ）
;進展なし、ギブアップ。カンニング。
;参照URL
;www.serendip.ws/archives/1075
;apply-genericに問題はない…だと！？
;->そもそもデータ主導なんだから、raiseはそれぞれのパッケージに組み込むべきだった…
;あと実数パッケージも別に用意するべきだった。
;なぜ自分のraiseは駄目でコピペしたもの上手く行ってるのかは今度考えてみる（今はよくわからない）
;17:58->18:20
;追記
;+45m
;(display (raise (raise (make-rational 2 3))))
;上が上手く行って下が駄目なので、
;numerをここで呼び出すこととraise内で呼び出すことはどうやらわけが違うらしい
;何が？というのはよくわからない…
;が、括弧が余計に付く事が一因っぽい
;(apply-generic 'numer (rational 2 . 3))は機能しない
;(display (make-real (/ (* (numer (contents (make-rational 2 3))) 1.0) (denom (contents (make-rational 2 3))))))

;以下URLより、こんな簡約式を見つけた。
;http://uents.hatenablog.com/entry/sicp/020-ch2.4.3.1.md
;=> (real-part '(rectanglar 4 . 3)
;=> (apply-generic 'real-part '(rectanglar 4 . 3))
;=> (apply (get 'real-part '(rectangular)) (map contents '((rectanglar 4 . 3)))
;=> (apply car '((4 . 3)))
;=> 4
;つまり、何らかの型タグ付き引数を取る演算は必ずリストとして型タグを受け取る。
;そうでないものが型タグ付き引数
;生でnumerを書くと、まず
;(define (numer r)
;  (apply-generic 'numer r))
;この関数を通り、
;(put 'numer 'rational
;   (lambda (r) (numer r)))
;ここで定義したlambdaに移動し、
;(define (numer x)
;  (car x))
;こいつが呼ばれる、という順序。
;(apply-generic 'numer (rational 2 . 3))
;が機能しないのは、セットでrationalを渡す必要があるため。
;これだけ考えても十分な理解に達しないのでやっぱり先に進もう


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

(define (numer r)
  (display "out package numer ")(display r)(newline)(apply-generic 'numer r))
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
  (define (numer x)
   (display "in package numer ")(display x)(newline) (car x))
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

;; Coercion

(define (scheme-number->complex n)
  (make-complex-from-real-imag (contents n) 0))

(put-coercion 'scheme-number 'complex scheme-number->complex)


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
  (display "apply-generic ")(display op)(display " ")(display args)(newline)
  (define (apply-generic-iter op args)
    (display "apply-generic-iter ")(display op)(display " ")(display args)(newline)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      ;(display "type-tags ")(display type-tags)(newline)
      ;(display "proc ")(display proc)(newline)
      (if proc
        (apply proc (map contents args))
        (if (> (length args) 1)
            (apply-generic-iter op (coercion args))
          (error "No method for these types"
                 (list args op type-tags)))))))
    (apply-generic-iter op args))

(define (all_equal a args)
  (cond
    ((null? args) #t)
    ((eq? a (car args)) (all_equal a (cdr args)))
    (else #f)
    )
  )

(define (coercion args)
  (let ((type-tags (map type-tag args)))
    (cond
      ((null? type-tags) nil)
      ((= (length type-tags) 1) args)
      ((all_equal (car type-tags) (cdr type-tags)) args)
      (else
       (cons (car args) (coercion-iter (car args) (cdr args)))
       )
      ))
  )

(define (coercion-iter a args)
  (cond
      ((null? args) nil)
      (else
       (let ((a1->a (get-coercion (type-tag (car args)) (type-tag a))))
        (cons (a1->a (car args)) (coercion-iter a (cdr args)))
    )))
)


(put 'add '(scheme-number scheme-number scheme-number)
     (lambda (x y z) (+ x y z)))

(put 'add '(complex complex complex)
     (lambda (x y z) (add (add (cons 'complex x)
                               (cons 'complex y))
                          (cons 'complex z))))

;
(define (scheme-number->scheme-number n) n)
(define (complex->complex z) z)

(put-coercion 'scheme-number 'scheme-number
               scheme-number->scheme-number)
(put-coercion 'complex 'complex complex->complex)

;ここまで拝借
;(display (add
;          (make-complex-from-real-imag 1 2)
;          (raise (make-real 5.0))
;                 (raise (raise (make-rational 2 3)))))
;;これが可能なので、2.84の準備は整っているはず
;(newline)
;(display (raise 1))
;(newline)
(display (raise (raise (make-rational 2 3))))
;上が上手く行って下が駄目なので、
;numerをここで呼び出すこととraise内で呼び出すことはどうやらわけが違うらしい
;何が？というのはよくわからない…
;が、括弧が余計に付く事が一因っぽい
(newline)
;(display (make-real (/ (* (numer (make-rational 2 3)) 1.0) (denom (make-rational 2 3)))))
;上の式は以下の式に簡約されるが、以下の式は動かないので、ここが原因
;(apply-generic 'numer '(rational 2 3))
;以下ゴミ箱
;(define (raise x)

;  (let ((tag (type-tag x)))
;    (cond
;        ((equal? tag 'complex)
;         (error "複素数の上はない"))
;         ((equal? tag 'scheme-number)
;          (make-complex-from-real-imag (contents x) 0))
;          ((equal? tag 'rational)
;            (div (numer (contents x))
;                 (denom (contents x))))
;          ((equal? tag 'integer)
;           (make-rational (contents x) 1))
;           (else
;             (error "異常な型です")
;            )
;      ))
;  )
