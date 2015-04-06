$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "drg_blog_news_forum/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "drg_blog_news_forum"
  s.version     = DrgBlogNewsForum::VERSION
  s.authors     = ["Damjan Rems"]
  s.email       = ["damjan.rems@gmail.com"]
  s.homepage    = "http://www.drgcms.org"
  s.summary     = "DRG CMS: Blog, news and forum plugin for DRG CMS"
  s.description = "DRG CMS: drg_blog_news_forum plugin implements basic funcionality for enabling blog, news or forum."
  s.license     = "MIT-LICENSE"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails" #, '~> 0'
  s.add_dependency "drg_cms" #, '~> 0'
end
