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
class DcNewsRenderer < DcRenderer
include DcApplicationHelper

########################################################################
# Show one news entry
########################################################################
def show_entry
  entry = DcNews.find_by(link: @parent.params[:link])
  return t('dc_news.entry_not_found') if entry.nil?
  
  replies = entry.dc_replies.where(active: true).order(created_at: 1).
            page(@parent.params[:page]).per(10)          
  @parent.render partial: 'dc_news/entry', formats: [:html], 
                 locals: { entry: entry, replies: replies, opts: @opts }
end

########################################################################
# List all news
########################################################################
def list_all
  entries = DcNews.only(:created_by_name, :link, :subject, :created_at)
                  .where(active: true).order_by(created_at: -1)
                  .page(@parent.params[:page]).per(10)
  @parent.render partial: 'dc_news/entries', formats: [:html], locals: { entries: entries } 
end

########################################################################
# List last news on home page. But no more than 3 entries and not older than 2 months.
########################################################################
def last_news
  limit = @opts[:limit] || 3
  entries = DcNews.only(:created_by_name, :link, :subject, :created_at)
                  .where(active: true, :created_at.gt => 2.months.ago)
                  .order_by(created_at: -1).limit(limit).to_a
  if entries.size > 0
# for document link.    
    path = @opts[:path] || 'news'
    @parent.render partial: 'dc_news/last_news', formats: [:html], locals: { entries: entries, path: path } 
  else
    ''
  end
end

########################################################################
# Default method will dispatch to proper method.
########################################################################
def default
  if @parent.params[:link].nil?
    list_all
  else
    show_entry
  end
end

end
