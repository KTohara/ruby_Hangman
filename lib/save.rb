# frozen_string_literal: true

require 'yaml'

# Save/load game serialization methods
module Save
  def save_game(game)
    save_data = YAML.dump(game)
    save_name = prompt_save_name
    File.open("./save_states/#{save_name}.yaml", 'w') { |file| file.write(save_data) }
    puts warning('file_saved', save_name)
    exit
  end

  def prompt_save_name
    begin
      puts prompt('save_name')
      file_name = gets.chomp
      return random_file_name if file_name.downcase == 'r'
      raise warning('save_name_exists') if File.exist?("./save_states/#{file_name}.yaml")
    rescue StandardError => e
      puts e
      input = gets.chomp.downcase
      until %w[y n].include?(input)
        puts e
        input = gets.chomp.downcase
      end
    end
    input == 'y' ? file_name : nil
  end

  def random_file_name
    word_list = File.open('./word_list.txt', 'r')
    word_list = File.read(word_list)
                    .split(' ')
                    .select { |word| word.length.between?(4, 10) }

    (1..3).inject([]) { |acc| acc << word_list.sample }.join('_')
  end

  def load_game
    save_file = choose_save_game
    save_data = File.read("./save_states/#{save_file}")
    file = YAML.load(save_data)
    File.delete("./save_states/#{save_file}") if File.exists?("./save_states/#{save_file}")
    file
  end

  def choose_save_game
    files = Dir.children('./save_states')
    save_files = files.inject([]) { |acc, file| acc << file }
    puts "\nChoose a save file to load.\n\n"
    puts save_files.map.with_index { |file_name, i| "[#{i + 1}] #{file_name.slice(0..-6)}"}
    input = gets.chomp.to_i - 1
    while save_files[input].nil?
      puts "\nChoose a save file to load.\n\n"
      input = gets.chomp.to_i - 1
    end
    save_files[input]
  end
end
