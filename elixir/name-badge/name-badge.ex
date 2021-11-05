defmodule NameBadge do
  def print(id, name, department) do
    id_part = if id, do: "[#{id}] - ", else: nil
    dept_to_print = if department, do: String.upcase(department), else: "OWNER"
    "#{id_part}#{name} - #{dept_to_print}"
  end
end
