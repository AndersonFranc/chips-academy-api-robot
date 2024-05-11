*** Settings ***
Resource  ../resource/data/login.robot
Resource  ../resource/geral.resource
Library    RequestsLibrary
Library    String
Library    Collections
Library    OperatingSystem

*** Keywords ***
Entrar com usuário sysadmin
    ${body}  Create Dictionary    mail=${mail}    password=${password}
    Log      ${body}
    Criar sessão
    ${resposta}    POST On Session    alias=Chips    url=api/login/    json=${body}
    Log        ${resposta.json()}
    Set Test Variable    ${TOKEN}    ${resposta.json()["token"]}

Validar o token e gravar em um header de autorização
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${resposta}   GET On Session       alias=Chips    url=/api/validateToken    headers=${headers}
    Log   Resposta da solicitação: ${resposta.content}
    Log    ${TOKEN} 
