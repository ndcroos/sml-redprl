signature REDPRL_LOG =
sig
  datatype level =
     INFO
   | WARN
   | DUMP
   | FAIL
   | TRACE

  val print : level -> Pos.t option * string -> unit
end

signature REDPRL_LOG_UTIL =
sig
  include REDPRL_LOG
  val trace : string -> unit
end
