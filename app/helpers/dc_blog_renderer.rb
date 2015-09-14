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
class DcBlogRenderer < DcRenderer
include DcApplicationHelper

########################################################################
# Show one blog entry
########################################################################
def show_entry
#  blog = @parent.params[:blog_id] ? DcBlog.find(@parent.params[:blog_id]) : DcBlog.last
  entry = DcBlog.find_by(created_by_name: @parent.params[:name], link: @parent.params[:link])
  return t('dc_blog.entry_not_found') if entry.nil?
  
  replies = entry.dc_replies.where(active: true).order(created_at: 1).
            page(@parent.params[:page]).per(20)
  @parent.render partial: 'dc_blog/entry', formats: [:html], 
                 locals: { entry: entry, replies: replies, opts: @opts }
end

########################################################################
# List all blogs from one bloger
########################################################################
def list_all
  entries = DcBlog.only(:created_by_name, :link, :subject, :created_at)
                  .where(created_by_name: @parent.params[:name]).order_by(created_at: -1)
                  .page(@parent.params[:page]).per(10)
  @parent.render partial: 'dc_blog/entries', formats: [:html], locals: { entries: entries } 
end

########################################################################
# List all blogers
########################################################################
def list_blogers
  blogers = DcBlog.all.distinct(:created_by_name)
  @parent.render partial: 'dc_blog/blogers', formats: [:html], locals: { blogers: blogers } 
end

########################################################################
# Default method will dispatch to proper method.
########################################################################
def default
  if @parent.params[:name].nil?
    list_blogers
  elsif @parent.params[:link].nil? or @parent.params[:link] == 'all'
    list_all
  else
    show_entry
  end
end

end
