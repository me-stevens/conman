require 'actions/terminator'
require 'actions/kernel_fake'

describe Terminator do

  let (:ui)         {instance_double(UI).as_null_object}
  let (:kernel)     {KernelFake.new}
  let (:terminator) {described_class.new(ui, kernel)}

  it "prints a goodbye message" do
    terminator.run
    expect(ui).to have_received(:bye).once
  end

  it "exits the program when called" do
    terminator.run
    expect(kernel.was_exit_called?).to eq(true)
  end

end