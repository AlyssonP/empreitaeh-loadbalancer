# EmpreitAeh LoadBalancer - NGINX
Neste repositório encontra-se toda a configuração necessária para a criação de um balanceador de carga usando NGINX com 5 nodes (nós), tudo isso utilizando containerização com Docker. Nestes nodes, há uma aplicação em ReactJS, desenvolvida como projeto final da disciplina PWEB2. Siga os passos abaixo para entender melhor.

## Configuração dos nodes 
Primeiro, é necessário configurar os nodes para dar continuidade ao restante da configuração.

### 1. Build da aplicação
Para a criação dos containers, primeiro precisamos do build da aplicação para referenciarmos o volume. O build está na pasta [build](./build/).

### 2. Arquivos de configurações
Depois, criamos alguns arquivos de configuração do servidor NGINX e da aplicação. 
- Primeiro, criamos o arquivo de configuração do servidor, ativando o log de acesso e também formatando-o para receber o IP do cliente que realizou a requisição da aplicação. O arquivo é o [nginx.conf](nginx.conf)
- Segundo, criamos o arquivo de configuração da aplicação, onde adicionamos as configurações necessárias para aplicações SPA. O arquivo é o [app.conf](./app.conf)

### 3. Criação dos containers
Por fim, podemos criar os containers dos nodes. Seguem os comandos abaixo:
```
docker run -d -p 80 -v ./build:/usr/share/nginx/html/ -v ./nginx.conf:/etc/nginx/nginx.conf -v ./app.conf:/etc/nginx/conf.d/default.conf --name node1 --hostname node1 nginx:alpine
```
Esse comando serve para a criação do node1, mas também pode ser usado para criar os outros nodes, bastando alterar o nome (`--name`) e o hostname (`--hostname`). Podemos analisar que, nesse comando, estamos passando como volumes os arquivos de configuração e a pasta onde está o build da aplicação.

### 4. Extra
Para automatizar a criação dos containers dos nodes, disponibilizo um código Bash onde você pode criar a quantidade de nós que desejar. O arquivo é o [up_nodes.sh](./automacoes/up_nodes.sh)
- Primeiro, libere a permissão de execução do script:
```
chmod +x up_nodes.sh
``` 
- Segundo, agora é executar:
```
./up_nodes.sh 5
```


## Configuração do LoadBalancer
O segundo passo, para finalizarmos, é configurar o container balanceador.

### 1. Criação do arquivo de configuração
- Primeiro, para realizar a criação do container loadbalancer, precisamos montar o arquivo de configuração do servidor NGINX. O arquivo é o [default.com](./default.conf). Nesse arquivo, configuramos o balanceador de carga e definimos, com o atributo `upstream`, o grupo de servidores que o compõem, ou seja, os nodes iniciados na explicação acima:
```
upstream nodes {
    server 172.17.0.2;
    server 172.17.0.3;
    server 172.17.0.4;
    server 172.17.0.5;
    server 172.17.0.6;
}
```
Podemos observar que estamos passando o IP de cada container node, onde nossa aplicação está disponível. Será necessário saber o ip dos nodes.
- Segundo, para que as requisições sejam direcionadas ao grupo de servidores, adicionamos a seguinte configuração:
```
location / {
    proxy_pass http://nodes;
}
```
- Terceiro, como extra, podemos configurar o envio do IP do cliente que fez a requisição para o node, em vez de enviar o próprio IP do loadbalancer como padrão. Para isso, aplicamos a configuração abaixo:
```
location / {
    proxy_pass http://nodes;
    # Enviando o IP do cliente para o node
    proxy_set_header X-Real-IP $remote_addr; 
}
```

### 2. Criação do container
Depois de criar o arquivo de configuração, podemos iniciar o container principal, que é o loadbalancer, com o comando abaixo:
```
docker run -it -d -p 80:80 -v ./default.conf:/etc/nginx/conf.d/default.conf --name loadbalancer nginx:alpine
```
Com o comando acima, podemos observar que estamos disponibilizando o container na porta 80 do host, com o parâmetro `-p 80:80`, e configurando o volume, onde referenciamos o arquivo de configuração no parâmetro `-v`.

### 3. Extra
Para criar o container loadbalancer de forma organizada, também disponibilizo um arquivo Bash: [up_loadbalancer.sh](./automacoes/up_loadbalancer.sh)
- Primeiro, libere a permissão de execução do script:
```
chmod +x up_loadbalancer.sh
``` 
- Segundo, execute o script:
```
./up_loadbalancer.sh
```

### Referências
- [NGINX IMAGE](https://hub.docker.com/_/nginx)
- [Load Balancer NGINX](https://docs.nginx.com/nginx/admin-guide/load-balancer/http-load-balancer)
- [Vídeo - Nginx: do básico ao Load Balancer](https://www.youtube.com/watch?v=pPlcC5hDMCs)