functor Sequent (structure CJ : CATEGORICAL_JUDGMENT
                                  where type 'a Tm.O.Ar.Vl.Sp.t = 'a list
                                  where type 'a Tm.O.t = 'a RedPrlOperator.t
                 sharing type CJ.Tm.Sym.t = CJ.Tm.Var.t) : SEQUENT =
struct
  structure CJ = CJ
  structure Tm = CJ.Tm

  type var = Tm.variable
  type sym = Tm.symbol
  type psort = Tm.psort
  type sort = Tm.sort
  type operator = Tm.operator
  type hyp = sym
  type abt = CJ.Tm.abt

  structure Hyps : TELESCOPE = Telescope (Tm.Sym)
  type 'a ctx = 'a Hyps.telescope

  datatype 'a jdg =
     >> of 'a CJ.jdg ctx * 'a CJ.jdg
   | MATCH of operator * int * 'a

  infix >>

  fun map f =
    fn H >> catjdg => Hyps.map (CJ.map f) H >> CJ.map f catjdg
     | MATCH (th, k, a) => MATCH (th, k, f a)

  local
    open Hyps.ConsView
  in
    fun telescopeEq (t1, t2) =
      case (out t1, out t2) of
         (EMPTY, EMPTY) => true
       | (CONS (x, catjdg1, t1'), CONS (y, catjdg2, t2')) =>
           Tm.Sym.eq (x, y)
             andalso CJ.eq (catjdg1, catjdg2)
             andalso telescopeEq (t1', t2')
       | _ => false

  end

  val rec eq =
    fn (H1 >> catjdg1, H2 >> catjdg2) =>
          telescopeEq (H1, H2)
            andalso CJ.eq (catjdg1, catjdg2)
     | (MATCH (th1, k1, a1), MATCH (th2, k2, a2)) =>
          CJ.Tm.O.eq CJ.Tm.Sym.eq (th1, th2)
            andalso k1 = k2
            andalso Tm.eq (a1, a2)
     | _ => false

  local
    open PP
  in
    fun prettyHyps f : 'a ctx -> doc =
      Hyps.foldl
        (fn (x, a, r) => concat [r, text (Tm.Sym.toString x), text " : ", f a, line])
        empty

    fun pretty f : 'a jdg -> doc =
      fn H >> catjdg => concat [prettyHyps (CJ.pretty f) H, text "\226\138\162 ", CJ.pretty f catjdg]
       | MATCH (th, k, a) => concat [text (f a), text " match ", text (Tm.O.toString Tm.Sym.toString th), text " @ ", int k]
  end

  fun toString f = PP.toString 80 true o pretty f

  local
    open Tm
    structure O = RedPrlOpData
    infix $ $$ \

    fun fromAbt' (acc : abt CJ.jdg ctx) (seq : abt) : abt jdg =
      case Tm.out seq of
         O.MONO O.SEQ_CONCL $ [_ \ j] => acc >> CJ.fromAbt j
       | O.MONO (O.SEQ_CONS tau) $ [([], []) \ h, ([], [x]) \ seq] =>
         fromAbt' (Hyps.snoc acc x (CJ.fromAbt h)) seq
       | _ => raise Fail "Unrecognized sequent abt"
  in
    fun fromAbt (seq : abt) : abt jdg = fromAbt' Hyps.empty seq
  end

end
