(declare-sort A 0)
(declare-fun f (A) A)
(declare-fun a () A)
(declare-fun b () A)

(assert (distinct a b))
(assert (distinct a (f a)))
(assert (= (f b) (f a)))
(check-sat)
