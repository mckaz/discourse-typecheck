module RDL::Globals
  # Map from table names (symbols) to their schema types, which should be a Table type
  @ar_db_schema = {}
end

class << RDL::Globals
  attr_accessor :ar_db_schema
end


def add_assoc(hash, aname, aklass)
  kl_type = RDL::Type::SingletonType.new(aklass)
  if hash[aname]
    hash[aname] = RDL::Type::UnionType.new(hash[aname], kl_type)
  else
    hash[aname] = kl_type unless hash[aname]
  end
  hash
end

puts "Building schema model for Discourse..."

Rails.application.eager_load! # load Rails app
MODELS = ActiveRecord::Base.descendants.each { |m|
  begin
    ## load schema for each Rails model
    m.send(:load_schema) unless m.abstract_class? 
  rescue
  end }

MODELS.each { |model|
  next if model.to_s == "ApplicationRecord"
  next if model.to_s == "GroupManager"
  RDL.nowrap model
  s1 = {}
  model.columns_hash.each { |k, v| t_name = v.type.to_s.camelize
    ## Map SQL column types to the corresponding RDL type
    if t_name == "Boolean"
      t_name = "%bool"
      s1[k] = RDL::Globals.types[:bool]
    elsif t_name == "Datetime"
      t_name = "DateTime or Time"
      s1[k] = RDL::Type::UnionType.new(RDL::Type::NominalType.new(Time), RDL::Type::NominalType.new(DateTime))
    elsif t_name == "Text"
      ## difference between `text` and `string` is in the SQL types they're mapped to, not in Ruby types
      t_name = "String"
      s1[k] = RDL::Globals.types[:string]
    else
      s1[k] = RDL::Type::NominalType.new(t_name)
    end
    RDL.type model, (k+"=").to_sym, "(#{t_name}) -> #{t_name}", wrap: false ## create method type for column setter
    RDL.type model, (k).to_sym, "() -> #{t_name}", wrap: false ## create method type for column getter
  }
  s2 = s1.transform_keys { |k| k.to_sym }
  assoc = {}
  model.reflect_on_all_associations.each { |a|
    ## Generate method types based on associations
    add_assoc(assoc, a.macro, a.name)
    if a.name.to_s.pluralize == a.name.to_s ## plural association
      RDL.type model, a.name, "() -> ActiveRecord_Relation<#{a.name.to_s.camelize.singularize}>", wrap: false ## This actually returns an Associations CollectionProxy, which is a descendant of ActiveRecord_Relation (see below actual type). This makes no difference in practice.
      #ActiveRecord_Associations_CollectionProxy<#{a.name.to_s.camelize.singularize}>'
    else
      ## association is singular, we just return an instance of associated class
      RDL.type model, a.name, "() -> #{a.name.to_s.camelize.singularize}", wrap: false
    end
  }
  s2[:__associations] = RDL::Type::FiniteHashType.new(assoc, nil)
  base_name = model.to_s
  base_type = RDL::Type::NominalType.new(model.to_s)
  hash_type = RDL::Type::FiniteHashType.new(s2, nil)
  schema = RDL::Type::GenericType.new(base_type, hash_type)
  RDL::Globals.ar_db_schema[base_name.to_sym] = schema
}

class GrantedBy
  RDL::Globals.ar_db_schema[:GrantedBy] = RDL::Globals.parser.scan_str "#T GrantedBy<{dummy: Integer}>"
end


## uncomment the below to print out schema
=begin
RDL::Globals.db_schema.each { |k, v|
  puts "#{k} has the following schema:"
  v.params[0].elts.each { |k1, v1|
    puts "     #{k1} => #{v1}"
  }
}
=end

