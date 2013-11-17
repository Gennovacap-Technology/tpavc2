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
  
end
