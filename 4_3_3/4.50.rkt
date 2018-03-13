7:46->8:26

ここで(cdr choices)としてるけど、
まず0からchoicesの長さ-1までのランダムな整数リストを作って、
そのリストの値に基づいてlist-ref すればいいだけな気がするぞ

ググるとshuffleというものがあったので結構楽できた
(require sicp)でshuffleが破壊されてしまい、
動かなかったので検証はなしだけど多分大丈夫

(define (analyze-ramb exp)
  (let ((cprocs (map analyze (amb-choices exp))))
    (let ((randlist (shuffle (make-list (length cprocs)))))
      (lambda (env succeed fail)
              (define (try-next choices randlist)
                (if (null? randlist)
                  (fail)
                  ((list-ref choices (car randlist)) env
                                 succeed
                                 (lambda ()
                                         (try-next choices (cdr randlist))))))
              (try-next cprocs randlist)))))
