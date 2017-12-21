Xdebug
======

This repo includes a Dockerfile, to run Xdebug in a container. You can find it on Github: https://github.com/go-faustino/Xdebug and Docker Hub: https://hub.docker.com/r/gofaustino/xdebug/

To run the container, use the following run command as a guideline. This includes a volume for external configuration of the installed extensions, including Xdebug, which allows changing the settings on the fly and persisting them, if you don't need it just remove that -v parameter:

	docker run -d --name some-xdebug -p 80:80 -v /host_php_app_path:/var/www/html -v ~/host_path_for_config_files:/usr/local/etc/php/conf.d --link mysql:mysql gofaustino/xdebug
    
Guidelines for editing ext-xdebug.ini
-------------------------------------  
  
* xdebug.remote_autostart  
  * xdebug.remote_autostart = 0
    * you have to activate debugging, either with a browser extension, or appending ?XDEBUG_SESSION_START=1 to the url in your browser  
  * xdebug.remote_autostart = 1
    * debugging starts immediately    
* xdebug.remote_connect_back
  * xdebug.remote_connect_back = 0
    * On your debugging tool, you need to setup the remote host ip address
  * xdebug.remote_connect_back = 1
    * xdebug detects the caller ip address. When called in a container, xdebug will detect this as the local ip address (eg: 172.17.0.1), and it should connect to the ip address on the network (eg: 192.168.1.x), so this probably won't work
* xdebug.remote_host
  * if remote_connect_back = 0, this must be included. Find your network ip address (ifconfig en0), and use it here