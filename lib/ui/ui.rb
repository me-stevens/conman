# frozen_string_literal: true

class UI # rubocop:disable Metrics/ClassLength
  LIST   = 'List contacts'
  ADD    = 'Add contacts'
  SEARCH = 'Search contacts'
  UPDATE = 'Update contacts'
  EXIT   = 'Exit'

  NAME    = "\nContact name: "
  ADDRESS = 'Contact address: '
  PHONE   = 'Contact phone: '
  EMAIL   = 'Contact email: '
  NOTES   = 'Contact notes: '
  FIELDS_TO_QUESTIONS = {
    'name' => NAME,
    'address' => ADDRESS,
    'phone' => PHONE,
    'email' => EMAIL,
    'notes' => NOTES
  }.freeze

  YES   = 'y'
  CLEAR = "\033[H\033[2J"
  BYE   = " ConMan wishes you\n    a nice day"

  ADD_ANOTHER  = "\nAdd another contact? (y/n): "
  SEARCH_AGAIN = "\nSearch again? (y/n): "
  SEARCH_TERM  = "\nType search term: "

  MENU_OPTION  = "\nChoose a menu option: "
  SEPARATOR    = '--------------------'

  HEADER       = "\nNAME\tADDRESS\tPHONE\t\tEMAIL\tNOTES"
  HEADER_NAMES = "\nINDEX\tNAME"
  HEADER_WITH_INDEX = "\nINDEX\t#{HEADER[1..-1]}"

  EXPAND         = "\nDisplay one of these contacts' details? (y/n): "
  EXPAND_CONTACT = "\nChoose a contact to expand: "

  EDIT_CONTACT   = "\nChoose a contact to edit: "
  EDIT_FIELD     = "\nChoose a field to edit: "
  ANOTHER_FIELD  = "\nEdit another field? (y/n): "

  ERROR_NO_CONTACTS = "\nNo contacts were found."
  TRY_AGAIN         = ' Please try again: '
  ERROR_WRONG_INPUT = "ERROR: Wrong input. #{TRY_AGAIN}"
  ERROR_WRONG_PHONE =
    "ERROR: Wrong phone. Must be 11 digits and all numbers. #{TRY_AGAIN}"
  ERROR_WRONG_EMAIL = "ERROR: Wrong email. Must contain an @. #{TRY_AGAIN}"
  FIELDS_TO_ERRORS = {
    'phone' => ERROR_WRONG_PHONE,
    'email' => ERROR_WRONG_EMAIL
  }.freeze

  def initialize(console, validator)
    @console   = console
    @validator = validator
  end

  def ask_for_another
    ask_to(ADD_ANOTHER)
  end

  def ask_search_again
    ask_to(SEARCH_AGAIN)
  end

  def ask_to_expand
    ask_to(EXPAND)
  end

  def ask_another_field
    ask_to(ANOTHER_FIELD)
  end

  def ask_for_value_to_edit(field)
    ask_for_valid_field(FIELDS_TO_QUESTIONS[field], field)
  end

  def ask_for_fields
    contact = {}
    FIELDS_TO_QUESTIONS.each do |field, question|
      contact[field] = ask_for_valid_field(question, field)
    end
    contact
  end

  def ask_for_term
    ask_for(SEARCH_TERM)
  end

  def ask_for_contact_to_expand(contacts_count)
    ask_for_valid_index(EXPAND_CONTACT, contacts_count) - 1
  end

  def ask_for_contact_to_edit(contacts_count)
    ask_for_valid_index(EDIT_CONTACT, contacts_count) - 1
  end

  def ask_for_field_to_edit
    ask_for_valid_index(EDIT_FIELD, FIELDS_TO_QUESTIONS.size)
  end

  def ask_menu_option(menu)
    display_menu(menu)
    ask_for_valid_index(MENU_OPTION, menu.size)
  end

  def display_menu(menu)
    console.writeln
    console.writeln(SEPARATOR)
    menu.each { |item| display_item(item) }
    console.writeln(SEPARATOR)
  end

  def display_item(item)
    line = " #{item[0]}) #{item[1]}"
    console.writeln(line)
  end

  def display_all(contacts)
    console.writeln(HEADER)
    contacts.each { |contact| display(contact) }
  end

  def display(contact)
    values = contact.map { |key, value| "#{value}\t" if key != 'id' }
    console.writeln(values.compact.join)
  end

  def display_names(contacts)
    console.writeln(HEADER_NAMES)
    contacts.each_with_index do |contact, index|
      display_name(index + 1, contact)
    end
  end

  def display_name(index, contact)
    line = "#{index}\t#{contact['name']}"
    console.writeln(line)
  end

  def display_all_with_index(contacts)
    console.writeln(HEADER_WITH_INDEX)
    contacts.each_with_index do |contact, index|
      display_with_index(index + 1, contact)
    end
  end

  def display_with_index(index, contact)
    start = " #{index}\t"
    values = contact.map { |key, value| "#{value}\t" if key != 'id' }
    console.writeln("#{start}#{values.compact.join}")
  end

  def display_fields_with_index(contact)
    contact.each_with_index do |(key, value), index|
      console.writeln(format_field(index, key, value)) if key != 'id'
    end
  end

  def format_field(index, key, value)
    "#{index}\t#{key}: #{value}"
  end

  def error_no_contacts
    console.writeln(ERROR_NO_CONTACTS)
  end

  def error_wrong_input
    console.write(ERROR_WRONG_INPUT)
  end

  def error_message_for(field)
    FIELDS_TO_ERRORS.fetch(field, ERROR_WRONG_INPUT)
  end

  def error_wrong_field(field)
    console.write(error_message_for(field))
  end

  def clear
    console.writeln(CLEAR)
  end

  def bye
    console.writeln(SEPARATOR)
    console.writeln(BYE)
    console.writeln(SEPARATOR)
  end

  def contact_fields
    FIELDS_TO_QUESTIONS.keys
  end

  private

  attr_reader :console, :validator

  def ask_to(question)
    ask_for(question) == YES
  end

  def ask_for(question)
    console.write(question)
    console.read.chomp
  end

  def ask_for_valid_index(question, contacts_count)
    input = ''
    loop do
      input = ask_for(question)
      break if valid_index?(contacts_count, input)

      error_wrong_input
    end
    Integer(input)
  end

  def ask_for_valid_field(question, field)
    input = ''
    loop do
      input = ask_for(question)
      break if valid_field?(field, input)

      error_wrong_field(field)
    end
    input
  end

  def valid_index?(contacts_count, input)
    validator.valid_index?(contacts_count, input)
  end

  def valid_field?(field, input)
    validator.valid_field?(field, input)
  end
end
