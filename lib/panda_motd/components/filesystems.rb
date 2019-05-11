require "ruby-units"
require "colorize"

class Filesystems < Component
  def initialize(motd)
    super(motd, "filesystems")
  end

  def process
    @results = parse_filesystem_usage(@config["filesystems"])
  end

  def to_s
    name_col_size = @results.select { |r| r.is_a? Hash }
                            .map { |r| r[:pretty_name].length }
                            .max || 0

    size_w_padding = (name_col_size + 6) > 13 ? (name_col_size + 6) : 13

    result = "Filesystems".ljust(size_w_padding, " ")
    result += "Size  Used  Free  Use%\n"

    @results.each do |filesystem|
      result += format_filesystem(filesystem, size_w_padding)
    end

    result
  end

  private

  def format_filesystem(filesystem, size)
    return "  #{filesystem}\n" if filesystem.is_a? String # handle fs not found

    # filesystem name
    result = ""
    result += "  #{filesystem[:pretty_name]}".ljust(size, " ")

    # statistics (size, used, free, use%)
    [:size, :used, :avail].each do |metric|
      result += format_metric(filesystem, metric)
    end
    percent_used = calc_percent_used(filesystem)
    result += format_percent_used(percent_used)
    result += "\n"

    # visual bar representation of use%
    result += generate_usage_bar(filesystem, size, percent_used)

    result
  end

  def generate_usage_bar(filesystem, size, percent_used)
    result = ""
    total_ticks = size + 18
    used_ticks = (total_ticks * (percent_used.to_f / 100)).round
    result += "  [#{("=" * used_ticks).send(pct_color(percent_used))}" \
              "#{("=" * (total_ticks - used_ticks)).light_black}]"
    result += "\n" unless filesystem == @results.last
    result
  end

  def pct_color(percentage)
    case percentage
    when 0..75 then :green
    when 76..95 then :yellow
    when 96..100 then :red
    else :white
    end
  end

  def calc_percent_used(filesystem)
    ((filesystem[:used].to_f / filesystem[:size].to_f) * 100).round
  end

  def format_percent_used(percent_used)
    (percent_used.to_s.rjust(3, " ") + "%").send(pct_color(percent_used))
  end

  def calc_metric(value)
    Unit.new("#{value} bytes").convert_to(calc_units(value))
  end

  def format_metric(filesystem, metric)
    # we have 4 characters of space to include the number, a potential
    # decimal point, and the unit character at the end. if the whole number
    # component is 3+ digits long then we omit the decimal point and just
    # display the whole number component. if the whole number component is
    # 2 digits long, we can't afford to use a decimal point, so we still
    # only display the whole number component. if the whole number
    # component is 1 digit long, we use the single whole number component
    # digit, a decimal point, a single fractional digit, and the unit
    # character.

    value = calc_metric(filesystem[metric])
    whole_number_length = value.scalar.floor.to_s.length
    round_amount = whole_number_length > 1 ? 0 : 1
    formatted = value.scalar.round(round_amount).to_s + value.units[0].upcase
    formatted.rjust(4, " ") + "  "
  end

  def calc_units(value)
    if value > 10 ** 12
      "terabytes"
    elsif value > 10 ** 9
      "gigabytes"
    elsif value > 10 ** 6
      "megabytes"
    elsif value > 10 ** 3
      "kilobytes"
    else
      "bytes"
    end
  end

  def parse_filesystem_usage(filesystems)
    entries = `BLOCKSIZE=1024 df --output=source,size,used,avail`.lines.drop(1)

    filesystems.map do |filesystem, pretty_name|
      matching_entry = entries.map(&:split).find { |e| e.first == filesystem }
      next "#{filesystem} was not found" unless matching_entry

      filesystem_name, size, used, avail = matching_entry
      {
        pretty_name: pretty_name,
        filesystem_name: filesystem_name,
        size: size.to_i * 1024,
        used: used.to_i * 1024,
        avail: avail.to_i * 1024,
      }
    end
  end
end
