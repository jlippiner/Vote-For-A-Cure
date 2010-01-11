ActionController::Routing::Routes.draw do |map|

  map.namespace(:admin) do |admin|
    admin.resources :statuses
    admin.resources :tweets
  end

  map.resources :tweets, :only  => [:new, :create, :edit, :update, :show] 

  map.root :controller => 'tweets', :action => 'new'
end
