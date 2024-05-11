*** Settings ***
Resource        ../resource/data/login.robot
Resource        ../resource/geral.resource
Resource        ../resource/login_user.resource
Resource        ../resource/criar_centroDeCustos.resource
Library         RequestsLibrary
Library         String
Library         Collections

*** Variables ***

*** Keywords ***
Criar um novo departamento
    ${palavra_randomica}    Generate Random String    length=10    chars=[LETTERS]
    ${palavra_randomica}    Convert To Lower Case     ${palavra_randomica}
    Set Test Variable       ${DEPARTAMENTO_NOME}      ${palavra_randomica}
    Log                     ${DEPARTAMENTO_NOME} 

Cadastrar o novo departamento criado
     ${body}    Create Dictionary    departmentName=${DEPARTAMENTO_NOME}   costCenterId=${IDCENTROCUSTO} 
     Log        ${body}
     Criar sessão
     Entrar com usuário sysadmin
     ${headers}    Create Dictionary    Authorization=${TOKEN}
     ${resposta}   POST On Session      alias=Chips    url=/api/department/   json=${body}    headers=${headers}    expected_status=201
     Log    ${resposta.json()}
     Set Test Variable    ${ID_DEPARTMENT}      ${resposta.json()["newDepartment"]["_id"]}
     Set Test Variable    ${RESPOSTA}           ${resposta.json()}

Conferir se este novo departamento foi cadastrado corretamente
    Log    ${RESPOSTA}
    Dictionary Should Contain Item    ${RESPOSTA}    msg    Cadastro realizado com sucesso.
    Dictionary Should Contain Key     ${RESPOSTA["newDepartment"]}    _id
    Status Should Be   201    

Cadastrar o novo departamento criado com mais de 50 caracteres
     ${body}    Create Dictionary    departmentName=Sol&Luz&Mar&Montanha&Floresta&Planície&Estrela&Lua&Sol&Luz&Mar&Montanha&Floresta&Planície&Estrela&Lua   costCenterId=${IDCENTROCUSTO} 
     Log        ${body}
     Criar sessão
     Entrar com usuário sysadmin
     ${headers}    Create Dictionary    Authorization=${TOKEN}
     ${resposta}   POST On Session      alias=Chips    url=/api/department/   json=${body}    headers=${headers}    expected_status=400
     Log    ${resposta.json()}
     Should Be Equal As Strings          ${resposta.status_code}                                                400
     Should Be Equal As Strings          ${resposta.json()['error']}    ["O campo 'departamento' deve possuir no máximo 50 caracteres."]

Cadastrar o novo departamento criado com nome em branco
     ${body}    Create Dictionary    departmentName=   costCenterId=${IDCENTROCUSTO} 
     Log        ${body}
     Criar sessão
     Entrar com usuário sysadmin
     ${headers}    Create Dictionary    Authorization=${TOKEN}
     ${resposta}   POST On Session      alias=Chips    url=/api/department/   json=${body}    headers=${headers}    expected_status=400
     Log    ${resposta.json()}
     Should Be Equal As Strings          ${resposta.status_code}                                                400
     Should Be Equal As Strings          ${resposta.json()['error']}   ["O campo 'departamento' é obrigatório."]
  
Cadastrar o novo departamento criado com caracteres especiais
     Criar um novo departamento
     ${body}    Create Dictionary    departmentName=@@@@@§§§§$$$$$$aAPD&   costCenterId=${IDCENTROCUSTO} 
     Log        ${body}
     Criar sessão
     Entrar com usuário sysadmin
     ${headers}    Create Dictionary    Authorization=${TOKEN}
     ${resposta}   POST On Session      alias=Chips    url=/api/department/   json=${body}    headers=${headers}    expected_status=400
     Log    ${resposta.json()}
     Should Be Equal As Strings          ${resposta.status_code}                                                400
     Should Be Equal As Strings          ${resposta.json()['error']}   ["O campo 'departamento' só pode conter letras e o caractere especial '&'."]

Cadastrar o novo departamento criado sem o Centro de Custos
     ${body}    Create Dictionary    departmentName=${DEPARTAMENTO_NOME}  costCenterId=
     Log        ${body}
     Criar sessão
     Entrar com usuário sysadmin
     ${headers}    Create Dictionary    Authorization=${TOKEN}
     ${resposta}   POST On Session      alias=Chips    url=/api/department/   json=${body}    headers=${headers}    expected_status=400
     Log    ${resposta.json()}
     Should Be Equal As Strings          ${resposta.status_code}                                                400
     Should Be Equal As Strings          ${resposta.json()['error']}   ["O campo 'ID do centro de custos' é obrigatório."]

Cadastrar um novo departamento já existente
     ${body}    Create Dictionary    departmentName=Anderson&Francelino  costCenterId=${IDCENTROCUSTO} 
     Log        ${body}
     Criar sessão
     Entrar com usuário sysadmin
     ${headers}    Create Dictionary    Authorization=${TOKEN}
     ${resposta}   POST On Session      alias=Chips    url=/api/department/   json=${body}    headers=${headers}    expected_status=409
     Log    ${resposta.json()}
     Should Be Equal As Strings          ${resposta.status_code}                                                409
     Should Be Equal As Strings          ${resposta.json()['alert']}    ['Não é possível salvar esse registro. Departamento já cadastrado no sistema.']

Cadastrar um novo departamento sem TOKEN
     Criar um novo departamento
     ${body}    Create Dictionary    departmentName=${DEPARTAMENTO_NOME}  costCenterId=${IDCENTROCUSTO} 
     Log        ${body}
     Criar sessão
     Entrar com usuário sysadmin
     ${headers}    Create Dictionary    Authorization=
     ${resposta}   POST On Session      alias=Chips    url=/api/department/   json=${body}    headers=${headers}    expected_status=403
     Log    ${resposta.json()}
     Should Be Equal As Strings          ${resposta.status_code}                                                403
     Should Be Equal As Strings          ${resposta.json()["errors"]}                                           ['No token provided.']

Cadastrar um novo Departamento com ID
     ${body}    Create Dictionary    departmentName=${DEPARTAMENTO_NOME}  costCenterId=${IDCENTROCUSTO} 
     Log        ${body}
     Criar sessão
     Entrar com usuário sysadmin
     ${headers}    Create Dictionary    Authorization=${TOKEN}
     ${resposta}   POST On Session      alias=Chips    url=/api/department/1234565  json=${body}    headers=${headers}    expected_status=404
     Should Be Equal As Strings          ${resposta.status_code}                                                404
    