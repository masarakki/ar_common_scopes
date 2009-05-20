# ArCommonScopes
class ActiveRecord::Base
    named_scope :all, :all
    named_scope :limit, lambda{|limit| {:limit => limit}}
    named_scope :page, lambda{|page, size| {:limit => size, :offset => page * size}}
    
    named_scope :newer, :order => 'created_at DESC'
    named_scope :fresh, :conditions => ['created_at > ?', DateTime.now - 1]
    
    def fresh?
      created_at > DateTime.now - 1
    end
end