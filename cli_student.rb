
  # CLIStudent.new(students) --> Where students are a bunch of student instances.
  # CLIStudent.call
 
  # The CLIStudent should have a browse (which lists all students), a help, an exit, and a show (by ID or name), 
  # which will show all the data of a student.


class CLIStudent
  attr_accessor :students
  APPROVED_COMMANDS = [:browse, :help, :exit]

  def initialize(students)
    @students = students.collect {|s| Student.new(s)}
    @on = true
  end

  def on?
    @on
  end

  def help
    puts "Please type help, browse, show (name or ID), or exit."
    self.command_request
  end

  def command(input)
    if APPROVED_COMMANDS.include?(input.strip.downcase.to_sym)
      self.send(input)
    elsif input.start_with?("show")
      show_request = input.split("show").last.strip
      self.show(show_request)
    else
      "Didn't quite understand that.\n
      Please type help, browse, show (name or ID), or exit."
    end
  end

  def browse
    self.all 
  end

  def call
    while self.on?
      self.help
    end
  end

  def exit
    puts "Goodbye!"
    @on = false
  end

  def command_request
    self.command(gets.strip)
  end

end
