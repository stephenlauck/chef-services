module Test
  module Helper
    
    def get_supermarket_attribute(attr)
      @supermarket ||= begin
        supermarket_file = File.read("/tmp/supermarket.json")
        JSON.parse(supermarket_file)
      end
      @supermarket[attr]
    end

  end
end

Chef::Recipe.send(:include, Test::Helper)
Chef::Resource.send(:include, Test::Helper)