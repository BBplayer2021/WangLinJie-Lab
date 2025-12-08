#!/bin/bash
set -e

# 安装兼容的 Bundler 版本
gem install bundler -v 2.4.22

# 安装依赖
bundle install

# 构建 Jekyll 网站
bundle exec jekyll build

