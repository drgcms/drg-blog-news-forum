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
# Collection name: dc_reply : Replies
#
#  _id                  BSON::ObjectId       _id
#  created_at           Time                 Created at
#  updated_at           Time                 updated_at
#  subject              String               Subject, short description of reply
#  body                 String               Body text of reply
#  active               Mongoid::Boolean     Reply is active
#  doc_id               BSON::ObjectId       Replied document id
#  doc_class            String               Document origin class
#  created_by           BSON::ObjectId       Created by
#  created_by_name      String               Reply author's name
########################################################################
class DcReply
  include Mongoid::Document
  include Mongoid::Timestamps

  field :subject,     type: String,  default: ''
  field :body,        type: String,  default: ''
  field :active,      type: Boolean, default: true
  field :doc_id,      type: BSON::ObjectId
  field :doc_class,   type: String

  field :created_by,      type: BSON::ObjectId
  field :created_by_name, type: String
  
  index( { doc_id: 1 } )

  validates_length_of :subject,           minimum: 5  
  validates_length_of :body,              minimum: 5
  validates_length_of :created_by_name,   minimum: 5
end
