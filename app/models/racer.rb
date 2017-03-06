class Racer
  include ActiveModel::Model
  # convenience method for access to client in console
  def self.mongo_client
   Mongoid::Clients.default
  end

  # convenience method for access to zips collection
  def self.collection
   self.mongo_client['racers']
  end

  def self.all(prototype={}, sort={:number=>1}, skip=0, limit=nil)
  	result = self.collection
  		.find(prototype)
  		.sort(sort)
  		.skip(skip)
  	result=result.limit(limit) if !limit.nil?
  	return result
  end

end
