# frozen_string_literal: true

module RuboCop
  module Cop
    module Rails
      #
      # Use `assert_not` instead of `assert !`.
      #
      # @example
      #   # bad
      #   send :method
      #
      #   # good
      #   # refactor code to not use metaprogramming like `send` or `public_send`
      #
      class DynamicMethodInvocation < RuboCop::Cop::Cop
        MSG = 'Do not use `.send` or `.public_send`.'

        def_node_matcher :offensive?, <<-PATTERN
          (send _ {:send :public_send} ...)
        PATTERN

        def on_send(node)
          add_offense(node) if offensive?(node)
        end
      end
    end
  end
end
