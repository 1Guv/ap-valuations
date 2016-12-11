# APNAPLATES - VALUATION FORMULA
def apnaplates_prompt()
  puts "#{@reg} >> #{@reg_display}"
  print "www.APNAPLATES.com > ? "
end

def registration_questions()

  puts "\nwww.APNAPLATES.com"
  puts "VALUATION SERVICES"

  puts "\nPlease state the exact number plate?"
  apnaplates_prompt
  @reg = $stdin.gets.chomp

  puts "\nPlease state the plate in ENGLISH or PUNJABI words with spaces?"
  apnaplates_prompt
  @reg_display = $stdin.gets.chomp

  # Does the registration have MORE OR LESS characters than the actual word that it represents?
  begin
    puts "\nDoes the reg have the EXACT, MORE or LESS characters than the actual word that it represents?"
    puts "\nPlease type EXACT, MORE or LESS"
    apnaplates_prompt
    @more_or_less_characters = $stdin.gets.chomp
  end until @more_or_less_characters =~ /(exact|e|more|m|less|l)/i

  # Does the registration have duplicate letters or numbers eg for name RAVS is R4VVS or R4VSS?
  begin
    puts "\nDoes the registration have duplicate sequential letters or numbers? (yes or no)"
    puts "\neg for name RAVS is R4VVS or R4VSS"
    puts "eg for name RAVS is R77AVS or RAV 55"
    apnaplates_prompt
    @duplicates = $stdin.gets.chomp
  end until @duplicates =~ /(yes|y|no|n)/i

  begin
    puts "\nPlease state if the plate is a good match to the words above?"

    puts "1: Not sure if its a good match or not!"
    puts "2: Not really - (a number or letter will need modifying to look like another number or letter)"
    puts "3: Kind of - (most leters match the word but may not be in the correct position)"
    puts "4: Good Match - (all numbers represent the correct character and are in the correct position)"
    puts "5: Exact Match - (two words with no modifications)"
    puts "6: Exact Match - (single word with no modifications)"

    # puts "\n1: Exact Match - (single word with no modifications)"
    # puts "2: Good Match - (all numbers represent the correct character and are in the correct position)"
    # puts "3: Kind of - (most leters match the word but may not be in the correct position)"
    # puts "4: Not really - (a number or letter will need modifying to look like another number or letter)"
    # puts "5: Not Sure"
    apnaplates_prompt
    @reg_match_weighting = $stdin.gets.chomp
  end until @reg_match_weighting =~ /(1|2|3|4|5|6)/

  puts "\nWhat are the total amount of characters in the plate?"
  apnaplates_prompt
  @total_characters = $stdin.gets.chomp

  puts "\nHow many digits?"
  apnaplates_prompt
  @digits = $stdin.gets.chomp

  puts "\nHow many letters?"
  apnaplates_prompt
  @letters = $stdin.gets.chomp

  begin
    puts "\nWhat is the plate type eg CURRENT, PREFIX, SUFFIX or DATELESS?"
    apnaplates_prompt
    @plate_type = $stdin.gets.chomp
  end until @plate_type =~ /(c|current|p|prefix|s|suffix|d|dateless)/i

  if @plate_type =~ /(c|current|p|prefix|s|suffix)/i
    registration_age
  else
    $reg_age = "Dateless"
  end

  puts "\nHow many spaces between words or numbers? (1,2,3 etc or none)"
  apnaplates_prompt
  @spaces = $stdin.gets.chomp

  puts "\nDo any of the #{@letters} letters need to be modified?"
  puts "eg: do any of the letters need to look like a different letter"
  apnaplates_prompt
  @mod_letter = $stdin.gets.chomp

  puts "\nDo any of the #{@digits} numbers need to be modified?"
  puts "eg do any of the numbers need to look like a different number"
  apnaplates_prompt
  @mod_number = $stdin.gets.chomp

  @valuation = 0
  @weighting = 0

end

def registration_age()
  begin
    puts "\nWhat is the age of the plate?"
    puts "\n1: What year was it issued"
    puts "click here to check (http://www.apnaplates.com/aboutcrd/APNAPLATES-CAR-REGISTRATION-DATES)"
    @year_issued = $stdin.gets.chomp

    require "Date"
    this_year = Date.today.year
    @reg_age = this_year.to_i - @year_issued.to_i

    puts "Can you confirm the age of the plate is #{@reg_age} years old? (Yes or No)"

    confirmation = $stdin.gets.chomp
  end until confirmation =~ /(yes|y)/
end

def average_reg_price()

  @av_reg_price_start = 1749
end

