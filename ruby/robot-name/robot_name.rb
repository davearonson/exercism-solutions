class RandomNameGeneratorWithDupChars
  def self.call
    (2.times.map { ('A'..'Z').to_a.sample } +
     3.times.map { ('0'..'9').to_a.sample }).join
  end
end


class RandomNameGeneratorWithoutDupChars
  def self.call
    (("A".."Z").to_a.sample(2) + ("0".."9").to_a.sample(3)).join
  end
end


# could have others generators, like constant, incremental, etc.; each
# may be a class or other object, just so long as it has a .call method.


class RobotNameUniquenessError < RuntimeError
end


class RobotNameManager

  require 'set'

  attr_reader :max_tries
  attr_reader :name_generator
  attr_reader :names_used

  def initialize(options={})
    parse_options(options)
    @names_used = Set.new
  end

  def generate_unique_name
    tries = 0
    begin
      name = name_generator.call
      tries += 1
    end while names_used.include?(name) && tries < max_tries
    check_name_uniqueness(name)
    names_used << name
    name
  end

  def release_name(name)
    names_used.delete name
    # not worrying about whether it was indeed UNavailable before....
  end

  private

  def check_name_uniqueness(name)
    if names_used.include? name
      raise(RobotNameUniquenessError,
            "ERROR: Could not make unique robot name in #{max_tries} tries!")
    end
  end

  def parse_options(options)
    @name_generator = (options[:name_generator] ||
                       RandomNameGeneratorWithDupChars)
    @max_tries = (options[:max_tries] || 100)
  end

end


class Robot

  attr_reader :name
  attr_reader :name_manager

  def initialize(options={})
    parse_options(options)
    set_to_factory_defaults
  end

  # needed mainly to test name recycling -- just going out of scope does not
  # guarantee gc will collect it (and therefore call its finalizer if any)
  def remove_from_service
    release_name
  end

  def reset
    set_to_factory_defaults
  end

  private

  def self.default_name_manager
    # memoize it so each robot w/ unspecified name mgr gets the same one,
    # not just any old name manager with the default name generator.
    @_default_name_manager ||= RobotNameManager.new
  end

  def parse_options(options)
    @name_manager = (options[:name_manager] || self.class.default_name_manager)
  end

  def release_name
    name_manager.release_name(name) if name
  end

  def set_to_factory_defaults
    release_name
    @name = @name_manager.generate_unique_name
    # any additional future [re-]settings can go here
  end

end
