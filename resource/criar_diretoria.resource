*** Settings ***
Resource  ../resource/data/login.robot
Resource  ../resource/geral.resource
Resource  ../resource/login_user.resource
Library    RequestsLibrary
Library    String
Library    Collections

*** Variables ***

*** Keywords ***

Criar uma nova diretoria
    ${palavra_randomica}    Generate Random String    length=8    chars=[LETTERS]
    ${palavra_randomica}    Convert To Lower Case     ${palavra_randomica}
    Set Test Variable       ${DIRETORIA_NOME}         ${palavra_randomica}
    Log                     ${DIRETORIA_NOME} 

Cadastrar a nova diretoria criada
    ${body}    Create Dictionary    boardName=${DIRETORIA_NOME}
    Log        ${body}
    Criar sessão
    Entrar com usuário sysadmin
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${resposta}   POST On Session      alias=Chips    url=/api/board/    json=${body}    headers=${headers}    expected_status=201
    Log    ${resposta.json()}
    Set Test Variable    ${ID_DIRETORIA}    ${resposta.json()["newBoard"]["_id"]}
    Set Test Variable    ${RESPOSTA}        ${resposta.json()}

Conferir se esta nova diretoria foi cadastrada corretamente
    Log    ${RESPOSTA}
    Dictionary Should Contain Item    ${RESPOSTA}    msg    Cadastro realizado com sucesso!
    Dictionary Should Contain Key     ${RESPOSTA["newBoard"]}    _id
    Status Should Be   201    
