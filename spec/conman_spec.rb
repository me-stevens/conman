require 'conman'
require 'ui'

describe Conman do

  let (:ui) {instance_double(UI).as_null_object}
  let (:conman)  {Conman.new(ui)}

  it "saves the name introduced by the user" do
    allow(ui).to receive(:ask_for_name).and_return("name")
    conman.add_contact
    expect_field(:name, "name")
  end

  it "saves the address introduced by the user" do
    allow(ui).to receive(:ask_for_address).and_return("address")
    conman.add_contact
    expect_field(:address, "address")
  end

  it "saves the phone introduced by the user" do
    allow(ui).to receive(:ask_for_phone).and_return("123456")
    conman.add_contact
    expect_field(:phone, "123456")
  end

  it "saves the email introduced by the user" do
    allow(ui).to receive(:ask_for_email).and_return("email@mail.com")
    conman.add_contact
    expect_field(:email, "email@mail.com")
  end

  it "saves the notes introduced by the user" do
    allow(ui).to receive(:ask_for_notes).and_return("notes")
    conman.add_contact
    expect_field(:notes, "notes")
  end

  it "adds two contacts through the add-contacts loop" do
    allow(ui).to receive(:ask_for_another).and_return(true, false)
    allow(ui).to receive(:display)
    conman.add_contacts
    expect(conman.total_contacts).to eq(2)
  end

  it "prints contact after adding it" do
    allow(ui).to receive(:ask_for_another).and_return(false)
    allow(ui).to receive(:display)
    conman.add_contacts
    expect(ui).to have_received(:display).once
  end

  it "prints all contacts after finished" do
    allow(ui).to receive(:ask_for_another).and_return(true, false)
    allow(ui).to receive(:display)
    conman.add_contacts
    expect(ui).to have_received(:display_all).once
  end

  it "finds a contact given an exact term" do
    conman = Conman.new(ui, dummies)
    allow(ui).to receive(:ask_for_term).and_return("address2")
    expect(conman.search_contact).to eq([dummies[1]])
  end

  it "finds several contacts given an inexact term" do
    conman = Conman.new(ui, dummies)
    allow(ui).to receive(:ask_for_term).and_return("address")
    expect(conman.search_contact).to eq(dummies)
  end

  it "performs two searches" do
    allow(ui).to receive(:ask_search_again).and_return(true, false)
    conman.search_contacts
    expect(ui).to have_received(:ask_search_again).twice
  end

  it "prints all found contacts after a search" do
    conman = Conman.new(ui, dummies)
    allow(ui).to receive(:ask_for_term).and_return("address")
    conman.search_contacts
    expect(ui).to have_received(:display_all).once
  end

  def expect_field(key, value)
    expect(conman.contact_of_id(0)[key]).to eq(value)
  end

  def dummies
    contact1 = {name: "name1", address: "address1"}
    contact2 = {name: "name2", address: "address2"}
    contact3 = {name: "name3", address: "address3"}
    contacts = [contact1, contact2, contact3]
  end
end
