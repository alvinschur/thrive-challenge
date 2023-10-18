# frozen_string_literal: true

require 'fileutils'

def default_output_filename
  'output.txt'
end

def data_path_to(folder:, file: '')
  File.join(__dir__, '..', 'data', folder, file)
end

def run_in_data_folder(folder:)
  Dir.chdir(data_path_to(folder:)) do
    if block_given?
      FileUtils.remove_file(default_output_filename, true)
      yield
    end
  end
end
