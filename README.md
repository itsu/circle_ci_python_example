Go to circleci and start a new account. You can sign up with your email or use an existing github account. Follow the steps to connect your github or bitbucket account. I used github.

Once you are signed in Click projects in the menu on the left. You should see a list of repos. 

Select Setup Project. 
Circleci uses a config.yml file to know what to do. You can create this file in the repo yourself, or you can have circleci create a template file for you by selecting the option Commit a starter CI pipeline to a new branch. I decided to go this route. After clicking setup project you'll be taken to a dashboard. 

Above your pipleline you should see three drop down menus. The first lets you select pipelines by owner. This is useful if you are working on a team and you want to give permissions for certain pipelines to certian teams. Very helpful if you are looking to get developers to own their own builds. In a new account there will only be two options, everyone, and your user. The drop down lets you select a specific pipeline and the last one lets you select which branch you'd like to see builds for. Select your project from the drop down menu. If the branch drop down is set to all branches you should see an execution of your pipeline.

Now select `circleci-project-setup` from the drop down. This is the branch that Circleci made when we set up our project and told it to create the config.yml for us.

From here we have a couple of options. You could pull down the branch circleci created and start to edit the file locally, or you can click Edit Config in the top right which opens up an editor in your browser. This is nice becuase circle ci has a linter built in that will let you know if any of hte code you write is invalid. Either way, you should see a template file that looks something like this:

```yml
# Use the latest 2.1 version of CircleCI pipeline process engine.
# See: https://circleci.com/docs/2.0/configuration-reference
version: 2.1

# Define a job to be invoked later in a workflow.
# See: https://circleci.com/docs/2.0/configuration-reference/#jobs
jobs:
  say-hello:
    # Specify the execution environment. You can specify an image from Dockerhub or use one of our Convenience Images from CircleCI's Developer Hub.
    # See: https://circleci.com/docs/2.0/configuration-reference/#docker-machine-macos-windows-executor
    docker:
      - image: cimg/base:stable
    # Add steps to the job
    # See: https://circleci.com/docs/2.0/configuration-reference/#steps
    steps:
      - checkout
      - run:
          name: "Say hello"
          command: "echo Hello, World!"

# Invoke jobs via workflows
# See: https://circleci.com/docs/2.0/configuration-reference/#workflows
workflows:
  say-hello-workflow:
    jobs:
      - say-hello
```
We can start by thinking of the file as containing three seperate pieces. First is the Version of cirlceci we want to use. After that we have job definitions. Jobs are templates for tasks we want to perform. We can define as many jobs as we want and each job can have several steps. It's important to know that jobs do not run on their own. Simply defining a job does nto mean it will run.

Workflows are where we tell circle ci which jobs to run and in what order. We can define several workflows that run under different circumstances. For example, we can have a workflow that runs whenever someone pushes a new branch to our repo. I may run some tests, run our linter, and build our app. Then we might have another workflow that fires whenever there is a merge to master. In this case we may want to do all the same steps again, but add a step where we push the built image to a repositior like AWS ECR or Dockerhub. 

Lets start by creating a job called `build_and_test`.

```yml
version: 2.1

jobs:
  build-and-test:
    docker:
      - image: cimg/python:3.10.1
    steps:
      - checkout
      - run:
          name: install dependancies
          command: pip install -r requirements.txt
      - run:
          name: run tests
          command: python manage.py test

workflows:
  build-and-test-workflow:
    jobs:
      - build-and-test
```

After we name our job we need to specify an enviorment for it run in. In this case, we'll use a docker image. We can pull docker images from dockerhub, or, in this case, we can use [images provided by circleci](https://circleci.com/docs/2.0/circleci-images/). These are images that circleci maintains and that "include tools especially useful for CI/CD". You can search for available images [here](https://circleci.com/developer/images).

Next we define our steps. the `checkout` step tells circleci to to checkout the repo code into the steps working directory. After that we can install the dependancies using pip and then run our tests. Lastly, we need to create a workflow and tell it to run the job we just created.

If you're updating the code locally you'll need to push every time you make a change. Another reason why making edits in the circleci browser editor is super conveient

If you're in the editor you can just click `Save and Run` in the top right corner. This will trigger a 

At the bottom, under the lllll tab you can click on `build-and-test` or go to your dashboard and click on the currently running build. You'll be able to see all the steps for the running build. Oh no! Looks like our build failed when trying to run our tests. If we take a look at the error it looks like Django is having trouble connecting to postgres. 

No worries, we can set up a postgres image to fix this issue.

```yml
  build-and-test:
    docker:
      - image: cimg/python:3.10.1
      - image: cimg/postgres:14.1
        environment:
          POSTGRES_USER: example
```
Next let's take a look at the `settings.py` file in our Django project. In order for our app to be able to connect to postgresql in circleci, we'll need to set have `HOST` set to `localhost`. Also make sure that the `POSTGRES_USER` in your circleci.yml matches the `USER` in your `settings.py` file. In this case I went with the generic `example`. 

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'my_media',
        'USER': 'example',
        'PASSWORD': '1234',
        'HOST': 'localhost',
        'PORT': '5432',
    }
}
```
Now rerun the build and it should pass. There's a lot more we can do, including saving our test results, but for now, let's commit these changes. Now circleci will listen for changes to your repo. It will run a new build whenever you push a new branch, push changes to a branch or merge to main. You'll be able to see the status of the build on your PR. 

what
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
