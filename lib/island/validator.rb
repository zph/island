require 'open3'

module Island
  module Validator
    def self.call(filename)
      out, status = Open3.capture2e("ruby #{filename}")
      code = status.exitstatus
      if code != 0
        exit_message(out, code)
      end
    end

    def self.exit_message(out, code)
        msg = "Ooops, revise your formula and try again.\n"
        msg += "Error:\n #{out}"
        puts msg
        exit(code)
    end
  end
end
