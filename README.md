Go to circleci and start a new account. You can sign up with your email or use an existing github account. Follow the steps to connect your github or bitbucket account. I used github.

Once you are signed in Click projects in the menu on the left. You should see a list of repos.

TO DO

Create a Django application
attach it to a postgresql db
create 2 models:
  Movies
  Formats
  
create a page to view the data:
  route
  view
  template

create some tests
  Write a couple unit tests for the model
  write a couple integration tests to determine a route returns the correct html.

Install a linter:
  hopefully this is pretty straight forward and won't require a ton of configuration
  pylint --load-plugins pylint_django --django-settings-module=my_media.settings

Create a `.circleci/config.yml`. For now just add `version: 2.1`

Create a git repo and push the code. 

In circleci, connect to the project.

From here we can build the yml through trial and error.
It will need to:
  lint - run the linter and pass
  test - install postgres, run migrations, run tests
  build a docker image - so probably need to create a dockerfile?
  push the image to docker hub - never done this.
