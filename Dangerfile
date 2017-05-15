#!/usr/bin/env ruby

has_modified_source = git.modified_files.any? { |f| f.start_with? "Pickle/Classes" }

# Warn when there is a big PR
warn "Big PR" if git.lines_of_code > 500

# Ensure there is a summary for a PR
fail "Please provide a summary in the Pull Request description" if github.pr_body.length < 10

# Add a CHANGELOG entry for changes
if git.lines_of_code > 50 && has_modified_source && !git.modified_files.include?("CHANGELOG.md")
  fail "Please update [CHANGELOG.md](https://github.com/carousell/pickle/blob/master/CHANGELOG.md).", sticky: true
end

# Ensure a clean commits history
if git.commits.any? { |c| c.message =~ /^Merge branch/ }
  fail "Please rebase to get rid of the merge commits in this PR", sticky: true
end

# Run swiftlint
%x(echo "reporter: json" >> Example/.swiftlint.yml)

pwd = Dir.pwd + "/"
linter_json = %x(cd Example && #{pwd}Example/Pods/SwiftLint/swiftlint && cd --)
results = JSON.parse linter_json

%x(git checkout Example/.swiftlint.yml)

results.each do |violation|
  file = violation["file"].gsub(pwd, "")
  next unless git.modified_files.include? file

  line = violation["line"]
  reason = violation["reason"]
  comment = "#{github.html_link("#{file}#L#{line}")} has linter issue: #{reason}."
  warn comment, file: file, line: line, sticky: true
end
