## Fix DNS pointing to WINZNLABDC

Check actual configuration:
```
sudo resolvectl dns
```
Configure on the right link:

```
sudo resolvectl dns ens160 10.160.55.217

```

znlab.loc
## Create traffic generator application

sudo apt install git docker-compose

git clone https://github.com/znhomelab/znlab.git

cd $HOME/znlab/wptraffic

Some useful commands:
Build:
```
sudo docker-compose up --build
```
Run as daemon
```
sudo docker-compose up -d
```
Check logs
```
sudo docker-compose logs
```
Check logs
```
sudo docker exec -it wp_traffic_generator /bin/bash
```
Shutdown
```
sudo docker-compose down
```
Delete all images
```
sudo docker image prune -af
```

