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
# Collects documents for list
########################################################################
def collect_documents()
  categories = @opts.dig(:settings, @opts[:element], 'categories')
  query = if categories
    categories.map! {|e| (e.class == String and BSON::ObjectId.legal?(e)) ? BSON::ObjectId.from_string(e) : e }
    DcNews.where(:categories.in => categories, active: true)
  else
    DcNews.where(active: true)
  end
  query = query.only(:id, :created_at, :subject, :created_by_name, :link)
# paging 
  if @opts.dig(:settings, @opts[:element], 'paging') == '1'
    per_page = @opts.dig(:settings, @opts[:element], 'docs_per_page') || 15
    query.order_by(created_at: -1).page(@parent.params[:page]).per(per_page)
  else
    query = query.and({"$or" => [{valid_from: nil}, {:valid_from.gt => Time.now.beginning_of_day}]})

    limit = @opts.dig(:settings, @opts[:element], 'docs_per_view') || 5
    query.order_by(created_at: -1).limit(limit)
  end
end

########################################################################
# Show one news document
########################################################################
def show(link)
  document = DcNews.find_by(link: link)
  return t('dc_news.entry_not_found') if document.nil?
  
  replies = DcReply.where(doc_id: document.id, active: true).order(created_at: 1)
  partial = @opts.dig(:settings, @opts[:element], 'show') || 'dc_news/show'
  @parent.render partial: partial, 
                 locals: { document: document, replies: replies, opts: @opts }
end

########################################################################
# List news
########################################################################
def list
  partial   = @opts.dig(:settings, @opts[:element], 'view') || 'dc_news/list'
  documents = collect_documents.to_a
  @parent.render(partial: partial, formats: [:html], locals: { documents: documents, opts: @opts } )
end

########################################################################
# List last 3 news in footer.
########################################################################
def last_news
  limit = @opts[:limit] || 3
  entries = DcNews.only(:created_by_name, :link, :subject, :created_at)
                  .where(active: true) 
                  .order_by(created_at: -1).limit(limit).to_a

  entries.inject('') do |result, element|
    result << @parent.link_to("/news/#{element.link}") do 
      %Q[<div>
    <span class="date">#{@parent.dc_pretty_date(element.created_at)} : </span>
    <span class="title">#{element.subject}</span>
      </div>].html_safe
    end
  end
end

########################################################################
# Default method will dispatch to proper method.
########################################################################
def default
# if last part of url is page link show list otherwise it is document link 
  document_link = @opts[:path].last
  if document_link == @parent.page.subject_link or document_link == @parent.site.homepage_link
    list
  else
    show(document_link)
  end
end

end
