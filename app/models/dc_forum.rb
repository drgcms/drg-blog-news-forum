#--
# Copyright (c) 2014+ Damjan Rems
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++

#########################################################################
# == Schema information
#
# Collection name: dc_forum : Forums
#
#  _id                  BSON::ObjectId       _id
#  created_at           Time                 created_at
#  updated_at           Time                 updated_at
#  name                 String               Forum name (short description)
#  link                 String               Forum link
#  description          String               Long description of what is forum about
#  order                Integer              Order
#  topics               Integer              No of topics
#  replies              Integer              replies
#  forum_groups         Array                forum_groups
#  active               Boolean              Is active
#  created_by           BSON::ObjectId       created_by
#  updated_by           BSON::ObjectId       updated_by
#  dc_policy_rules      Embedded:DcPolicyRule dc_policy_rules
#########################################################################
class DcForum
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name,        type: String,  default: ''
  field :link,        type: String
  field :description, type: String,  default: ''
  field :order,       type: Integer, default: 10
  field :topics,      type: Integer, default: 0
  field :replies,     type: Integer, default: 0
  field :forum_groups,type: Array
  
  field :active,      type: Boolean, default: true 
  field :created_by,  type: BSON::ObjectId
  field :updated_by,  type: BSON::ObjectId
  field :updated_by_name, type: String  
  
  embeds_many :dc_policy_rules, as: :policy_rules
  
  index( { link: 1 } )
  
  validates_length_of :name, minimum: 4    
  
  before_save :do_before_save  
  
########################################################################
# Update link when left blank.
########################################################################
def do_before_save
  if self.link.size < 5
    self.link = self.name.strip.downcase.gsub(' ','-')
  end
end  


end
