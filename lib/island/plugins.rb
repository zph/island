module Island

  module Plugins
    SHABANG        = ->(line){ !!line[/^#!\//] }
    NEW_SHABANG    = "#!/usr/bin/env ruby\n"
    ADD_SHABANG    = ->(c){ c.insert(0, NEW_SHABANG) }
    ADD_GENERATED_CODE_DISCLAIMER = ->(c) do
      txt =<<-EOF.gsub(/^\s*/, '')
      #########################################################
      ##  Generated Code: do not submit patches.
      ##  Submit patches against non-generated version of code.
      #########################################################
      EOF
      c.insert(1, txt)
    end

    MODIFICATIONS = [ADD_SHABANG, ADD_GENERATED_CODE_DISCLAIMER]
    REJECTIONS    = [SHABANG]
  end

end
