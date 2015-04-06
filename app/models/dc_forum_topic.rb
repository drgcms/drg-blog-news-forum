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

class DcForumTopic
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :subject,     type: String,  default: ''
  field :body,        type: String,  default: ''
  field :replies,     type: Integer, default: 0
  field :views,       type: Integer, default: 0

  belongs_to  :dc_forum
  embeds_many :dc_replies, as: :replies
 
  field :active,      type: Boolean, default: true 
  field :created_by,  type: BSON::ObjectId
  field :updated_by,  type: BSON::ObjectId
  field :created_by_name, type: String
  field :updated_by_name, type: String
  
  
  index( { dc_forum_id: 1 } )
  
  validates_length_of :subject, minimum: 4  
  validates_length_of :body,    minimum: 10
end
