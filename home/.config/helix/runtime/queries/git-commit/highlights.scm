[(comment) (generated_comment) (scissor)] @comment
(subject) @markup.heading
(branch) @string.special.symbol
(filepath) @string.special.path
(arrow) @punctuation.delimiter
(subject (subject_prefix) @function)
(prefix (type) @keyword)
(prefix (scope) @variable.parameter)
(prefix [ "(" ")" ":" ] @punctuation.delimiter)
(prefix "!" @punctuation.special)
(trailer (token) @variable.other.member)
(trailer (value) @string)
(breaking_change (token) @special)

(change kind: (new)) @diff.plus
(change kind: (deleted)) @diff.minus
(change kind: (modified)) @diff.delta
(change kind: [(renamed) (typechange)]) @diff.delta.moved

; jj uses JJ: lines where git uses # comments.
((subject) @comment
 (#match? @comment "^JJ:"))
((message_line) @comment
 (#match? @comment "^JJ:"))
((trailer) @comment
 (#match? @comment "^JJ:"))
((trailer
  (token) @jj_token
  (value) @comment)
 (#match? @jj_token "^JJ:"))
((trailer
  (token) @comment)
 (#match? @comment "^JJ:"))
