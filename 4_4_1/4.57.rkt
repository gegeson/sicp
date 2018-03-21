11:59->12:05
答え見まくり

(assert! (rule (replace ?person1 ?person2)
               (and (job ?person1 ?job1)
                    (job ?person2 ?job2)
                    (or (same ?job1 ?job2)
                        (can-do-job ?job1 ?job2))
                    (not (same ?person1 ?person2)))))
a
(replace ?x (fect cy d))

b
(and (replace ?p1 ?p2)
     (salary ?p1 ?s1)
     (salary ?p2 ?s2)
     (lisp-value < ?s2 ?s1))
