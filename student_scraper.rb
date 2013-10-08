require 'open-uri'
require 'nokogiri'

class StudentScraper
  attr_accessor :main_index_url, :students

  def initialize(url)
    @main_index_url = url
    @student_data = []
    @index_page = Nokogiri::HTML(open(@main_index_url))
  end

  def call
    get_data_from_index
    get_all_student_data
    @student_data
  end

  def get_data_from_index
    @index_page.css('li.home-blog-post').each_with_index do |element, i|
      @student_data[i] = {}
      @student_data[i][:href] = element.css('div.blog-thumb').css('a[href]').attr('href').text
      if @student_data[i][:href] == "students/scottluptowski.html"
        @student_data[i][:name] = "Scott Luptowski"
      else
        @student_data[i][:name] = element.css('h3').css('a').text
      end
    end 
  end

  def get_all_student_data
    @student_data.each do |student_hash|
      temp_page = "#{@main_index_url}#{student_hash[:href]}"
      
      begin
        student_page = Nokogiri::HTML(open(temp_page))
        get_data_from_student_page(student_hash, student_page)
      rescue OpenURI::HTTPError => ex
        "Unable to open URL: #{temp_page}"
      end
    end
  end

  def get_data_from_student_page(student_hash, student_page)
    #basic student info:
    student_hash[:bio] = student_page.css('div.equalize', 'div.services-wrap')[0].css('#ok-text-column-2').css('p').text
    student_hash[:edu] = student_page.css('div.equalize', 'div.services-wrap')[0].css('#ok-text-column-3').css('ul').text
    student_hash[:work] = student_page.css('div.equalize', 'div.services-wrap')[0].css('#ok-text-column-4').css('p').text

    #social media urls:
    student_hash[:twitter] = student_page.css('div.social-icons').css('a[href]')[0].attr('href')
    student_hash[:linkedin] = student_page.css('div.social-icons').css('a[href]')[1].attr('href')
    student_hash[:github] = student_page.css('div.social-icons').css('a[href]')[2].attr('href')
    student_hash[:rss] = student_page.css('div.social-icons').css('a[href]')[3].attr('href') if student_page.css('div.social-icons').css('a[href]')[3]

    #coder cred urls
    student_hash[:treehouse] = student_page.css('#equalize', 'div.coder-cred').css('a[href]')[1].attr('href')
    student_hash[:codeschool] = student_page.css('#equalize', 'div.coder-cred').css('a[href]')[2].attr('href')
    student_hash[:coderwall] = student_page.css('#equalize', 'div.coder_cred').css('a[href]')[3].attr('href')
    
    #websites
    if student_page.css('div.section-services').css('div.ok-text-column')[4]
      student_page.css('div.section-services').css('div.ok-text-column')[4].css('a[href]').count.times do |i|
        student_hash["website#{i+1}".to_sym] = student_page.css('div.section-services').css('div.ok-text-column')[4].css('a[href]')[i].attr('href')
      end
    end

    #favorite cities/ books/ etc:
    # the if statements deal with the varying number of favorites per student
    if student_page.css('#equalize', 'div.services-wrap').css('#ok-text-column-2')[2]
      if student_hash[:name] == "Josh Scaglione"
        student_hash[:fav1] = student_page.css('#equalize', 'div.services-wrap').css('#ok-text-column-2')[2].css('a')[0].text
        student_hash[:fav2] = student_page.css('#equalize', 'div.services-wrap').css('#ok-text-column-2')[2].css('a')[1].text
        student_hash[:fav3] = student_page.css('#equalize', 'div.services-wrap').css('#ok-text-column-2')[2].css('a')[1].text
        student_hash[:fav4] = "NEW YORK"
      else
        student_page.css('#equalize', 'div.services-wrap').css('#ok-text-column-2')[2].css('a').count.times do |i|
          student_hash["fav#{i+1}".to_sym] = student_page.css('#equalize', 'div.services-wrap').css('#ok-text-column-2')[2].css('a')[i].text
        end
      end
    end
    student_hash = cleanup_data(student_hash)
  end

  def cleanup_data(student_hash)
    student_hash.each do |spec_type, spec|
      student_hash[spec_type] = spec.to_s.split("\n").collect { |line| line.strip }.join(" ")
      if spec == "#"
        student_hash[spec_type] = nil
      end
    end
  end
end