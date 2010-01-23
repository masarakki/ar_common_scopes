# ArCommonScopes
class ActiveRecord::Base
  named_scope :all, {}
  named_scope :limit, lambda{|limit| {:limit => limit}}
  named_scope :offset, lambda{|offset| {:offset => offset}}
  named_scope :page, lambda{|page, size| {:limit => size, :offset => page * size}}
  
  named_scope :newer, :order => 'created_at DESC'
  named_scope :older, :order => 'created_at'
  named_scope :fresh, lambda{{:conditions => ['created_at > ?', DateTime.now - 1]}}
  
  def fresh?
    created_at > DateTime.now - 1
  end
  
  named_scope :forall, lambda{|key, comp, value, others|
    others ||= {}
    case comp
    when :eq
      h = ["MAX(ABS(#{key} - ?)) = 0", value]
    when :neq
      h = ["MIN(ABS(#{key} - ?)) != 0", value]
    when :lt
      h = ["MAX(#{key}) < ?", value] 
    when :lte
      h = ["MAX(#{key}) <= ?", value]
    when :gt
      h = ["MIN(#{key}) > ?", value]
    when :gte
      h = ["MIN(#{key}) >= ?", value]
    end
    others.merge({:having => h})}
end
