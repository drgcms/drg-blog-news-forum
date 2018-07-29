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
def show(link)
  entry = DcBlog.find_by(link: link)
  return t('dc_blog.entry_not_found') if entry.nil?
  
  replies = DcReply.where(doc_id: entry.id, active: true).order(created_at: 1)
  @parent.render partial: 'dc_blog/show', formats: [:html], 
                 locals: { document: entry, replies: replies, opts: @opts }
end

########################################################################
# List all blogs from one bloger
########################################################################
def list
  documents = DcBlog.only(:created_by_name, :link, :subject, :created_at)
                  .where(active: true).order_by(created_at: -1)
                  .page(@parent.params[:page]).per(10)
  @parent.render partial: 'dc_blog/list', formats: [:html], locals: { documents: documents } 
end

########################################################################
# List all blogers
########################################################################
def list_blogers
  blogers = DcBlog.all.distinct(:created_by_name)
  @parent.render partial: 'dc_blog/blogers', formats: [:html], locals: { blogers: blogers } 
end

########################################################################
# List last blogs on home page. But no more than 3 entries and not older than 2 months.
########################################################################
def last_blogs
  limit = @opts[:limit] || 3
  entries = DcBlog.only(:created_by_name, :link, :subject, :created_at)
                  .where(active: true) 
                  .order_by(created_at: -1).limit(limit).to_a

  entries.inject('') do |result, document|
    result << @parent.link_to("/blog/#{document.link}") do 
      %Q[
    <span class="date">#{@parent.dc_pretty_date(document.created_at)} : </span>
    <span class="title">#{document.subject}</span><br><br> 
      ].html_safe
    end
  end

end


########################################################################
# Default method will dispatch to proper method.
########################################################################
def default
  document_link = @opts[:path].last
  if document_link == 'blogers'
    list_blogers
  elsif document_link == @parent.page.subject_link or document_link == @parent.site.homepage_link
    list
  else
    show(document_link)
  end
end

end
