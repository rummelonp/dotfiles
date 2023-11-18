IRB.conf[:USE_AUTOCOMPLETE] = false
IRB.conf[:PROMPT_MODE] = :SIMPLE

lib = File.expand_path('./lib')
$LOAD_PATH.unshift lib if File.exist?(lib) && !$LOAD_PATH.include?(lib)
