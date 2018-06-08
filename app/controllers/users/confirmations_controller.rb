class Users
  class ConfirmationsController < Devise::ConfirmationsController
    private

    def after_confirmation_path_for(*)
      root_path
    end
  end
end
