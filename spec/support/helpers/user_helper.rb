module UserHelper
  def generate_reset_password_token(user)
    raw, enc = Devise.token_generator.generate(User, :reset_password_token)
    user.update(
      reset_password_token: enc,
      reset_password_sent_at: Time.now.utc
    )

    raw
  end
end
