*** Settings ***
Resource  ../resource/geral.resource
Resource  ../resource/login_user.resource
Resource  ../resource/criar_diretoria.resource

*** Test Cases ***
CT01 - Criar diretoria
    Criar sessão
    Entrar com usuário sysadmin
    Criar uma nova diretoria
    Cadastrar a nova diretoria criada
    Conferir se esta nova diretoria foi cadastrada corretamente
