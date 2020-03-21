#!/usr/bin/env ruby
gem 'minitest', '>= 5.0.0'
require 'minitest/autorun'
require_relative 'robot_name'

class ConstantNameGenerator
  def self.call
    "AA000"
  end
end

class RobotTest < Minitest::Test
  COMMAND_QUERY = <<-MSG
    Command/Query Separation:
    Query methods should generally not change object state.
  MSG

  NAME_REGEXP = /^[A-Z]{2}\d{3}$/

  def test_has_name
    assert_match NAME_REGEXP, Robot.new.name
  end

  def test_name_sticks
    robot = Robot.new
    robot.name
    assert_equal robot.name, robot.name
  end

  def test_different_robots_have_different_names
    refute_equal Robot.new.name, Robot.new.name
  end

  def test_reset_name
    robot = Robot.new
    name = robot.name
    robot.reset
    name2 = robot.name
    assert name != name2
    assert_equal name2, robot.name, COMMAND_QUERY
    assert_match NAME_REGEXP, name2
  end

  def test_name_uniqueness
    name_manager = RobotNameManager.new(name_generator: ConstantNameGenerator,
                                        max_naming_tries: 1)
    robot = Robot.new(name_manager: name_manager)
    assert_raises(RobotNameUniquenessError) {
      robot2 = Robot.new(name_manager: name_manager)
    }
  end

  def test_recycling_name_on_removal_from_service
    name_manager = RobotNameManager.new(name_generator: ConstantNameGenerator,
                                        max_naming_tries: 1)
    robot = Robot.new(name_manager: name_manager)
    robot.remove_from_service
    # the below *not* raising a RobotNameUniquenessError means that
    # name recycling works -- MiniTest has no "refute_raises"!  :-(
    robot = Robot.new(name_manager: name_manager)
  end

  def test_recycling_name_on_reset
    name_manager = RobotNameManager.new(name_generator: ConstantNameGenerator,
                                        max_naming_tries: 1)
    robot = Robot.new(name_manager: name_manager)
    # the below *not* raising a RobotNameUniquenessError means that
    # name recycling works -- MiniTest has no "refute_raises"!  :-(
    robot = robot.reset
  end

end
