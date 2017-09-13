22:20->22:36
type-tagはaddなどが出来るように'scheme-number を返す必要がある、
と気付かなかった…
プログラムが動かないイライラもありあんまり理解できてないので、
頭が冷えたら2.78.re.rktを作成し解説を書いてみる…

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
