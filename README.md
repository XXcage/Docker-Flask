# DOCKERS WORKSHOP:
#Built images:  
Single rzlinux0/dev:single  
Multi  rzlinux0/prod:multi

```docker run -p <YourPort>:8080 <IMAGE>```

#Dockerfiles to build:  
SingleStage - https://github.com/XXcage/flask/blob/main/SingleDockerfile  
MultiStage  - requires: https://github.com/XXcage/flask/blob/main/docker-compose.yml and ```docker-compose up```  
then https://github.com/XXcage/flask/blob/main/Dockerfile
