# Decision log and thought process

I used Devise instead of using the built-in authentication system in Rails
because Devise provides good sign-up and login pages, which saved me some time.

Pundit is a good choice for authorization because it allows for
fine-grained control over user permissions. Also makes it easy for us to
go and look at the policies to see what each user can do.

