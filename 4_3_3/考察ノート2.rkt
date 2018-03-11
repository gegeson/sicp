13:38->14:54

考察ノート2

継続が呼び出されるタイミングや呼び出され方がよく分かってないことに気が付いた
成功継続が呼び出されるのは、
普通に値が確定した時
失敗継続が呼び出されるのは、
(amb)が呼び出された時か、選択肢がなくなった時
(amb)は選択肢が必ず無くなるamb呼び出しなので、両方「選択肢がなくなった時」と言い換えられそう


(define (get-args aprocs env succeed fail)
  (if (null? aprocs)
      (succeed '() fail)
      ((car aprocs) env
                    ;; この aproc の成功継続
                    (lambda (arg fail2)
                            (get-args (cdr aprocs)
                                      env
                                      ;; get-args の再帰呼び出しの
                                      ;; 成功継続
                                      (lambda (args fail3)
                                              (succeed (cons arg args)
                                                       fail3))
                                      fail2))
                    fail)))

元のsucceedがどんどん太っていくプロセス

succeed
↓
(lambda (args fail3)
        (succeed (cons arg args)
                 fail3))
↓
(lambda (args fail3)
       ((lambda (args fail3)
               (succeed (cons arg args) fail3))
        (cons arg args) fail3))
↓
(lambda (args fail3)
       ((lambda (args fail3)
               ((lambda (args fail3)
                       (succeed (cons arg args)　fail3))
                (cons arg args) fail3))
        (cons arg args) fail3))

ここで
(succeed '() fail)が呼ばれると、
↓
((lambda (args fail3)
        ((lambda (args fail3)
                (succeed (cons arg args)　fail3))
         (cons arg args) fail3))
 (cons arg '()) fail)
↓
((lambda (args fail3)
         (succeed (cons arg args)　fail3))
 (cons arg (cons arg1 '())) fail)
↓
(succeed (cons arg2 (cons arg1 '()))　fail)
こうなる
