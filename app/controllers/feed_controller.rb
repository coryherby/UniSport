class FeedController < ApplicationController
  # No authentification needed to go on feed
  skip_before_action :authenticate_user!, :only => [:index, :get_user_info]

  helper_method :resource_name, :resource, :devise_mapping

  def index

    if user_signed_in?
      @new_event_link = "#"
      @dropdown_partial = "shared/logged_in_dropdown"
      @has_phone_number = User.find_by(id: current_user.id).telephone_number.nil?
    else
      @new_event_link = "users/sign_in"
      @dropdown_partial = "shared/login_dropdown"
      @has_phone_number = false
    end

  end

  def get_user_info
    ## TODO: Add profile pic, description message and favourite sports

    if user_signed_in?
      get_user_info_query =
      "SELECT users.first_name,
              users.last_name,
              users.description,
              users.image_file_name,
              university_mails.university_name
       FROM users JOIN university_mails ON users.email ILIKE ('%@' || university_mails.mail_extension)
       WHERE users.id = #{current_user.id};"

      @user_info = ActiveRecord::Base.connection.execute(get_user_info_query)

      respond_to do |format|
        format.json { render json: @profile_info }
      end

    else
      get_user_info_query =
      "SELECT '' AS university_name
       FROM users;"

       @user_info = ActiveRecord::Base.connection.execute(get_user_info_query)

      respond_to do |format|
        format.json { render json: @profile_info }
      end

    end

  end

  # Helper methods
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