# def modification_calc()
#     @spaces_value = 0
#
#     case @spaces
#     when "none"
#       @spaces_value = 2000
#     when 1
#       @spaces_value = 500
#     when 2
#       @spaces_value = -1000
#     else
#       @spaces_value = -2000
#     end
#     @valuation += @spaces_value
# end

def reg_more_or_less_char_calc() # value added if the plate is exact and minus if its more or less
  @more_or_less = 0
  if @more_or_less_characters =~ /(exact|e)/i
    @more_or_less = 10000
  elsif @more_or_less_characters =~ /(more|m)/i
    @more_or_less = -5000
  elsif @more_or_less_characters =~ /(less|l)/i
    @more_or_less = -3000
  else
    @more_or_less = 0
  end
end

def duplicates_calc()
  @dupe = 0
  if @duplicates =~ /(yes|y)/i
    @dupe = -5000
  elsif @duplicates =~ /(no|n)/i
    @dupe = 1000
  else
    puts "Error message at def duplicates_calc"
  end
end

def reg_weighting_calc() # every number plate is given a percentage weighting

    case @reg_match_weighting.to_i
    when 1
      @weighting = 0
    when 2
      @weighting = -0.3
    when 3
      @weighting = 0.1
    when 4
      @weighting = 0.4
    when 5
      @weighting = 0.6
    when 6
      @weighting = 0.8
    else
      puts "reg_weighting_calc error"
    end
    # weighting is added to the total at the end so not here
end

def registration_age_calc() # adds £100 to each year the number plate has been issued
    @age_value = @reg_age.to_i * 100
    @valuation +=  @age_value
    # if its dateless then a value is given in registration_type_calc
  end

def registration_characters_calc() # gives value to the length of the number plate
    case @total_characters.to_i
    when 7
      @av_reg_price = -700
    when 6
      @av_reg_price = -600
    when 5
      @av_reg_price = -500
    when 4
      @av_reg_price = 1000
    when 3
      @av_reg_price = 5000
    when 2
      @av_reg_price = 10000
    else
      puts "Test"
    end
    @av_reg_price_start += @av_reg_price
    @valuation += @av_reg_price_start
  end

def registration_digits_calc() # gives value if the number plate has only one digit
  # @only_one_digit = 0

  if @digits.to_i == 1
    @only_one_digit = 1000
  elsif @digits.to_i > 1
    @only_one_digit = 0
  else
    puts "error message in registration_digits"
  end
  @valuation += @only_one_digit
end

def registration_letters_calc() # gives value for less than 2 letters in a number plate_type

  @letter_count = 0

  if @letters.to_i == 1
    @letter_count = 15000
  elsif @letters.to_i == 2
    @letter_count = 10000
  elsif @letters.to_i == 3
    @letter_count = 5000
  elsif @letters.to_i > 3
    @letter_count = 0
  else
    puts "error message from registration_letters_calc"
  end
  @valuation += @letter_count
end

def registration_type_calc() # gives value depending on the number plate type eg dateless, suffix, prefix or current
    @plate_type_value = 0

    if @plate_type =~ /(dateless|d)/i
      @plate_type_value = 15000
    elsif @plate_type =~ /(suffix|s)/i
      @plate_type_value = 10000
    elsif @plate_type =~ /(prefix|p)/i
      @plate_type_value = 5000
    elsif @plate_type =~ /(current|c)/i
      @plate_type_value = 1000
    else
      puts "error message from registration_type_calc"
    end
    @valuation += @plate_type_value
  end

def registration_spaces_calc() # gives value if there are no spaces in the numberplate
  @spaces_value = 0

  if @spaces.downcase =~ /(none|n)/i
    @spaces_value = 2000
  elsif @spaces == 1
    @spaces_value = 500
  elsif @spaces == 2
    @spaces_value = -1000
  elsif @spaces.to_i < 2
    @spaces_value = -2000
  else
    puts "error message at registration_spaces_calc"
  end
  # print @spaces_value
  # print @valuations
  @valuations = @spaces_value + @valuations.to_i
end

def registration_modifications_calc()
    if @mod_letter.downcase =~ /(no|n)/i
      @mod_letter_value = 2500
    elsif @mod_letter.downcase =~ /(yes|y)/i
      @mod_letter_value = -1000
    else
        puts "Error in registration_modifications_calc - @mod_letter"
    end

    @valuations += @mod_letter_value

    if @mod_number.downcase =~ /(no|n)/i
      @mod_number_value = 2500
    elsif @mod_number.downcase =~ /(yes|y)/i
      @mod_number_value = -1000
    else
      puts "Error in registration_modifications_calc - @mod_number"
    end

    @valuations += @mod_number_value
  end

