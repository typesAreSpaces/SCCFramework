(declare-fun a () bool)
(declare-fun b () bool)
(declare-fun c () bool)
(declare-fun d () bool)
(declare-fun e () bool)

(assert (or a b c))
(assert (or (not c) d (not e)))
(check-sat)
