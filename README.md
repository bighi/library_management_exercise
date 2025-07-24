# Decision log and thought process

I used Devise instead of using the built-in authentication system in Rails
because Devise provides good sign-up and login pages, which saved me some time.

Pundit is a good choice for authorization because it allows for
fine-grained control over user permissions. Also makes it easy for us to
go and look at the policies to see what each user can do.

Available copies of a book: Initially I created an available_copies column in
the books table, but later I realized that keeping it updated could be a problem.
So I decided to create a method that calculates the number of available copies
on the fly.