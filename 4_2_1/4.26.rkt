14:11->14:26

まずunlessを構文（派生手続き）として作る

(define (make-if predicate consequent alternative)
  (list 'if predicate consequent alternative))

(define (unless? exp) (tagged-list? exp 'unless))

(define (unless-condition exp) (cadr exp))
(define (unless-exceptional-value exp) (caddr exp))
(define (unless-usual-value exp) (cadddr exp))

(define (unless->if exp)
  (make-if (unless-condition exp) (unless-usual-value exp) (unless-exceptional-value exp))
  )

「unlessを構文とする」ということの意味は、上のようなものをevalに組み込む、ということになる。
こうして実装されたunlessは、関数ではないために関数のような扱い方は出来ない。
例えば高階関数とか。

unlessが手続きだったほうがいい場合。
こういうリストを受け取って、0割りが起きないかをそれぞれについてチェックする関数を作る場合とか？
((/ 1 2) (/ 2 0) (/ 3 5))
