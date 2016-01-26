require 'console'

class UI

  ADD_ANOTHER = "Add another contact? (y/n): "
  NAME        = "Contact name: "
  ADDRESS     = "Contact address: "

  def initialize(console)
    @console = console
  end

  def ask_for_another
    console.print(ADD_ANOTHER)
    console.read.chomp
  end

  def ask_for_name
    console.print(NAME)
    console.read.chomp
  end

  def ask_for_address
    console.print(ADDRESS)
    console.read.chomp
  end

  private

  attr_reader :console

end