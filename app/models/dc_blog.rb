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
# Collection name: dc_blog : Blogs
#
#  _id                  BSON::ObjectId       _id
#  created_at           Time                 Time of creation
#  updated_at           Time                 updated_at
#  subject              String               Subject of the blog
#  body                 String               Body
#  active               Mongoid::Boolean     Active
#  link                 String               Link to blog entry
#  created_by           BSON::ObjectId       ID of the creator
#  created_by_name      String               Name of the creator
#  dc_replies           Embedded:DcReply     dc_replies
#########################################################################
module DcBlogConcern
extend ActiveSupport::Concern
included do
  
  include Mongoid::Document
  include Mongoid::Timestamps

  field :subject,     type: String,  default: ''
  field :body,        type: String,  default: ''
  field :active,      type: Boolean, default: true
  field :link,        type: String

  field :created_by,  type: BSON::ObjectId
  field :created_by_name, type: String
  
  # SEO
  include DcSeoConcern

  embeds_many :dc_replies, as: :replies
  
  index({created_by_name: 1, link: 1})

  validates_length_of :subject, minimum: 4  
  validates_length_of :body,    minimum: 10
  
  before_save :do_before_save
  
########################################################################
# Update link if if field is left blank.
########################################################################
def do_before_save
  if self.link.size < 5
    self.link = UnicodeUtils.downcase(DcPage.clear_link(self.subject)) + Time.now.strftime('-%Y-%m-%d')
  end
  if self.created_by_name.nil?
    self.created_by_name = DcUser.find(self.created_by).name
  end
end
  
########################################################################
# Method returns all users having bloger system role.   
########################################################################
def blogers
  blogers_role = DcRole.only(:id).find_by(sytem_name: 'bloger')
  return [] unless blogers_role
#
  DcUser.where('dc_user_roles.dc_policy_role_id' => blogers_role.id).order_by(name: 1)
end
  
end
end

########################################################################
# Mongoid::Document model for dc_blogs documents.
# 
# dc_blog class is used for creating simple blog site.
########################################################################
class DcBlog
  include DcBlogConcern  
end