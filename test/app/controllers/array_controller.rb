class ArrayController < PostsController
  resource_name :post

  permit_params label_ids: Array
end
