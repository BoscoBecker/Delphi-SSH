# Delphi-SSH
Para o desenvolvimento foi utilizado a o framework  https://github.com/pyscripter/Ssh-Pascal que é uma implementação da [LIBSSH2](https://www.libssh2.org/)


## Criando conexão ssh com delphi
Para o uso é necessário gerar sua key RSA:

>>ssh-keyscan -t rsa seuhost

Adicionar a Key gerado no ao arquivo 
>>%USERPROFILE% + .ssh\known_hosts

E estabelecer a conexão com o host desejado.

