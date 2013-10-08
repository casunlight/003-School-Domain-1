class Student
  attr_accessor :name, :href, :bio, :edu, :work, :twitter, :linkedin, :facebook, :github, :rss, :treehouse, :codeschool, :coderwall, :fav1, :fav2, :fav3, :fav4, :website, :website1, :website2, :website3, :website4
  @@all = []

  def initialize
    @@all << self
  end
  
  def add_info(student_hash)
    student_hash.each do |k, v| 
      k.to_s
      self.send("#{k}=".to_sym, v)
    end
  end

  def self.all
    @@all
  end

  def self.reset_all
    @@all.clear
  end

  def self.find_by_name(name)
    @@all.select { |student_instance| student_instance.name.downcase == name.downcase }
  end
end
  

# student_info = {:name => "George", :bio => "I like Ruby"}

# student = Student.new(student_info)

# p student
