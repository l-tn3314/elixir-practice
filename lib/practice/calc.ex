defmodule Practice.Calc do
  def parse_float(text) do
    {num, _} = Float.parse(text)
    num
  end

  def calc(expr) do
    # This should handle +,-,*,/ with order of operations,
    # but doesn't need to handle parens.
    expr
     |> String.split(~r/\s+/)
    #|> hd
    #|> parse_float
    #|> :math.sqrt()
     |> postfix([], [])
     |> eval_postfix([])

    # Hint:
    # expr
    # |> split
    # |> tag_tokens  (e.g. [+, 1] => [{:op, "+"}, {:num, 1.0}]
    # |> convert to postfix
    # |> reverse to prefix
    # |> evaluate as a stack calculator using pattern matching
  end


  def postfix([], [], symstack), do: symstack
  def postfix([], opstack, symstack) do
    [head | tail] = opstack
    postfix([], tail, symstack ++ [head])
  end
  def postfix(symlist, [], symstack) do
    [head | tail] = symlist
    case head do
      head when head in ["+", "-", "*", "/"] -> postfix(tail, [head], symstack) 
      #"+" -> postfix(tail, [head], symstack)
      #"-" -> postfix(tail, [head], symstack)
      #"*" -> postfix(tail, [head], symstack)
      #"/" -> postfix(tail, [head], symstack)
      _ -> postfix(tail, [], symstack ++ [head])
    end
  end 
  def postfix(symlist, opstack, symstack) do   
    [symlist_head | symlist_tail] = symlist
    case symlist_head do
      symlist_head when symlist_head in ["+", "-", "*", "/"] -> op_to_opstack(symlist_tail, opstack, symstack, symlist_head) # do something
      _ -> postfix(symlist_tail, opstack, symstack ++ [symlist_head])
    end
  end


  defp op_to_opstack(symlist, [], symstack, op), do: postfix(symlist, [op], symstack)
  defp op_to_opstack(symlist, opstack, symstack, op) do
    [opstack_head | opstack_tail] = opstack
    cond do
      op in ["+", "-"] -> op_to_opstack(symlist, opstack_tail, symstack ++ [opstack_head], op)
      opstack_head in ["*", "/"] -> postfix(symlist, [op] ++ opstack_tail, symstack ++ [opstack_head])
      opstack_head in ["+", "-"] -> postfix(symlist, [op] ++ opstack, symstack)
        
    end
  end



  def eval_postfix([], []), do: 0
  def eval_postfix([], operand_stack), do: hd operand_stack
  def eval_postfix(symlist, []) do
    [head | tail] = symlist
    case head do
      head when head in ["+", "-", "*", "/"] -> raise ArgumentError, message: "invalid postfix"
      _ -> eval_postfix(tail, [parse_float(head)])
    end
  end
  def eval_postfix(symlist, operand_stack) do
    [symlist_head | symlist_tail] = symlist
    if symlist_head in ["+", "-", "*", "/"] do
      eval_op(symlist_tail, operand_stack, symlist_head)
    else
      eval_postfix(symlist_tail, [parse_float(symlist_head)] ++ operand_stack) 
    end 
  end

  defp eval_op(symlist, operand_stack, op) do
    [operand1 | operand_stack_tail] = operand_stack
    [operand2 | operand_stack_rem] = operand_stack_tail
    #operand1 = parse_float(operand1_str)
    #operand2 = parse_float(operand2_str)
    #IO.inspect symlist, label: "symlist is: "
    #IO.inspect operand_stack, label: "operand_stack is: "
    #IO.puts(op)
    case op do
      "+" -> eval_postfix(symlist, [operand2 + operand1] ++ operand_stack_rem)
      "-" -> eval_postfix(symlist, [operand2 - operand1] ++ operand_stack_rem)
      "*" -> eval_postfix(symlist, [operand2 * operand1] ++ operand_stack_rem)
      "/" -> eval_postfix(symlist, [operand2 / operand1] ++ operand_stack_rem)
    end
  end
    
end
