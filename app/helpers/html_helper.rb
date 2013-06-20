module HtmlHelper

	# If condition is true, returns the class
	# If condition is false, returns blank space
	# To be used in html templates for conditional 
	# 		states of html class attributes
	def set_if(condition, value)
		condition ? value : ''
	end

  def course_grade_ranges course_grades

    divider = '-'

    return '' if course_grades.empty?

    grades = course_grades.map do |grade|
      if grade.name == 'K'
        0
      else 
        Integer(grade.name)
      end
    end

    # Do not ask me, I do not know.....
    # A prime example of self documenting code :)
    ranges = grades.sort.uniq.inject([]) do |spans, n|
      if spans.empty? || spans.last.last.succ != n
        spans + [n..n]
      else
        spans[0..-2] + [spans.last.first..n]
      end
    end

    result = []
    ranges.each do |range|
      if range.last == (range.first+1)
        if range.first == 0
          result << "K, #{range.last}"
        else
          result << "#{range.first}, #{range.last}"
        end
      elsif range.first != range.last
        if range.first == 0
          result << "K #{divider} #{range.last}"
        else
          result << "#{range.first} #{divider} #{range.last}"
        end
      else range.first == range.last
        if range.first == 0
          result << "K"
        else
          result << "#{range.first}"
        end
      end
    end

    result.join ', '
  end
end
