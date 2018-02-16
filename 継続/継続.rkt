#lang debug racket

今4.1なので継続はまだちょっと先だけど、
なんとなくSICPブロガーたちの継続特集見ててやりたくなったので、
継続を軽く勉強してみた。
とりあえず継続を解釈できるようにはなった。
Scheme修行でlet/ccは勉強済みだったけど、殆ど忘れてる上にcall/ccはまた勝手が違うので、わかりづらい。

"dft.rkt"も継続の勉強

19:20->20:31
20:40->21:03

主にこちらで疑問が解決した。
http://uents.hatenablog.com/entry/sicp/058-continuations.md

他、ここなどから引用している。
https://practical-scheme.net/wiliki/wiliki.cgi?Scheme%3A%E4%BD%BF%E3%81%84%E3%81%9F%E3%81%84%E4%BA%BA%E3%81%AE%E3%81%9F%E3%82%81%E3%81%AE%E7%B6%99%E7%B6%9A%E5%85%A5%E9%96%80
https://ja.wikibooks.org/wiki/Scheme/%E7%B6%99%E7%B6%9A%E3%81%AE%E7%A8%AE%E9%A1%9E%E3%81%A8%E5%88%A9%E7%94%A8%E4%BE%8B
http://sicp.g.hatena.ne.jp/keyword/%e7%b6%99%e7%b6%9a%e3%83%9e%e3%83%a9%e3%82%bd%e3%83%b3
---
(let ((x (call/cc (lambda (c) (cons c 4)))))
  (cond
; 継続呼び出しを行わなければ、値を返してプログラムは終了する。
    ((= (cdr x) 0) #t)
; x を表示した後、(car x)に保存されている継続を呼び出す。
    (else (display x) (newline) ((car x) (cons (car x) (- (cdr x) 1))))))

cは、前後を記憶している
c ==（car x）の正体はこれ
(lambda (xx)
        (let ((x xx))
          (cond
            ; 継続呼び出しを行わなければ、値を返してプログラムは終了する。
            ((= (cdr x) 0) #t)
            ; x を表示した後、(car x)に保存されている継続を呼び出す。
            (else (display x) (newline) ((car x) (cons (car x) (- (cdr x) 1))))))
        )

c == (car x)に (cons (car x) (- (cdr x) 1) を渡すことで、
x自身を(c . 3) に変化させている
----
(* 2 (call/cc (lambda (cont) (cont (fact 10)))))
これのcontの正体は
(lambda (xx)
  (* 2 xx)
)
これ。
継続の中で既に継続呼び出しがあるので、
返り値は
(lambda (xx) (* 2 xx))
に (fact 10) を渡したものになる。
----
http://d.hatena.ne.jp/higepon/20061221/1166716295
(define (for-loop max)
  (let ((i 0) (cont #f))
    (if (> max (call/cc (lambda (c) (set! cont c) i)))
        (begin
          (p i)
          (set! i (+ i 1))
          (cont i)))))

(for-loop 5)

これのcontの正体は
(lambda (xx)
  (if (> max xx)
      (begin
        (p i)
        (set! i (+ i 1))
        (cont i))))
これ。
----
http://d.hatena.ne.jp/higepon/20061222/1166801392
(define (fact n m)
  (call/cc
   (lambda (end)
     (letrec ((fact2 (lambda (n sum)
                       (if (< n m)
                           (end sum)
                           (fact2 (- n 1) (* n sum))))))
       (fact2 n m)))))

endの正体はこれ。
(lambda (xx) xx)
----
これだけ意味がわからん。継続の変換は出来る。
(define (fail) #f)
(define (amb-proc . x)
  (define former-fail fail)
  (if (null? x)
    (fail)
    (call/cc (lambda (return) ; 分岐点
      (set! fail (lambda () ; 選ばなかった選択肢を保存
        (set! fail former-fail)
        (return (apply amb-proc (cdr x)))))
      (return ((car x)))))))

return の正体はこれ。
(lambda (xx)
  (if (null? x)
        (fail)
        xx))
---
http://d.hatena.ne.jp/higepon/20061223/1166851241

これはもうひと目で解釈できる。
("a" "b" "c")
みたいに文字列のリストを受け取って、つなげたものを最後に返すだけ。
(define (message-join l)
   (call/cc
    (lambda (end)
      (letrec ((message-join-iter (lambda (ll messages)
                                    (if (null? ll)
                                        (end messages)
                                        (message-join-iter (cdr ll) (string-join (list messages (car ll))))))))
      (message-join-iter l "")))))
---
http://d.hatena.ne.jp/higepon/20061220/1166628603

(+ 2 (call/cc (lambda (c) (* 3 (c 4)))))
cは
(lambda (xx) (+ 2 xx))
cに
(c 4)
と4が渡されているので、一気に
(lambda (xx) (+ 2 xx))に飛んで、結果は6になる、らしい。
---
http://d.hatena.ne.jp/higepon/20061220/1166628603

(define num-list (list 1 2 3 4 5 6))
(define (sum l)
  (let* ((cont #f) (value (call/cc (lambda (c) (set! cont c) 0))))
    (define (sum-iter ll s)
      (if (null? (cdr ll))
          (cont s)
          (sum-iter (cdr ll) (+ s (car ll)))))
    (if (not (= 0 value))
        (begin (display "escape") value)
        (sum-iter l 0))))
リストの最後に来たらcontにsumを渡してvalueにsumが渡って、
sumの本文をもう一回実行して、
(not (= 0 value))で引っかかって
(begin (display "escape") value)
って感じか。
読める読める
---
http://uents.hatenablog.com/entry/sicp/058-continuations.md

コレに対して
(define t1 '(a (b (d h) (c e (f i) g))))
こう出力する関数。

racket@> (dft-node t1)
=> 'a

racket@> (restart)
=> 'b

racket@> (restart)
=> 'c

;; ...

racket@> (restart)
=> 'done

---
(define *saved* '())

(define (dft-node tree)
  (cond ((null? tree) (restart))
        ((not (pair? tree)) tree)
        (else (call/cc
               (lambda (cc)
                 (set! *saved*
                       (cons (lambda ()
                               (cc (dft-node (cdr tree))))
                             *saved*))
                 (dft-node (car tree)))))))

(define (restart)
  (if (null? *saved*)
      'done
      (let ((cont (car *saved*)))
        (set! *saved* (cdr *saved*))
        (cont))))

ccの正体は
(lambda (xx)
(cond ((null? tree) (restart))
      ((not (pair? tree)) tree)
      (else xx)
つまり、ccに渡した値が単に結果になる

これも、まあ読めるぞ。
