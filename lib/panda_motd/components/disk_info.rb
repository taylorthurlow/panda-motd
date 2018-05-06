require 'ruby-units'

class DiskInfo
  def initialize(motd)
    @motd = motd
    @config = motd.config.component_config('disk_info')
  end

  def process
    @results = parse_disk_usage(@config['disks'])
  end

  def to_s
    result = "Disks:\n"
    @results.each do |disk|
      # handle disk not found
      if disk.is_a? String
        result += "#{disk}\n"
        next
      end

      size = Unit.new("#{disk[:size]} bytes").convert_to('gigabytes').round(1).to_s
      used = Unit.new("#{disk[:used]} bytes").convert_to('gigabytes').round(1).to_s
      avail = Unit.new("#{disk[:avail]} bytes").convert_to('gigabytes').round(1).to_s

      result += "  #{disk[:pretty_name]}: #{avail} free of #{size}\n"
    end

    return result
  end

  private

  def parse_disk_usage(disks)
    command_result = `BLOCKSIZE=1024 df`.split("\n")
    header = command_result[0].split
    entries = command_result[1..command_result.count]

    name_index = find_header_id_by_text(header, 'filesystem')
    size_index = find_header_id_by_text(header, 'blocks')
    used_index = find_header_id_by_text(header, 'used')
    avail_index = find_header_id_by_text(header, 'avail')

    results = disks.map do |disk, name|
      matching_entry = entries.find { |e| e.split[name_index] == disk }

      if matching_entry
        {
          pretty_name: name,
          disk_name: matching_entry.split[name_index],
          size: matching_entry.split[size_index].to_i * 1024,
          used: matching_entry.split[used_index].to_i * 1024,
          avail: matching_entry.split[avail_index].to_i * 1024
        }
      else
        "#{disk} was not found"
      end
    end

    return results
  end

  def find_header_id_by_text(header_array, text)
    return header_array.each_index.select { |i| header_array[i].downcase.include? text }.first
  end
end
