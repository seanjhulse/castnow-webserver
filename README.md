# Castnow Web-Server

This is a webserver using Ruby on Rails to serve .mp4 files to a locally hosted Chromecast. It's meant to only require *one* environment variable to change in order for it to begin working.

This webserver **only** works for .mp4 files. The *castnow* repository shows you how to use other video encodings, but currently we're limited to .mp4. Plus, if you use anything other than .mp4, many of the buttons will not work.

## Installation

```bash

$ git clone https://github.com/seanjhulse/castnow-webserver.git 
$ cd castnow-webserver
$ bundle install

```

After running bundle install, change the @home_path variable inside the MagicController located in ```app/controllers/magic_controller.rb```. You'll want to change this variable to the full path where your videos are stored.

## Running

```bash
$ rails s -b 0.0.0.0 
```

## Usage

Now, if you have movies in the path that you specified inside the MagicController, they will be available at two urls:

1. localhost:3000
2. YOUR-IP:3000

You don't have to do anything else to begin using the home theater web server. 

## Contributing

Fork and ask for a merge request. This repo is young so it's liable to change frequently. 
