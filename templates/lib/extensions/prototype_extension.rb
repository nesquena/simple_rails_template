class ActionView::Helpers::PrototypeHelper::JavaScriptGenerator
  module GeneratorMethods

    # "document.fire('form:update', #{options.to_json})"
    #fire_event "form:update", {:html => dsafasd, :type => :fun}
    def fire_event(event_name, options={})
      call "document.fire", event_name, options
    end
  end
end
