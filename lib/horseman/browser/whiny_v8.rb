module V8
  class Access
    def get(obj, name, &dontintercept)
      puts "V8 get: #{obj.class.name} - #{name}"
      methods = accessible_methods(obj)
      if methods.include?(name)
        method = obj.method(name)
        method.arity == 0 ? method.call : method.unbind
      elsif obj.respond_to?(:[])
        obj.send(:[], name, &dontintercept)
      else
        yield
      end
    end

    def iget(obj, index, &dontintercept)
      puts "V8 iget: #{obj.class.name} - #{name}"
      if obj.respond_to?(:[])
        obj.send(:[], index, &dontintercept)
      else
        yield
      end
    end

    def query(obj, name, attributes)
      puts "V8 query: #{obj.class.name} - #{name}"
      if obj.respond_to?(name)
        attributes.dont_delete
        unless obj.respond_to?(name + "=")
          attributes.read_only
        end
      else
        yield
      end
    end

    def iquery(obj, index, attributes)
      puts "V8 iquery: #{obj.class.name} - #{name}"
      if obj.respond_to?(:[])
        attributes.dont_delete
        unless obj.respond_to?(:[]=)
          attributes.read_only
        end
      else
        yield
      end
    end

    def names(obj)
      puts "V8 names: #{obj.class.name}"
      accessible_methods(obj)
    end

    def indices(obj)
      puts "V8 indices: #{obj.class.name}"
      obj.respond_to?(:length) ? (0..obj.length).to_a : yield
    end

  end
end
