Visa::Application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  root :to => 'home#index'
  ActiveAdmin.routes(self)

  # Passport routes
 # match 'passport' => 'passport#index', :as => :passport
  match 'passport/newadultpassport' => 'passport#newadultpassport', :as => :newadultpassport
  match 'passport/newminorpassport' => 'passport#newminorpassport', :as => :newminorpassport
  match 'passport/renewpassport' => 'passport#renewpassport', :as => :renewpassport
  match 'passport/send_renew' => 'passport#send_renew', :as => :send_renew
  match 'passport/send_label' => 'passport#send_label', :as => :send_label
  match 'passport/secondpassport' => 'passport#secondpassport', :as => :secondpassport
  match 'passport/lostpassport' => 'passport#lostpassport', :as => :lostpassport
  match 'passport/namepassport' => 'passport#namepassport', :as => :namepassport
  match 'passport/addpagespassport' => 'passport#addpagespassport', :as => :addpagespassport
  match 'passport/download' => 'passport#downloadpassports', :as => :downloadpassports

  # Visa passport
  match 'visa' => 'visa#index', :as => :visas
  match 'visa/:country/:state/:citizenship' => 'visa#visa', :as => :visa
  match 'visa/download' => 'visa#downloadvisas', :as => :downloadvisas

  # Home routes
  match 'passportandvisasolutions' => 'home#passportandvisasolutions', :as => :passportandvisasolutions
  match 'globalentryprogram' => 'home#globalentryprogram', :as => :globalentryprogram
  # match 'downloadvisas' => 'home#downloadvisas', :as => :downloadvisas
  # match 'downloadpassports' => 'home#downloadpassports', :as => :downloadpassports
  match 'contact' => 'home#contact', :as => :contact
  match 'send_contact' => 'home#send_contact', :as => :send_contact
  match 'faqs' => 'home#faqs', :as => :faqs

  # Download Packages
  match 'download_package/:id/:document' => 'home#download_package', :as => :download_package

  # Download One PDF
  match 'download_pdf/:id' => 'home#download_pdf', :as => :download_pdf

  # Search
  match 'search' => 'home#search', :as => :search

  #301 Redirects from the old site

  match "aboutus.html" => redirect("/")
  match "aboutus" => redirect("/")
  match "add-passport-pages.html" => redirect("/passport/addpagespassport")
  match "add-passport-pages" => redirect("/passport/addpagespassport")
  match "bangladesh" => redirect("/")
  match "brazil.html" => redirect("/")
  match "brazil" => redirect("/")
  match "call.html" => redirect("/contact")
  match "call" => redirect("/contact")
  match "cambodia.html" => redirect("/")
  match "cambodia" => redirect("/")
  match "cameroon.html" => redirect("/")
  match "cameroon" => redirect("/")
  match "child-passport.html" => redirect("/passport/newminorpassport")
  match "child-passport" => redirect("/passport/newminorpassport")
  match "china.html" => redirect("/")
  match "china" => redirect("/")
  match "contact.html" => redirect("/contact")
  match "contact" => redirect("/")
  match "egypt" => redirect("/")
  match "faq.html" => redirect("/faqs")
  match "faq" => redirect("/faqs")
  match "india.html" => redirect("/")
  match "india" => redirect("/")
  match "indonesia" => redirect("/")
  match "israel" => redirect("/")
  match "japan" => redirect("/")
  match "kenya.html" => redirect("/")
  match "kenya" => redirect("/")
  match "korea.html" => redirect("/")
  match "korea" => redirect("/")
  match "lost-stolen-passport.html" => redirect("/passport/lostpassport")
  match "lost-stolen-passport" => redirect("/passport/lostpassport")
  match "malaysia.html" => redirect("/")
  match "malaysia" => redirect("/")
  match "new-adult-passport.html" => redirect("/passport/newadultpassport")
  match "new-adult-passport" => redirect("/passport/newadultpassport")
  match "nigeria.html" => redirect("/")
  match "nigeria" => redirect("/")
  match "passport-name-change.html" => redirect("/passport/namepassport")
  match "passport-name-change" => redirect("/passport/namepassport")
  match "passport-renewal.html" => redirect("/passport/renewpassport")
  match "passport-renewal" => redirect("/passport/renewpassport")
  match "passport.html" => redirect("/passport/download")
  match "passport" => redirect("/passport/download")
  match "philippines" => redirect("/")
  match "privacy.html" => redirect("/")
  match "privacy" => redirect("/")
  match "refund" => redirect("/")
  match "russia.html" => redirect("/")
  match "russia" => redirect("/")
  match "saudiarabia.html" => redirect("/")
  match "saudiarabia/" => redirect("/")
  match "second-passport.html" => redirect("/passport/secondpassport")
  match "second-passport" => redirect("/passport/secondpassport")
  match "sitemap.html" => redirect("/")
  match "solutions" => redirect("/passportandvisasolutions")
  match "tanzania.html" => redirect("/")
  match "tanzania" => redirect("/")
  match "thailand" => redirect("/")
  match "turkey" => redirect("/")
  match "vietnam" => redirect("/")
  match "visa" => redirect("/visa")

  #Redirect ("non-www" to "wwww")
  constraints(:host => "thepassportandvisacompany.com") do
    match "(*x)" => redirect { |params, request|
      URI.parse(request.url).tap { |x| x.host = "www.thepassportandvisacompany.com" }.to_s
    }
  end
  
end
