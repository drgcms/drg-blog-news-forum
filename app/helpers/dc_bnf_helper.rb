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

module DcBnfHelper
#include DcApplicationHelper  

########################################################################
# 
########################################################################
def dc_pretty_date(time)
  case
  when time < 11.months.ago then I18n.localize(time.to_date, format: :long)
  when time < 6.days.ago    then I18n.localize(time.to_date, format: :short)
  when time < 14.hours.ago  then I18n.localize(time, format: :short)
  else                           time.strftime('%H:%M')
  end
end

########################################################################
# Link for editing news settings
########################################################################
def news_settings(opts)
  return '' unless opts[:edit_mode] > 1
# settings can be saved in dc_site or dc_page document 
  table = opts[:table] || @page.class.to_s
  id    = (table == 'dc_site') ? @site.id : @page.id
%Q[<div>  
  #{dc_link_for_edit(table: 'dc_memory', title: 'helpers.news.settings', 
                             form_name: 'news_settings', icon: 'cog lg',
                             id: id, location: table, action: 'new',
                             element: opts[:element] )}
  #{dc_link_for_create(table: 'dc_news', title: 'helpers.news.create')}
</div>].html_safe
end

end
