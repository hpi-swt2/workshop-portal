# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#


# Create Superuser
admin = User.find_or_initialize_by(
    name: "admin",
    email: "info@domain.com",
    role: :admin
)
admin.password = "system"
admin.save!

