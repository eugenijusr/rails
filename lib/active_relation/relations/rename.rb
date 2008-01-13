module ActiveRelation
  module Relations
    class Rename < Compound
      attr_reader :relation, :schmattribute, :alias
  
      def initialize(relation, renames)
        @schmattribute, @alias = renames.shift
        @relation = renames.empty?? relation : Rename.new(relation, renames)
      end
  
      def ==(other)
        relation == other.relation and schmattribute == other.schmattribute and self.alias == other.alias
      end
  
      def attributes
        relation.attributes.collect { |a| substitute(a) }
      end
  
      def qualify
        Rename.new(relation.qualify, schmattribute.qualify => self.alias)
      end
  
      protected
      def attribute(name)
        case
        when name == self.alias then schmattribute.alias(self.alias)
        when relation[name] == schmattribute then nil
        else relation[name]
        end
      end
  
      private
      def substitute(a)
        a == schmattribute ? a.alias(self.alias) : a
      end
    end
  end
end