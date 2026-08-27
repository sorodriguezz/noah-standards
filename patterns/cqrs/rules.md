## 5.3 CQRS

Commands change state and return nothing meaningful; queries return data and
change nothing. The split is worth its cost only when the two sides have genuinely
different shapes — do not apply it uniformly.

- MUST name a command as an imperative (`PlaceOrder`) and a query as a question
  (`GetOrderSummary`). A `ProcessOrder` that also returns the order is neither.
- MUST give every command and query exactly one handler.
- MUST NOT return domain state from a command handler beyond an identifier or an
  acknowledgement. Returning the full aggregate re-couples the two sides.
- MUST NOT let a query handler mutate anything, including lazily populating a
  cache that changes an observable result.
- MUST keep validation of the command's SHAPE at the edge and validation of its
  INVARIANTS in the domain.
- SHOULD let queries bypass the domain model and read a projection directly. That
  is the payoff; a query that loads aggregates to build a DTO has paid the cost
  of CQRS without collecting the benefit.
- SHOULD keep commands and queries in separate directories, so the asymmetry is
  visible in the file tree.
