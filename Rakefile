desc "run the testfiles"
task :spec do
  Dir.glob("spec/**/*_spec.rb") do |file|
    system ("rspec #{file}")
  end
end

desc "run the main file"
task :zimki do
  system("ruby lib/zimki.rb")
end

task :default => :spec
