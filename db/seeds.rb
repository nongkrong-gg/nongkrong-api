User.create(
  role: :admin,
  email: ENV.fetch('ADMIN_EMAIL'),
  username: ENV.fetch('ADMIN_USERNAME'),
  password: ENV.fetch('ADMIN_PASSWORD'),
  password_confirmation: ENV.fetch('ADMIN_PASSWORD')
)
