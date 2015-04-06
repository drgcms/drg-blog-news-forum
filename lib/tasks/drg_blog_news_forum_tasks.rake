# desc "Explaining what the task does"
# task :drg_blog_news_forum do
#   # Task goes here
# end

########################################################################
# quick update to names in fourm
#########################################################################
namespace :drg_blog_news_forum do
  desc 'Update name in forums'
  task :update_name => :environment do
  DcForum.all.each do |forum|
    if forum.created_by
      user = DcUser.find(forum.created_by)
      forum.created_by_name = user.name
    end
    if forum.updated_by
      user = DcUser.find(forum.updated_by)
      forum.updated_by_name = user.name
    end
    forum.save
  end
  DcForumTopic.all.each do |topic|
    if topic.created_by
      user = DcUser.find(topic.created_by)
      topic.created_by_name = user.name
    end
    if topic.updated_by
      user = DcUser.find(topic.updated_by)
      topic.updated_by_name = user.name
    end
    topic.save
    topic.dc_replies.each do |reply | 
      if reply.created_by
        user = DcUser.find(reply.created_by)
        reply.created_by_name = user.name
        reply.save
      end
    end
  end
  
  end
  
end