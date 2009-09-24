require 'test/unit'
require 'test/unit/ui/console/testrunner'

class Test::Unit::UI::Console::TestRunner
  alias_method :start_tests, :start
  def start
    error_path = File.dirname(__FILE__) + "/../../log/errors.log"
    FileUtils.rm error_path, :force => true
    @logger ||= Logger.new(error_path)
    start_tests
  end

  def add_fault(fault)
    hax_output(fault)
    @faults << fault
    output_single(fault.single_character_display, 1)
    @already_outputted = true
  end

  def hax_output(fault)
    @logger.info(fault.long_display) # fault.long_display for the full trace
    @logger.info("\n")
  end
end
