ActionController::Routing::Routes.draw do |map|
  map.namespace(:admin) do |admin|
     admin.resources :searches
  end



  map.namespace(:admin) do |admin|
    admin.resources :statuses
    admin.resources :tweets
    admin.resources :direct_messages
    admin.resources :stories
    
    map.resources :admin, :only => [:index, :destroy] 
  end

  map.resources :tweets, :only  => [:new, :create, :edit, :update, :show] 

  map.root :controller => 'tweets', :action => 'new'
end
