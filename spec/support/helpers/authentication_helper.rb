module AuthenticationHelper
  RSpec.shared_context 'authenticate user' do
    # Creates a new valid user session
    before(:each) do
      @current_user = User.first
      sign_in(@current_user)
    end
  end
end