def reg_details_display()
  puts "At the moment the average registration price is #{@av_reg_price_start}"
  puts
  puts "Registration:                           #{@reg.upcase}"
  puts "Displayed as:                           #{@reg_display.upcase}"
  puts "Plate Match Weighting                   #{@reg_match_weighting} and #{@weighting * 100}% uplift or downlift"
  puts "Plate age in years                      #{@reg_age} and Age Value = #{@age_value}"
  puts "Total Characters:                       #{@total_characters} and Total Chars Value = #{@av_reg_price}"
  puts "Total Digits:                           #{@digits} and if only 1 digit value is #{@only_one_digit}"
  puts "Total Letters:                          #{@letters} and value is #{@letter_count}"
  puts "Plate Type:                             #{@plate_type.capitalize} and value is #{@plate_type_value}"
  puts "Spaces in Plate:                        #{@spaces} and value = #{@spaces_value}"
  puts "Letter Modification:                    #{@mod_letter.capitalize} and value is #{@mod_letter_value}"
  puts "Number Modifications:                   #{@mod_number.capitalize} and value is #{@mod_number_value}"
end

def results_breakdown()
puts
puts "Average Price:                        #{@av_reg_price_start}"
# puts "Weighting:                        #{@weighting}"
puts "The plate was issued in #{@year_issued} and is #{@reg_age} years old"
puts "Plate Age Value:                      #{@age_value}"
puts "Value if plate has only 1 digit:      #{@only_one_digit}"
puts "Value depending on letter amount:     #{@letter_count}"
puts "Plate Type Value:                     #{@plate_type_value}"
puts "Plate value depending on spaces:      #{@spaces_value}"
puts "Value depending on number mods:       #{@mod_number_value}"
puts "Value depending on letter mods:       #{@mod_letter_value}"
puts "Reg length compared to word length:   #{@more_or_less}"
puts "Duplicate Reg letters or numbers:     #{@dupe}"
@results_total = @av_reg_price_start + @age_value + @only_one_digit + @letter_count + @plate_type_value + @spaces_value + @mod_number_value + @mod_letter_value + @more_or_less + @dupe
puts
# puts "Total of the above:               #{@results_total}"
# puts "Weighting:                        #{@weighting * 100}"
# puts "with weighting:                   #{@results_total + (@weighting * @results_total)}"
# puts
# @valuation seems to be wrong somewhere so need to find that later
# the work around above does all the calculations here so this maybe a better way to do it
# puts "Valuation total:                  #{@valuation}"
# puts "Add the weighting:                #{@valuation + (@weighting * @valuation)}"
end

def registration_valuation_results()

  puts
  puts "This is an VALUATION for #{@reg.upcase}  displayed as #{@reg_display.upcase}"
  puts "The plate was issued in #{@year_issued} and is #{@reg_age} years old"
  puts
  puts "Our preliminary valuation:                  £#{@results_total}"
  @weight = (@weighting * 100)
  puts "The selected weighting is                    #{@weight}%"
  @final_valuation = @results_total + (@results_total.to_i * @weighting)
  puts "Total Valuation is:                         £#{@final_valuation}"
  puts
  puts "The APNAPLATES SELL IT FAST price would be: £#{@final_valuation * 0.5}"
  puts "The APNAPLATES minimum price would be:      £#{@final_valuation - (@final_valuation * 0.25)}"
  puts "The APNAPLATES average sell price would be: £#{@results_total + (@final_valuation - @results_total)}"
  puts "The APNAPLATES maximum price would be:      £#{@final_valuation + (@final_valuation * 0.25)}"

  # puts
  # puts "Our preliminary valuation is:                  £#{@valuation}"
  # @weight = (@weighting * 100)
  # puts "The selected weighting is                       #{@weight}%"
  # @final_valuation = @valuation + (@valuation * @weighting)
  # puts "Total Valuation is:                            £#{@final_valuation}"
  # puts
end

registration_questions
average_reg_price
# modification_calc
reg_more_or_less_char_calc
duplicates_calc
reg_weighting_calc
registration_age_calc
registration_characters_calc
registration_digits_calc
registration_letters_calc
registration_type_calc
registration_spaces_calc
registration_modifications_calc
# reg_details_display
results_breakdown
registration_valuation_results


# Does the registration have MORE OR LESS characters than the actual word that it represents? √
# Does the registration have duplicate letters eg for name RAVS is R4VVS or R4VSS? √
# Does the registration use two sequential numbers to represent another letter?
# Does the number in the reg look like the correct letter and in the corrct position eg 4 = A?
# compare the reg to the actual word it represents eg length & positions
# display the year / DONE!
# provide the user a link to my website to check? / DONE!
# maybe a hash for the above so the program can work it out etc!
# Popularity on Facebook & LinkedIn
# Is it a surname or firstname?
# testing and using GitHub
