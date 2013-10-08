require_relative './cli_student'
require_relative './student_class'
require_relative './student_scraper'

student_scraper = StudentScraper.new('http://students.flatironschool.com/')
students_array = student_scraper.call

# students_array.each do |student_hash|
#   student = Student.new
#   student.add_info(student_hash)
#   p student
# end

cli_student = CLIStudent.new(students_array)
cli_student.call