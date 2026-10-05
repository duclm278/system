(
  .[]
  | select(has("roles"))
  | .roles[]
) |= (
  select(has("role"))
  | if has("tags") then
      .
    else
      . + {"tags": [.role]}
    end
)
