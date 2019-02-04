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
#
########################################################################
class DcForumRenderer < DcRenderer
include DcApplicationHelper

  
########################################################################
# 
########################################################################
#def pretty_date(time)
#  case
#  when time < 11.months.ago then I18n.localize(time.to_date, format: :long)
#  when time < 6.days.ago    then I18n.localize(time.to_date, format: :short)
#  when time < 14.hours.ago  then I18n.localize(time, format: :short)
#  else                           time.strftime('%H:%M')
#  end
#end

########################################################################
# Topic method lists topic and its replays.
# 
# Same as code above but with usage of view partial.
########################################################################
def topic
  forum = DcForum.find(@parent.params[:forum])
  topic = DcForumTopic.find(@parent.params[:topic])
  replies = DcReply.where(doc_id: topic.id, active: true).order(created_at: 1)
                   .page(@parent.params[:page]).per(15)
  @parent.render partial: 'dc_forum/topic', formats: [:html], 
                 locals: { forum: forum, topic: topic, replies: replies, opts: @opts  }
end

########################################################################
# Topic method lists topic and its replays.
# 
# Same as code above but with usage of view partial.
########################################################################
def topics
  forum  = DcForum.find(@parent.params[:forum])
  topics = DcForumTopic.only(:id, :created_by_name, :updated_by_name, :subject, :created_at, :updated_at, :replies)
           .where(dc_forum_id: forum._id, active: true).order(updated_at: -1)
           .page(@parent.params[:page]).per(10)
  @parent.render partial: 'dc_forum/topics', formats: [:html], locals: { forum: forum, topics: topics, opts: @opts  }
end

########################################################################
# Default method will list all available forums
########################################################################
def default
  return topic  if @parent.params[:topic]
  return topics if @parent.params[:forum]
#  
  forums = DcForum.where(:site_id.in => [nil, dc_get_site._id], active: true).order(order: 1).each
  @parent.render partial: 'dc_forum/forums', formats: [:html], locals: { forums: forums, opts: @opts }
end

end
