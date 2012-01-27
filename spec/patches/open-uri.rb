class DummyIO
  def read
    'alert("downloaded");'
  end
end

module OpenURI
  module OpenRead
    def open(*rest, &block)
      if host == 'www.example.com'
        yield DummyIO.new if block_given?
      end
    end
  end
end