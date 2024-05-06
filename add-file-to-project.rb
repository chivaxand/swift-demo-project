#!/usr/bin/env ruby

require 'xcodeproj'
require 'find'

def main()
  # Search for .xcodeproj files
  xcodeproj_files = find_xcodeproj_files('.')
  xcodeproj_files.each_with_index do |project_path, index|
    puts "#{index + 1}. #{project_path}"
  end

  # Ask user to select a project
  print "Select a project (enter the number): "
  selected_index = gets.chomp.to_i - 1
  if selected_index < 0 || selected_index >= xcodeproj_files.size
    puts "Invalid selection!"
    exit
  end
  selected_project_path = xcodeproj_files[selected_index]

  # List all targets of the selected project
  targets = list_targets(selected_project_path)
  puts "\nTargets:"
  targets.each_with_index do |target, index|
    puts "#{index + 1}. #{target}"
  end

  # Ask user to select a target
  print "\nSelect a target to add file (enter the number): "
  selected_target_index = gets.chomp.to_i - 1
  if selected_target_index < 0 || selected_target_index >= targets.size
    puts "Invalid selection!"
    exit
  end
  selected_target_name = targets[selected_target_index]

  # Add file to selected target
  add_swift_file_to_target(selected_project_path, selected_target_name)
end


def find_xcodeproj_files(dir)
  xcodeproj_files = []
  Find.find(dir) do |path|
    if path =~ /.*\.xcodeproj$/
      xcodeproj_files << path
      Find.prune
    end
  end
  xcodeproj_files
end


def list_targets(project_path)
  project = Xcodeproj::Project.open(project_path)
  project.targets.map(&:name)
end


def add_swift_file_to_target(project_path, target_name)
  # File content
  swift_content = <<~EOF
    import Foundation

    func helloWorld() {
        print("Hello, World!")
    }
  EOF

  # Create file
  file_name = 'HelloWorld.swift'
  File.write(file_name, swift_content)

  # Find target by name
  project = Xcodeproj::Project.open(project_path)
  target = project.targets.find { |t| t.name == target_name }
  if target.nil?
    puts "Target not found!"
    return
  end

  file_ref = project.new_file(file_name)
  target.add_file_references([file_ref])
  project.save

  puts "File added to project"
end


main()