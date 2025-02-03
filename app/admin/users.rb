ActiveAdmin.register User do

  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :username, :email, :password_digest, :status
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :username, :email, :password_digest, :status]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
