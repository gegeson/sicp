11:37->11:41
11:42->12:07
12:21->12:46
考察ノート1

Scheme手習いとScheme修行で継続勉強済みなので大体何の話か分かるが、
analyze-assignmentがすぐに解釈できなかった

本文も読むとわかった

成功継続は値の代入に加えて、
（成功継続の行き先で失敗した場合に備えた）失敗継続を常にセットで持ち歩く。
代入の成功継続にセットで持ち歩くべき失敗継続は、
代入をリセットする機能を備えた失敗継続+受け取った失敗継続fail2である。
ということかな。

(define (analyze-assignment exp)
  (let ((var (assignment-variable exp))
        (vproc (analyze (assignment-value exp))))
       (lambda (env succeed fail)
               (vproc env
                      (lambda (val fail2) ; *1*
                              (let ((old-value
                                      (lookup-variable-value var env)))
                                   (set-variable-value! var val env)
                                   (succeed 'ok
                                            (lambda () ; *2*
                                                    (set-variable-value! var
                                                                         old-value
                                                                         env)
                                                    (fail2)))))
                      fail))))

これもちょっと複雑
でも、　
単に全体の成功継続の中に個々の成功継続/失敗継続がある、というだけの話かな

(define (analyze-application exp)
  (let ((pproc (analyze (operator exp)))
        (aprocs (map analyze (operands exp))))
       (lambda (env succeed fail)
               (pproc env
                      (lambda (proc fail2)
                              (get-args aprocs
                                        env
                                        (lambda (args fail3)
                                                (execute-application
                                                  proc args succeed fail3))
                                        fail2))
                      fail))))

(cons arg args)は要するに(cons (car apros) (cdr aprocs))かな
継続呼び出しで対象を限定することによって二分されるものを成功時に元に戻している
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

ここはほぼそのまんま
(define (execute-application proc args succeed fail)
  (cond ((primitive-procedure? proc)
         (succeed (apply-primitive-procedure proc args)
                  fail))
        ((compound-procedure? proc)
         ((procedure-body proc)
          (extend-environment (procedure-parameters proc)
                              args
                              (procedure-environment proc))
          succeed
          fail))
        (else
          (error
            "Unknown procedure type -- EXECUTE-APPLICATION"
            proc))))

carが成功→受け取った成功継続を返すだけ
carが失敗→cdrの失敗継続を呼び出す
ってだけかな
(define (analyze-amb exp)
  (let ((cprocs (map analyze (amb-choices exp))))
       (lambda (env succeed fail)
               (define (try-next choices)
                 (if (null? choices)
                     (fail)
                     ((car choices) env
                                    succeed
                                    (lambda ()
                                            (try-next (cdr choices))))))
               (try-next cprocs))))

成功継続は結局直接は呼び出されるものではなく、
失敗継続を加工して次に繋げるためのものであり、
本当に呼び出されるのは失敗継続だけである、
ということなのかな？
→読み直すと普通に成功継続も呼ばれてるな。
もう一周4.3.3読んでみよう

(define (driver-loop)
 (define (internal-loop try-again)
   (prompt-for-input input-prompt)
   (let ((input (read)))
        (if (eq? input 'try-again)
            (try-again)
            (begin
              (newline)
              (display ";;; Starting a new problem ")
              (amb_eval input
                       the-global-environment
                       ;; amb_eval 成功
                       (lambda (val next-alternative)
                               (announce-output output-prompt)
                               (user-print val)
                               (internal-loop next-alternative))
                       ;; amb_eval 失敗
                       (lambda ()
                               (announce-output
                                 ";;; There are no more values of")
                               (user-print input)
                               (driver-loop)))))))
 (internal-loop
   (lambda ()
           (newline)
           (display ";;; There is no current problem")
           (driver-loop))))
