; Elixir sigils for code (like ~q and ~S get Elixir highlighting)
(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @injection.content
  (#any-of? @_sigil_name "q" "S")
  (#set! injection.language "elixir"))

; Phoenix LiveView HEEx sigils (~H gets proper HTML/HEEx highlighting)
(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @injection.content
  (#eq? @_sigil_name "H")
  (#set! injection.language "heex"))

; Phoenix EEx sigils (~h gets HTML highlighting)
(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @injection.content
  (#eq? @_sigil_name "h")
  (#set! injection.language "html"))

