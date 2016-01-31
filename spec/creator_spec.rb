require 'creator'

describe Creator do

  let (:ui)       {instance_double(UI).as_null_object}
  let (:db)       {DB.new}
  let (:creator)  {Creator.new(ui, db)}

  before :each do
    allow(ui).to receive(:ask_for_another).and_return(false)
  end

  it "saves the name introduced by the user" do
    allow(ui).to receive(:ask_for_name).and_return("name")
    creator.add_contacts
    expect_field(:name, "name")
  end

  it "saves the address introduced by the user" do
    allow(ui).to receive(:ask_for_address).and_return("address")
    creator.add_contacts
    expect_field(:address, "address")
  end

  it "saves the phone introduced by the user" do
    allow(ui).to receive(:ask_for_phone).and_return("123456")
    creator.add_contacts
    expect_field(:phone, "123456")
  end

  it "saves the email introduced by the user" do
    allow(ui).to receive(:ask_for_email).and_return("email@mail.com")
    creator.add_contacts
    expect_field(:email, "email@mail.com")
  end

  it "saves the notes introduced by the user" do
    allow(ui).to receive(:ask_for_notes).and_return("notes")
    creator.add_contacts
    expect_field(:notes, "notes")
  end

  it "adds two contacts" do
    allow(ui).to receive(:ask_for_another).and_return(true, false)
    creator.add_contacts
    expect(db.size).to eq(2)
  end

  it "prints one contact after adding it and all contacts after finished" do
    creator.add_contacts
    expect(ui).to have_received(:display_all).twice
  end

  it "prints two contacts after adding them and after finished" do
    allow(ui).to receive(:ask_for_another).and_return(true, false)
    creator.add_contacts
    expect(ui).to have_received(:display_all).exactly(3).times
  end

  def expect_field(key, value)
    expect(db.at(0)[key]).to eq(value)
  end
end