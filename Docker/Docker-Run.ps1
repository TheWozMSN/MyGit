netsh advfirewall firewall add rule name="docker management" dir=in action=allow protocol=TCP localport=2375 enable=yes profile=domain,private,public

docker run -d -p 9000:9000 -p 8000:8000 --name portainer --restart always -v \\.\pipe\docker_engine:\\.\pipe\docker_engine -v C:\ProgramData\Portainer:C:\data portainer/portainer -H tcp://docker.for.win.localhost:2375