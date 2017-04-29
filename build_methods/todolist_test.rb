require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!

require_relative 'to_do'

class TodoListTest < MiniTest::Test

  def setup                                 # executed before every test
    @todo1 = Todo.new("Buy milk")
    @todo2 = Todo.new("Clean room")
    @todo3 = Todo.new("Go to gym")
    @todos = [@todo1, @todo2, @todo3]

    @list = TodoList.new("Today's Todos")
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
  end

  # Your tests go here. Remember they must start with "test_"

  def test_to_a
    assert_equal(@todos, @list.to_a)
  end

  def test_size
    assert_equal(3, @list.size)
  end

  def test_first
    assert_equal(@todo1, @list.first)
  end

  def test_last
    assert_equal(@todo3, @list.last)
  end

  def test_shift
    assert_equal(@todo1, @list.shift)
    assert_equal([@todo2, @todo3], @list.todos)
  end

  def test_pop
    assert_equal(@todo3, @list.pop)
    assert_equal([@todo1, @todo2], @list.todos)
  end

  def test_TypeError_for_nonTodo_object
    assert_raises(TypeError) { @list.add(1) }
    assert_raises(TypeError) { @list.add([1]) }
  end

  def test_add
    new_todo = Todo.new("Sweep floors")
    assert_equal(@list.todos + [new_todo], @list.add(new_todo))
  end

  def test_add_shovel_alias
    new_todo = Todo.new("Feed the cat")
    @list.add(new_todo)
    @todos << new_todo

    assert_equal(@todos, @list.to_a)
  end

  def test_item_at
    assert_raises(IndexError) { @list.item_at(100) }
    assert_equal(@todo1, @list.item_at(0))
    assert_equal(@todo2, @list.item_at(1))
  end

  def test_mark_done
    @list.mark_done("Buy milk")
    assert_equal(true, @todo1.done?)
  end

  def test_all_done?
    assert_equal(false, @list.done?)
  end

  def test_mark_done_at
    assert_raises(IndexError) { @list.mark_done_at(100) }
    @list.mark_done_at(1)
    assert_equal(false, @todo1.done?)
    assert_equal(true, @todo2.done?)
    assert_equal(false, @todo3.done?)
  end

  def test_undone_at
    assert_raises(IndexError) { @list.mark_undone_at(100) }
    @todo1.done!
    @todo2.done!
    @todo3.done!

    @list.mark_undone_at(1)

    assert_equal(true, @todo1.done?)
    assert_equal(false, @todo2.done?)
    assert_equal(true, @todo3.done?)
  end

  def test_mark_all_done
    @list.mark_all_done
    assert(@list.done?)
  end

  def test_mark_all_undone
    @list.mark_all_done
    @list.mark_all_undone
    assert(!@list.done?)
  end

  def test_remove_at
    assert_raises(IndexError) { @list.remove_at(100) }
    @list.remove_at(2)
    assert_equal([@todo1, @todo2], @list.to_a)
  end

  def test_find_by_title
    assert_equal(@todo2, @list.find_by_title("Clean room"))
  end

  def test_to_s
    output = <<-OUTPUT.chomp.gsub /^\s+/, ""
    ---- Today's Todos ----
    [ ] Buy milk
    [ ] Clean room
    [ ] Go to gym
    OUTPUT

    assert_equal(output, @list.to_s)

    output2 = <<-OUTPUT.chomp.gsub /^\s+/, ""
    ---- Today's Todos ----
    [ ] Buy milk
    [ ] Clean room
    [X] Go to gym
    OUTPUT

    @todo3.done!
    assert_equal(output2, @list.to_s)

    output3 = <<-OUTPUT.chomp.gsub /^\s+/, ""
    ---- Today's Todos ----
    [X] Buy milk
    [X] Clean room
    [X] Go to gym
    OUTPUT

    @list.mark_all_done
    assert_equal(output3, @list.to_s)
  end

  def test_each
    arr = []
    @list.each { |todo| arr << todo }
    assert_equal([@todo1, @todo2, @todo3], arr)
  end

  def test_each_returns_original_ist
    assert_equal(@list, @list.each {|todo| nil })
  end

  def test_select
    @todo1.done!
    list = TodoList.new(@list.title)
    list.add(@todo1)

    assert_equal(list.title, @list.title)
    assert_equal(list.to_s, @list.select{ |todo| todo.done? }.to_s)
  end
end