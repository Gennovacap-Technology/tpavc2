Setup the App
=============

To setup the app and put everything to work, follow the steps bellow.



App installation
----------------

-   Clone the repo and `cd `into it

-   You first need to run `bundle install`

-   Then run `sudo cp config/database.original.yml config/database.yml`

-   This will create the database.yml so you can setup your db configuration.
    (the database.yml is ignored by the repo).

-   Then you just need to run `rake db:create `and `rake db:migrate:all`



Deployment to Heroku 
---------------------


-	Create a blank folder named tpavc
-	git init
-	git add .
-	git commit -m " "
-	git clone git@heroku.com:tpavc.git
-	git remote add [remote name] git@heroku.com:tpavc.git
-	git remote -v
-	git fetch [remote name]
-	git push [remote name] master	
-	heroku run rake
-	heroku restart
-	heroku open



Default stuff...
----------------

Here's the /admin login credentials by default:

**User: admin@example.com**

**Password: password**


SEO Sitemap
-----------

To generate the Sitemap, you must to edit the `config/sitemap.rb` file. Here's the documentation link for instructions:

-	[Documentation][1]

[1]: <http://rubydoc.info/gems/sitemap/0.3.3/frames>

Every time you edit the sitemap.rb file, you must to generate the sitemap again and ping the search engines!!!!



Problems?
---------

Take a look at the links bellow, it maybe, can be an assets problems or
something is missing from the installation.

-   [Twitter Bootstrap Gem][1]

-   [Active Admin Gem][2]

[1]: <https://github.com/seyhunak/twitter-bootstrap-rails>

[2]: <http://activeadmin.info/documentation.html>
