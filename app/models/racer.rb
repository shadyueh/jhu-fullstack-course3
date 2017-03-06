class Racer
  include ActiveModel::Model

  attr_accessor :id, :number, :first_name, :last_name, :gender, :group, :secs

  def initialize(params={})
	@id=params[:_id].nil? ? params[:id] : params[:_id].to_s
	@number=params[:number].to_i
	@first_name=params[:first_name]
	@last_name=params[:last_name]
	@gender=params[:gender]
	@group=params[:group]
	@secs=params[:secs].to_i
  end

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

  def self.find id
    Rails.logger.debug {"getting racer #{id}"}
    _id = (id.is_a? String) ? BSON::ObjectId.from_string(id) : id
    result=self.collection.find(:_id=>_id).first
	return result.nil? ? nil : Racer.new(result)
  end

  def save 
    result=self.class.collection
              .insert_one(_id:@id, number:@number,
               first_name:@first_name,  last_name:@last_name,
                gender:@gender, group:@group, secs:@secs)
    @id=result.inserted_id
  end

end
