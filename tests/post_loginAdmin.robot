*** Settings ***
Resource  ../resource/geral.resource
Resource  ../resource/login_user.resource

*** Test Cases ***
CT01 - Login de usuário
    Criar sessão
    Entrar com usuário sysadmin
    Validar o token e gravar em um header de autorização