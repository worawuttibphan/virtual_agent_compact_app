
directories %w(app lib test).select{|d|
  Dir.exist?(d) ? d : UI.warning("Directory #{d} does not exist")
}

guard :minitest do
  watch('lib/server.rb')                 { |m| "test/test_server.rb" }
  watch(%r{^test/(.*)\/?(.*)_test\.rb$})
  watch(%r{^test/lib/(.*)\/?(.*)_test\.rb$})
  watch(%r{^test/app/(.*)\/?(.*)_test\.rb$})
  watch(%r{^lib/(.*/)?([^/]+)\.rb$})     { |m| "test/lib/#{m[1]}#{m[2]}_test.rb" }
  watch(%r{^app/(.*/)?([^/]+)\.rb$})     { |m| "test/app/#{m[1]}#{m[2]}_test.rb" }
  watch(%r{^test/test_helper\.rb$})      { 'test' }
  watch(%r{^test/test_web_helper\.rb$})  { |m| "test/test_server.rb" }
end
