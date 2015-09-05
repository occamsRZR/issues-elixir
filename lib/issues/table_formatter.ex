defmodule Issues.TableFormatter do
	import Enum, only: [ each: 2, max: 1, map: 2 , map_join: 3 ]

	@doc """
	`data` is the parsed JSON object
	`columns` is the columns we want to print out form this JSON object
	"""
	def print_table_for_columns(rows, headers) do
		data_by_columns = split_into_columns(rows, headers)
		column_widths = max_column_widths(data_by_columns)
		format = format_for(column_widths)

		puts_one_line_in_columns headers, format
		IO.puts separator(column_widths)
		puts_in_columns data_by_columns, format
	end

	def split_into_columns(rows, headers) do
		for header <- headers do
			for row <- rows, do: printable(row[header])
		end
	end

	def printable(str) when is_binary(str), do: str
	def printable(str), do: to_string(str)

	def max_column_widths(columns) do
		for column <- columns do
			map(column, &(String.length(&1))) |> max 
		end
	end

	def format_for(column_widths) do
		map_join(column_widths, " | ", fn width -> "~-#{width}s" end) <> "~n"
	end

	def separator(column_widths) do
		map_join(column_widths, "-+-", fn width -> List.duplicate("-", width) end)
	end

	def puts_in_columns(data_by_columns, format) do
		data_by_columns
			|> List.zip
		  |> map(&Tuple.to_list/1)
			|> each(&puts_one_line_in_columns(&1, format))
	end

	def puts_one_line_in_columns(fields, format) do
		:io.format(format, fields)
	end
end
