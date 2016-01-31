require 'finder'
require 'ui'
require 'db'

describe Finder do

  let (:contacts) {[
    {name: "name1", address: "address1"},
    {name: "name2", address: "address2"},
    {name: "name3", address: "address3"}
  ]}
  let (:ui)     {instance_double(UI).as_null_object}
  let (:finder) {Finder.new(ui, DB.new(contacts))}

  before :each do
    allow(ui).to receive(:ask_for_term).and_return("")
    allow(ui).to receive(:ask_to_expand).and_return(false)
    allow(ui).to receive(:ask_search_again).and_return(false)
  end

  it "finds a contact given an exact term" do
    expect(finder.search_contact("address1")).to eq([contacts.first])
  end

  it "finds several contacts given an inexact term" do
    expect(finder.search_contact("address")).to eq(contacts)
  end

  it "performs two searches" do
    allow(ui).to receive(:ask_search_again).and_return(true, false)
    finder.search_contacts
    expect(ui).to have_received(:ask_search_again).twice
  end

  it "prints names of all found contacts after a search" do
    finder.search_contacts
    expect(ui).to have_received(:display_names).once
  end

  it "asks for more details from a contact in the search results" do
    allow(ui).to receive(:ask_to_expand).and_return(true)
    allow(ui).to receive(:ask_for_contact).and_return(1)
    finder.search_contacts
    expect(ui).to have_received(:ask_to_expand).once
  end

  it "displays a specific contact if the user chooses one" do
    allow(ui).to receive(:ask_to_expand).and_return(true)
    allow(ui).to receive(:ask_for_contact).and_return(1)
    finder.search_contacts
    expect(ui).to have_received(:display_all).once
  end

end