# SFLS201602专用贴吧
本项目仅为开发环境。
## 1. 开发技术
### 后端技术
* [Ruby 2.3.1](https://ruby-doc.org/core-2.3.1/)编程语言
* [Rails 5.0.3](http://api.rubyonrails.org/)  MVC框架
* [SQLite3](https://sqlite.org/docs.html) 数据库 （开发和测试环境下）
* [PostgreSQL](https://www.postgresql.org/docs/) 数据库（部署环境下）
### 前端技术
* [Foundation 6.0](http://foundation.zurb.com/sites/docs/) CSS/JavaScript框架
* [Font Awesome 4.7.0](http://fontawesome.io/icons/) 图标
* [TinyMCE](https://www.tinymce.com/) 富文本编辑插件
### Ruby Gems
* [Devise](https://github.com/plataformatec/devise) 用户注册和验证
* [PaperClip](https://github.com/thoughtbot/paperclip) 图像上传
* [Kaminari](https://github.com/kaminari/kaminari) 分页规则

## 2. 项目安装方法（仅开发人员）
### 安装 Ruby 和 Rails 框架
* Windows 安装方法：
一般不推荐使用Windows进行Rails开发（或任何开发at all...）但是也并非不可以。
Windows的安装规则较为复杂，请按照[此推荐教程](https://medium.com/ruby-on-rails-web-application-development/how-to-install-rubyonrails-on-windows-7-8-10-complete-tutorial-2017-fc95720ee059)或[此教程](https://gorails.com/setup/windows/10)进行Windows上的安装。
另外也可以安装Linux虚拟机或Linux双系统，有[此教程](http://www.seas.upenn.edu/~cis196/VM/#windows)。
* MacOS 安装方法：安装homebrew，terminal输入
```
>> brew install ruby
>> gem install rails
>> bundle install
```
* Linux 安装方法：
参考[此教程](https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-16-04)或[此教程](http://railsapps.github.io/installrubyonrails-ubuntu.html)安装。
### 下载项目并解压至某目录下
在命令行（terminal）中导航至文件夹：
```
# 若项目文件夹解压后路径为home/user/tieba
>> cd home/user/tieba
# 注意：Windows的命令行操作与Unix系（MacOS和Linux）不同。
```
### Rails命令
```
>> rake db:migrate
>> rake db:seed
>> rails s
```
## 3. Rails框架入门指南
Ruby on Rails 是一个成熟、开发者生态良好的[MVC框架](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller)。虽然国内使用Rails进行开发的公司并不多，但Rails在国际上应用非常主流，有功能强大，扩展性强，代码易懂等优势。
### 主要的目录
* /app/models目录
Models规定了项目中的对象、对象间关系和可用扩展。比如，本项目中有3个Model，分别为post（贴文）:
```ruby
# Post.rb （贴文）
class Post < ApplicationRecord
    acts_as_votable  # => 可以调用acts_as_votable扩展
    belongs_to :user # => 表示贴文post总是属于某个user
    has_many :replies, dependent: :destroy # => 表示贴文post可以拥有许多回复replies，且当贴文被删除时，其附属的回复也一同被删除。
    paginates_per 6 #=> 可以调用Kaminari Gem的paginates扩展
end
```
以及user（用户）和reply（回复），具体文档请直接参考相关代码，不一一赘述了。
* /app/controllers目录、/app/views目录 和/config/routes.rb文件
这三个东西互相关联，要一起讲。在前面有了对象以后，就要规定对象的展现方式，这一过程中Controller规定展现方法（提供什么？），View规定展现形式（提供的东西长什么样子），Routes规定展现规则（是Get、Post、Patch、Delete里的哪一种？）。好比一台汽车，Controller是发动机和控制设备，View是汽车的样子、Routes规定汽车的出厂渠道。以post（贴文）对象为例：
```ruby
# posts_controller.rb
class PostsController < ApplicationController
    def index # => 对应routes.rb加载的RESTful路径中的GET
        # detailed implementation
    end
    def indexbypost
         # detailed implementation
    end
    ...
    def upvote
        # detailed implementation
    end
    ...
    def destroy # => 对应routes.rb加载的RESTful路径中的DELETE
        # detailed implementation
    end
end
```
而在Routes.rb中有以下代码：
```ruby
   resources :posts do # =>resources :model_name 加载 model 默认的7个RESTful路径
       ...
       member do
         put "like", to "posts#upvote" # => 规定"like_path"对应posts_controller中的upvote方法，且为PUT
         ...
       end
   end
   get '/by-post' => 'posts#indexbypost', :as => 'indexbypost' # => 规定'indexbypost_path'对应posts_controller中的indexbypost方法，且为GET（且规定app中的url后缀为／bypost，但这不重要）
```
于是，在views目录下可以看到posts/index.html.erb, posts/indexbypost.html.erb因为它们有对应的GET路径，必须有对应的html页面进行展示。
* /assets目录
包含所有的样式、JS、图片、字体等前端资源。
* /db/migrate目录
/db/migrate目录下是Model对应的关系型数据库的存储格式。比如post（贴文）Model在此目录下规定有title:string、 content:string、 user:reference、jing:boolean、sticky:boolean等列。
### 其他重要的文件
* Gemfile：规定项目所使用的Ruby Gem扩展插件。
* /db/seed.rb: 在程序初始化时可执行 "rake db:seed" 对数据库进行内容上的populate。
