# Ramanujan

Ramanujan is a web application that allows you manage your contacts and create segmentations over
them.

The name Ramanujan is in honor of [Srinavasa Ramanujan](https://en.wikipedia.org/wiki/Srinivasa_Ramanujan),
a great mathematician that could find very interesting hidden patterns when no one else saw them. 

In this web application we have:
- Ruby on Rails 5
- CRUD of contacts
- CRUD of segmentations
- Materialize CSS for styling
- Font-awesome for icons
- Normalize CSS
- Functional tests
- TypeScript (instead of CoffeeScript)
- HTML5 Boilerplate best pratices merged
- Improvements in the layout `application.html.erb`
- Auto-reloading techniques with livereload, guard and guard-livereload
- Debugging techniques with byebug and ruby-debug-ide
- Sqlite database for development and PostgreSQL for production
- Seed database entries for contacts and segmentations

## Installation

### Simple Installation
- git clone https://github.com/Danilo-Araujo-Silva/Ramanujan.git
- cd Ramanujan
- bin/bundle install
- npm install (optional)

### Detailed Installation
If you have Ruby, Rails, NPM and NodeJS already installed
you probably can jump to the next section.

#### Install Latest Ruby
If you don't have the latest ruby yet you can install it using rvm.
The official documentation is [here](https://rvm.io/).

- Add rvm keys:
  - gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
- Install rvm:
  - \curl -sSL https://get.rvm.io | bash
- Install the latest ruby:
  - rvm install ruby --latest
  
#### Install Latest Rails
If you don't have rails yet you can install it as follows:

- gem install rails
  
#### Update All Gems
If would like to update all your gems first you can do it as follows:

- gem update

### Install NodeJS (Optional)
If you don't have NodeJS and NPM installed yet you can follow
[these instructions](https://nodejs.org/en/download/package-manager/) in the
official documentation.

#### Install Latest NPM (Optional)
If you already have npm installed and you would like update it to the latest
version you can do it as follows:

- npm install npm@latest -g

#### Install Latest NodeJS (Optional)
If you already have npm installed and you would like to update the NodeJS to the
latest version you can do it as follows:

- sudo npm cache clean -f
- sudo npm install -g n
- sudo n stable

Important! The option `-f` is used to force clean the npm cache. Take care about it.
Anyway, I usually do this when I would like to install the latest NodeJS.

#### Install NPM Dependencies (Optional)
These instructions is used to install the local npm dependencies. The dependencies
will be placed in the `node_modules` folder (already ignored by `.gititnore`).

- npm install
  
#### Install Some Global NPM Dependencias (Optional)
If you would like to have the typescript dependencies installed globally you
can do this as follows:

- npm install -g @types/node typescript
   - Maybe `sudo` is needed to run the previous command.
   
## Usage

### Development Mode
- bin/rake db:migrate
- bin/rake db:seed
- guard
  - Run this command in one terminal (this enable the capability to auto-reload
  the browser when have have file changes)
- bin/rails server
  - Run this in another terminal

### Production Mode
- RAILS_ENV=production bin/rake db:migrate
- RAILS_ENV=production bin/rake db:seed
- RAILS_ENV=production bin/rake secret
 - This secret will be used in the following steps.
- RAILS_ENV=production bin/rake assets:clean
- RAILS_ENV=production bin/rake assets:precompile
- RAILS_ENV=production RAILS_SERVE_STATIC_FILES=true SECRET_KEY_BASE={secret key} bin/rails server
