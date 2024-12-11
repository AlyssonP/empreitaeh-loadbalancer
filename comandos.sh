# Nodes
docker run -d -p 80 -v ./build:/usr/share/nginx/html/ -v ./nginx.conf:/etc/nginx/nginx.conf -v ./app.conf:/etc/nginx/conf.d/default.conf --name node1 --hostname node1 nginx:alpine
docker run -d -p 80 -v ./build:/usr/share/nginx/html/ -v ./nginx.conf:/etc/nginx/nginx.conf -v ./app.conf:/etc/nginx/conf.d/default.conf --name node2 --hostname node2 nginx:alpine
docker run -d -p 80 -v ./build:/usr/share/nginx/html/ -v ./nginx.conf:/etc/nginx/nginx.conf -v ./app.conf:/etc/nginx/conf.d/default.conf --name node3 --hostname node3 nginx:alpine
docker run -d -p 80 -v ./build:/usr/share/nginx/html/ -v ./nginx.conf:/etc/nginx/nginx.conf -v ./app.conf:/etc/nginx/conf.d/default.conf --name node4 --hostname node4 nginx:alpine
docker run -d -p 80 -v ./build:/usr/share/nginx/html/ -v ./nginx.conf:/etc/nginx/nginx.conf -v ./app.conf:/etc/nginx/conf.d/default.conf --name node5 --hostname node5 nginx:alpine

# Loadbalancer
docker run -it -d -p 80:80 -v ./default.conf:/etc/nginx/conf.d/default.conf --name loadbalancer nginx:alpine