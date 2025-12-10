source "https://rubygems.org"

# --- 核心修改部分 ---

# 1. 移除对 jekyll 版本的直接引用
# gem "jekyll", "~> 4.4.1" 

# 2. 启用官方 github-pages gem
# 这个 gem 包含了 GitHub Pages 允许的所有插件和 jekyll 版本
gem "github-pages", group: :jekyll_plugins

# --- 您的主题和插件设置 ---

# 3. 移除 academic-pages gem (主题应该在 _config.yml 中通过 remote_theme 引用)
# gem "academic-pages", "~> 2.5" 

# 4. 保留您的其他插件（注意：只有白名单插件才生效）
group :jekyll_plugins do
  gem "jekyll-feed", "~> 0.12"
  # jekyll-remote-theme 已包含在 github-pages gem 中，无需单独声明
  # jekyll-seo-tag 是 GitHub Pages 官方白名单插件，不用在 Gemfile 中列出
end

# Windows and JRuby does not include zoneinfo files, so bundle the tzinfo-data gem
# and associated library.
platforms :mingw, :x64_mingw, :mswin, :jruby do
  gem "tzinfo", ">= 1", "< 3"
  gem "tzinfo-data"
end

# Performance-booster for watching directories on Windows
gem "wdm", "~> 0.1", :platforms => [:mingw, :x64_mingw, :mswin]

# Lock `http_parser.rb` gem to `v0.6.x` on JRuby builds since newer versions of the gem
# do not have a Java counterpart.
gem "http_parser.rb", "~> 0.6.0", :platforms => [:jruby]
