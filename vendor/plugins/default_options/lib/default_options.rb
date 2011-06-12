module ActionView
  module Helpers
    class Instance
      DEFAULT_FIELD_OPTIONS = { "size" => 13 }

      def to_input_field_tag(field_type, options = {})
        options = options.stringify_keys
        options["size"] = options["maxlength"] || DEFAULT_FIELD_OPTIONS["size"] unless options.key?("size")
        options = DEFAULT_FIELD_OPTIONS.merge(options)
        if field_type == "hidden"
          options.delete("size")
        end
        options["type"] ||= field_type
        options["value"] = options.fetch("value"){ value_before_type_cast(object) } unless field_type == "file"
        options["value"] &&= ERB::Util.html_escape(options["value"])
        add_default_name_and_id(options)
        tag("input", options)
      end
    end
  end
end 
