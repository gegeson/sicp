;5m
コードの解説を試みる
目的は、(add 1 2)のように、'scheme-number を付けない生の数値を扱えるようにする、というもの。
まず、attach-tagは自明。
contentsは、数値そのものならcdrしなくていいという事でこれも自明。

では、type-tagで'scheme-number のタグ付けを行っているのは何故か。
理由は簡単で、apply-genericがtype-tagを使っていて、
そのタグを元に演算を決めているので、
タグが無いとapply-generic不可能。
1や2が'scheme-number をタグとして持っていれば良いだけの事なので、
1や2を与えられたら'scheme-number を返すようにすればよい。

こうすれば、あたかも1や2が 'scheme-number を付けているように振る舞うので、
既存のコードを書き換える必要はなく、この変更だけで済む。

(define (attach-tag type-tag contents)
  (cons type-tag contents))

(define (type-tag datum)
  (cond
    ((number? datum) 'scheme-number)
    ((pair? datum) (car datum))
      (else (error "Bad tagged datum -- TYPE-TAG" datum))))

(define (contents datum)
  (cond
    ((number? datum) datum)
    ((pair? datum)(cdr datum))
      (else (error "Bad tagged datum -- CONTENTS" datum))))
