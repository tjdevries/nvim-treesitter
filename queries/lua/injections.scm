(
  (function_call
   prefix: (identifier) @_cdef_identifier
   args: (string_argument) @c
   )


  (#eq? @_cdef_identifier "cdef")
)

(
  (function_call
   prefix: (identifier) @_exec_lua_identifier
   args: (string_argument) @lua
   )


  (#eq? @_exec_lua_identifier "exec_lua")
)
