# frozen_string_literal: true

# Save/load game serialization methods
module Save
  def save_game(game)
    save_data = YAML.dump(game)
    save_name = prompt_save_name
    return if save_name.nil?

    File.open("./save_states/#{save_name}.yaml", 'w') { |file| file.write(save_data) }
    puts warning('file_saved', save_name)
    exit
  end

  def prompt_save_name
    conditional = [proc { |file_name| file_name.match?(/^[a-zA-Z]{1}[a-zA-Z0-9\-_]*$/) }]
    input = input_loop(prompt('save_name'), warning('invalid'), conditional)
    save_name_choices(input)
  end

  def save_name_choices(input)
    if input.downcase == 'r'
      random_file_name
    elsif input == 'return'
      nil
    elsif File.exist?("./save_states/#{input}.yaml")
      prompt_overwrite(input)
    else
      input
    end
  end

  def prompt_overwrite(file_name)
    conditional = [proc { |choice| %w[y n].include?(choice) }]
    input = input_loop(prompt('overwrite?'), warning('invalid'), conditional)
    input == 'y' ? file_name : prompt_save_name
  end

  def random_file_name
    word_list = File.open('./word_list.txt', 'r')
    word_list = File.read(word_list)
                    .split(' ')
                    .select { |word| word.length.between?(4, 10) }

    (1..3).inject([]) { |acc| acc << word_list.sample }.join('_')
  end

  def load_game
    save_file = prompt_load_game
    save_data = File.read("./save_states/#{save_file}")
    file = YAML.safe_load(save_data)
    File.delete("./save_states/#{save_file}")
    file
  end

  def prompt_load_game
    files = Dir.children('./save_states')
    file_index = files.map.with_index { |file_name, i| "#{[i + 1].to_s.blue} #{file_name.chomp('yaml')}" }
    conditional = [proc { |num| (0...files.length).include?(num.to_i) }]
    input = input_loop(prompt_load_message(file_index), warning('invalid'), conditional)
    files[input]
  end
end
