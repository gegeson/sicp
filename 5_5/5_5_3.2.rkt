8:40->9:21
9:29->9:46
11:10->11:25

被演算子列について
被演算子1と被演算子2の間ではenvを保存する必要があり、
被演算子nの評価と被演算子nによるarglの更新との間ではarglを保存する必要がある。

(define (compile-application exp target linkage)
  (let ((proc-code (compile (operator exp) 'proc 'next))
        (operand-codes
         (map (lambda (operand) (compile operand 'val 'next))
              (operands exp))))
    (preserving '(env continue)
     proc-code
     (preserving '(proc continue)
      (construct-arglist operand-codes)
      (compile-procedure-call target linkage)))))

(define (construct-arglist operand-codes)
  (let ((operand-codes (reverse operand-codes)))
    (if (null? operand-codes)
        (make-instruction-sequence '() '(argl)
         '((assign argl (const ()))))
        (let ((code-to-get-last-arg
               (append-instruction-sequences
                (car operand-codes)
                (make-instruction-sequence '(val) '(argl)
                 '((assign argl (op list) (reg val)))))))
          (if (null? (cdr operand-codes))
              code-to-get-last-arg
              (preserving '(env)
               code-to-get-last-arg
               (code-to-get-rest-args
                (cdr operand-codes))))))))

(define (code-to-get-rest-args operand-codes)
  (let ((code-for-next-arg
         (preserving '(argl)
          (car operand-codes)
          (make-instruction-sequence '(val argl) '(argl)
           '((assign argl
              (op cons) (reg val) (reg argl)))))))
    (if (null? (cdr operand-codes))
        code-for-next-arg
        (preserving '(env)
         code-for-next-arg
         (code-to-get-rest-args (cdr operand-codes))))))
---
;;;applying procedures

(define (compile-procedure-call target linkage)
  (let ((primitive-branch (make-label 'primitive-branch))
        (compiled-branch (make-label 'compiled-branch))
        (after-call (make-label 'after-call)))
    (let ((compiled-linkage
           (if (eq? linkage 'next) after-call linkage)))
      (append-instruction-sequences
       (make-instruction-sequence '(proc) '()
        `((test (op primitive-procedure?) (reg proc))
          (branch (label ,primitive-branch))))
       (parallel-instruction-sequences
        (append-instruction-sequences
         compiled-branch
         (compile-proc-appl target compiled-linkage))
        (append-instruction-sequences
         primitive-branch
         (end-with-linkage linkage
          (make-instruction-sequence '(proc argl)
                                     (list target)
           `((assign ,target
                     (op apply-primitive-procedure)
                     (reg proc)
                     (reg argl)))))))
       after-call))))

 (define (compile-proc-appl target linkage)
   (cond ((and (eq? target 'val) (not (eq? linkage 'return)))
          (make-instruction-sequence '(proc) all-regs
            `((assign continue (label ,linkage))
              (assign val (op compiled-procedure-entry)
                          (reg proc))
              (goto (reg val)))))
         ((and (not (eq? target 'val))
               (not (eq? linkage 'return)))
          (let ((proc-return (make-label 'proc-return)))
            (make-instruction-sequence '(proc) all-regs
             `((assign continue (label ,proc-return))
               (assign val (op compiled-procedure-entry)
                           (reg proc))
               (goto (reg val))
               ,proc-return
               (assign ,target (reg val))
               (goto (label ,linkage))))))
         ((and (eq? target 'val) (eq? linkage 'return))
          (make-instruction-sequence '(proc continue) all-regs
           '((assign val (op compiled-procedure-entry)
                         (reg proc))
             (goto (reg val)))))
         ((and (not (eq? target 'val)) (eq? linkage 'return))
          (error "return linkage, target not val -- COMPILE"
                 target))))
---
(and (not (eq? target 'val)) (eq? linkage 'return))
---
この条件でなんでエラーになるのかがよくわからん。
そこ以外はOK。
ネット見たら書いてそうなのであとでググろう→書いてない。
--
ここ以外の3つのパターンについては、
-
1つ目:ターゲットがval, linkがreturn以外なので、
行き先がvalに結果を勝手に代入してくれるし、
最後にcontinue呼ばれるはずだから、
continueにlink放り込んで手続き呼び出しにgotoするだけでOK
-
2つ目:ターゲットがval以外、linkがreturn以外なら、
帰る場所を指定しておいて、1つ目と同じ様に手続き呼び出しにgoto
指定しておいた帰る場所でtargetレジスタを更新し、
最後にlinkにgoto
-
3つ目:ターゲットがval, linkがreturnなら、
continueはもう何かしら指定されているし、
valは手続き呼び出しが勝手に代入してくれるはずなので、
手続き呼び出しにgotoするだけでOK
-
という感じ。
3つ目でcontinueをスタックに積まないことで末尾再帰を実現出来ているらしい。
原理としては多分5_4明示制御評価器と同じかな。
--
4つ目は、関数呼び出しの後に関数呼び出し元に帰ってくるのにその値はval以外に代入される
なんてことはないからエラーということなのかな。わからん。
分かる部分がわかってるからいいか。
---
おお、脚注に書いてあった。
"39 実際のところ、ターゲットが val でなく、リンクが return である場合にはエラーを 発生させます。
return リンクを要求する場所は手続きのコンパイルの中だけで、手続き は値を val に入れる約束だからです。"
なるほどね。ルール違反してるやんけってことか。
言われてみればその1とその3でvalに代入されることを前提にしてたな。
というわけで理解度十分。5.5.4へ。
---
