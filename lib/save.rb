module Save
  def save_game(game)
    save_data = YAML.dump(game)
    debugger
    puts Dir.pwd
    File.open('/save_states/save.yaml', 'w') do |file|
      file.write(save_data)
    end
    puts 'saving'
    exit
  end
end