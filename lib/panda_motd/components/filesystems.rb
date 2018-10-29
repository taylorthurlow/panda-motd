require 'ruby-units'
require 'colorize'

class Filesystems < Component
  def initialize(motd)
    @name = 'filesystems'
    @motd = motd
    @config = motd.config.component_config(@name)
    @errors = []
  end

  def process
    @results = parse_filesystem_usage(@config['filesystems'])
  end

  def to_s
    name_col_size = @results.select { |r| r.is_a? Hash }.map { |r| r[:pretty_name].length }.max
    name_col_size = 0 if name_col_size.nil?

    name_col_size_with_padding = (name_col_size + 6) > 13 ? (name_col_size + 6) : 13

    result = 'Filesystems'.ljust(name_col_size_with_padding, ' ')
    result += "Size  Used  Free  Use%\n"

    @results.each do |filesystem|
      # handle filesystem not found
      if filesystem.is_a? String
        result += "  #{filesystem}\n"
        next
      end

      result += "  #{filesystem[:pretty_name]}".ljust(name_col_size_with_padding, ' ')

      [:size, :used, :avail].each do |metric|
        units = if filesystem[metric] > 10**12
                  'terabytes'
                elsif filesystem[metric] > 10**9
                  'gigabytes'
                elsif filesystem[metric] > 10**6
                  'megabytes'
                elsif filesystem[metric] > 10**3
                  'kilobytes'
                else
                  'bytes'
                end

        value = Unit.new("#{filesystem[metric]} bytes").convert_to(units)

        # we have 4 characters of space to include the number, a potential decimal point, and
        # the unit character at the end. if the whole number component is 3+ digits long then
        # we omit the decimal point and just display the whole number component. if the whole
        # number component is 2 digits long, we can't afford to use a decimal point, so we still
        # only display the whole number component. if the whole number component is 1 digit long,
        # we use the single whole number component digit, a decimal point, a single fractional
        # digit, and the unit character.
        whole_number_length = value.scalar.floor.to_s.length
        round_amount = whole_number_length > 1 ? 0 : 1
        formatted_value = value.scalar.round(round_amount).to_s + units[0].upcase
        result += formatted_value.rjust(4, ' ') + '  '
      end

      percentage_used = ((filesystem[:used].to_f / filesystem[:size].to_f) * 100).round
      result += (percentage_used.to_s.rjust(3, ' ') + '%').send(percentage_color(percentage_used))

      result += "\n"

      total_ticks = name_col_size_with_padding + 18
      used_ticks = (total_ticks * (percentage_used.to_f / 100)).round

      result += "  [#{('=' * used_ticks).send(percentage_color(percentage_used))}#{('=' * (total_ticks - used_ticks)).light_black}]"
      result += "\n" unless filesystem == @results.last
    end

    return result
  end

  private

  def percentage_color(percentage)
    case percentage
    when 0..75 then :green
    when 76..95 then :yellow
    when 96..100 then :red
    else :white
    end
  end

  def parse_filesystem_usage(filesystems)
    entries = `BLOCKSIZE=1024 df --output=source,size,used,avail`.lines
                                                                 .drop(1)

    filesystems.map do |filesystem, pretty_name|
      matching_entry = entries.map(&:split).find { |e| e.first == filesystem }
      next "#{filesystem} was not found" unless matching_entry

      filesystem_name, size, used, avail = matching_entry
      {
        pretty_name: pretty_name,
        filesystem_name: filesystem_name,
        size: size.to_i * 1024,
        used: used.to_i * 1024,
        avail: avail.to_i * 1024
      }
    end
  end
end
