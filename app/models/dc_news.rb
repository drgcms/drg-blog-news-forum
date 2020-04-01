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

########################################################################
# == Schema information
#
# Collection name: dc_news : News
#
#  _id                  BSON::ObjectId       _id
#  created_at           Time                 Time of creation
#  updated_at           Time                 updated_at
#  subject              String               Subject of the news
#  body                 String               Body
#  active               Mongoid::Boolean     Active
#  link                 String               Link to blog entry
#  valid_from           Date                 valid_from
#  valid_to             Date                 valid_to
#  categories           Array                categories
#  created_by           BSON::ObjectId       ID of the creator
#  created_by_name      String               Name of the creator
#  dc_replies           Embedded:DcReply     dc_replies
########################################################################
class DcNews
  include Mongoid::Document
  include Mongoid::Timestamps

  field :subject,     type: String,  default: ''
  field :body,        type: String,  default: ''
  field :active,      type: Boolean, default: true
  field :link,        type: String
  field :replies,     type: Integer, default: 0  
  
  field :valid_from,  type: Date
  field :valid_to,    type: Date
  field :categories,  type: Array
  
  # SEO
  include DcSeoConcern

  field :created_by,  type: BSON::ObjectId
  field :created_by_name, type: String

  embeds_many :dc_replies, as: :replies

  validates_length_of :subject, minimum: 4  
  validates_length_of :body,    minimum: 10
  
  before_save :do_before_save  
  
########################################################################
# Update link when left blank.
########################################################################
def do_before_save
  if self.link.blank?
    self.link = UnicodeUtils.downcase(DcPage.clear_link(self.subject)) + Time.now.strftime('-%Y-%m-%d')
  end
  if self.created_by_name.nil?
    self.created_by_name = DcUser.find(self.created_by).name
  end
end

end
