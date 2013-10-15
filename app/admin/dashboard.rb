ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    
    columns do
    
      column do
        panel "Info" do
          span "Welcome to ActiveAdmin."
        end
      end
    
      column do

        panel "5 Most Recent Visas" do
          if PassportVisa.all.empty?
            span "No passports were found."
          else
            ul do
              PassportVisa.order("created_at desc").limit(5).all.each do |visa|
                li link_to("#{Country.find(visa.country_id).name} - #{visa.citizenship} - #{visa.visa_type}", admin_visa_path(visa))
              end
            end
            div do
              link_to "See All (#{PassportVisa.count})", admin_visa_path('')
            end
          end
        end

      end
    
    end
  end # content
end
