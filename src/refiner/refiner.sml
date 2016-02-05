structure Refiner : REFINER =
struct
  structure Abt = Abt

  structure Kit =
  struct
    structure Tm = Abt
    open Abt

    type judgment = Sequent.sequent
    type evidence = abs

    val judgmentToString = Sequent.toString
    fun evidenceValence _ = (([],[]), SortData.EXP)

    fun evidenceToString e =
      let
        infix \
        val _ \ m = outb e
      in
        DebugShowAbt.toString m
      end

    open Sequent infix >>
    fun substJudgment (x, e) (H >> P) =
      SymbolTelescope.map H (metasubst (e,x))
        >> metasubst (e, x) P
  end

  open Abt

  structure Lcf = DependentLcf (Kit)
  structure Telescope = Lcf.T
  structure Tacticals = Tacticals(Lcf)

  type 'a choice_sequence = int -> 'a
  type name_store = symbol choice_sequence
  type ntactic = name_store -> Tacticals.Lcf.tactic

  fun Elim i _ =
    raise Fail "To be implemented"

  fun Intro r _ =
    raise Fail "To be implemented"

  fun Hyp i =
   raise Fail "To be implemented"

end