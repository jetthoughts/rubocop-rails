# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Rails::DynamicMethodInvocation do
  subject(:cop) { described_class.new }

  it 'registers an offense using `send :method`' do
    expect_offense(<<~RUBY)
      public_send :method
      ^^^^^^^^^^^^^^^^^^^ Do not use `.send` or `.public_send`.

      send :method
      ^^^^^^^^^^^^ Do not use `.send` or `.public_send`.
    RUBY
  end

  it 'registers an offense using `SomeInstance.new.send :method`' do
    expect_offense(<<~RUBY)
      Struct.new(:name).new('Value').public_send :name
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do not use `.send` or `.public_send`.

      Struct.new(:name).new('Value').send :name
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do not use `.send` or `.public_send`.
    RUBY
  end


  it 'registers an offense using `SomeInstance.new.send :method, *args`' do
    expect_offense(<<~RUBY)
      Struct.new(:name).new('Value').public_send :name=, 'argument'
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do not use `.send` or `.public_send`.

      Struct.new(:name).new('Value').send :name=, 'argument'
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do not use `.send` or `.public_send`.
    RUBY
  end

  it 'does not register an offense when using explicit name' do
    expect_no_offenses(<<~RUBY)
      Struct.new(:name).new('Value').name
    RUBY
  end
end
