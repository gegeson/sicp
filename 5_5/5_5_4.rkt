14:49->15:21

"基本的な結合器は append-instruction-sequences です。
これは、順に実 行される任意の数の命令列を引数として取り、
すべての命令列の命令文を連結 した命令文を持つ命令列を返します。
難しいところは、結果となる命令列が必 要とするレジスタと変更するレジスタを決定する
というところです。
命令列の いずれかが変更するレジスタは、変更するレジスタとなります。
必要とするレ ジスタは、最初の命令列が実行される前に初期化されなければならないレジス タ
(最初の命令列に必要とされるレジスタ)
 と、それに加えて、
そのほかの命令列に必要とされるレジスタのうちそれ以前の命令列によって初期化 (変更) されていないものです。"

そのほかの命令列=2番目以降の命令列、かな
seq1 reg1を使用
seq2 reg1, reg2を使用
の場合、reg1とreg2で、reg1を重複して数える事はしない、と単にそういう意味かな
先を読んだ結果合ってるっぽいな
---
シンプルと言うか、まあせやねって感じの実装
---
(define (append-instruction-sequences . seqs)
  (define (append-2-sequences seq1 seq2)
    (make-instruction-sequence
     (list-union (registers-needed seq1)
                 (list-difference (registers-needed seq2)
                                  (registers-modified seq1)))
     (list-union (registers-modified seq1)
                 (registers-modified seq2))
     (append (statements seq1) (statements seq2))))
  (define (append-seq-list seqs)
    (if (null? seqs)
        (empty-instruction-sequence)
        (append-2-sequences (car seqs)
                            (append-seq-list (cdr seqs)))))
  (append-seq-list seqs))
---
seq1が変更し、かつseq2が必要とするレジスタについて、
保存処理を行った上で(cdr regs)に進むが、
そうするともはや(car regs)は
「seq1が必要とするレジスタ」かつ「seq1が変更しないレジスタ」となる
"この命令列は、seq1 によって必要とされるレジスタに加えて、
保存と復元が行われるレジスタを必要とし、seq1 で変更されるレジスタのう
ち、保存と復元が行われるレジスタを除いたものを変更します"
これの意味がよくわからなかったが、コードを読む限りそういうことらしい
でもなぜそうする必要があるのか…。単純にまだ結合を続ける事があるからかな。
---
(define (preserving regs seq1 seq2)
  (if (null? regs)
      (append-instruction-sequences seq1 seq2)
      (let ((first-reg (car regs)))
        (if (and (needs-register? seq2 first-reg)
                 (modifies-register? seq1 first-reg))
            (preserving (cdr regs)
             (make-instruction-sequence
              (list-union (list first-reg)
                          (registers-needed seq1))
              (list-difference (registers-modified seq1)
                               (list first-reg))
              (append `((save ,first-reg))
                      (statements seq1)
                      `((restore ,first-reg))))
             seq2)
            (preserving (cdr regs) seq1 seq2)))))
---
tack-onはまあわかる
---
(define (tack-on-instruction-sequence seq body-seq)
  (make-instruction-sequence
   (registers-needed seq)
   (registers-modified seq)
   (append (statements seq) (statements body-seq))))
---
parallelがちょっと疑問
無駄がある気がする
だけど、単にまとめてしまっても問題が起きないしこれ以外にやりようがないからってことなのかな。
---
(define (parallel-instruction-sequences seq1 seq2)
  (make-instruction-sequence
   (list-union (registers-needed seq1)
               (registers-needed seq2))
   (list-union (registers-modified seq1)
               (registers-modified seq2))
   (append (statements seq1) (statements seq2))))
