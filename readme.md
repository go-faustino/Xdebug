Xdebug
======

This repo includes a Dockerfile, to run Xdebug in a container. You can find it on Github: https://github.com/go-faustino/Xdebug and Docker Hub: https://hub.docker.com/r/gofaustino/xdebug/

To change Xdebug parameters, clone the Github repo, edit ext-xdebug.ini, and build the image again, using the following command (the final dot must be kept):

  docker build -t user/xdebug .

To run the container, use the following run command as a guideline:

	docker run -d --name some-xdebug -p 80:80 -v /local_path_where_your_php_app_is_located:/var/www/html --link some-mysql:mysql user/xdebug
  
Guidelines to edit ext-xdebug.ini
---------------------------------

  xdebug.remote_autostart = 0
    you have to activate debugging, either with a browser extension, or appending ?XDEBUG_SESSION_START=1 to the url
    
  xdebug.remote_autostart = 1
    debugging starts immediately
    
  xdebug.remote_connect_back = 0
    you have to declare the remote_host parameter, with the remote host ip address
    
  xdebug.remote_connect_back = 1
    xdebug detects the caller ip address. When called in a container, xdebug will detect this as the local ip address (eg: 172.17.0.1), and it should connect to the ip address on the network (eg: 192.168.1.45), so this probably won't work
    
  xdebug.remote_host
    if remote_connect_back = 0, this must be included. Find your network ip address (ifconfig en0), and use it here