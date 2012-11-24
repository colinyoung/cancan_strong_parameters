class TitleController < PostsController
  resource_name :post
  
  permit_params :title  
end