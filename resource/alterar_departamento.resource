*** Settings ***
Resource        ../resource/data/login.robot
Resource        ../resource/geral.resource
Resource        ../resource/login_user.resource
Resource        ../resource/criar_centroDeCustos.resource
Resource        ../resource/criar_departamento.resource
Library         RequestsLibrary
Library         String
Library         Collections

*** Variables ***

${id_department}    6582390631248304b069e053
${id_centrocustos}  658238ef31248304b069e04b



*** Keywords ***

Alterar o novo departamento criado
    
     Criar um novo departamento
     ${body}    Create Dictionary    departmentName=Francelino&Anderson   costCenterId=${id_centrocustos} 
     Log        ${body}
     Criar sessão
     Entrar com usuário sysadmin
     ${headers}    Create Dictionary    Authorization=${TOKEN}
     ${resposta}   PUT On Session      alias=Chips    url=/api/department/${id_department}   json=${body}    headers=${headers}    expected_status=200
     Log    ${resposta.json()}
     Set Test Variable       ${RESPOSTA}             ${resposta.json()}
     
Conferir se este departamento foi alterado corretamente
    Log    ${RESPOSTA}
    Dictionary Should Contain Item    ${RESPOSTA}    msg    Cadastro atualizado com sucesso.
    Dictionary Should Contain Key     ${RESPOSTA["updatedDepartment"]}    _id
    Status Should Be   200 



##### ATUALIZAÇÃO DE STATUS ######



Atualizar status do departamento para ativo
    ${body}    Create Dictionary    status=${TRUE}
    Log        ${body}
    Criar sessão
    Entrar com usuário sysadmin
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${resposta}   PUT On Session      alias=Chips    url=/api/department/status/6582085d31248304b069dfef  json=${body}    headers=${headers}    expected_status=202   
    Log    ${resposta.json()}
    Set Test Variable       ${RESPOSTA1}             ${resposta.json()}

Conferir se o status do departamento foi alterado corretamente
    Log    ${RESPOSTA1}
    Dictionary Should Contain Item    ${RESPOSTA1}    msg   Departamento inativado com sucesso!
    Status Should Be   202



Tentativa de atualização de status "TRUE" 208
    ${body}    Create Dictionary    status=${TRUE}
    Log        ${body}
    Criar sessão
    Entrar com usuário sysadmin
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${resposta}   PUT On Session      alias=Chips    url=/api/department/status/6582085d31248304b069dfef  json=${body}    headers=${headers}    expected_status=208
    Log    ${resposta.json()}
    Set Test Variable       ${RESPOSTA1}             ${resposta.json()}

Conferir se o status do departamento foi alterado
    Log    ${RESPOSTA1}
    Dictionary Should Contain Item    ${RESPOSTA1}    msg    Esse departamento já se encontra ativado.
    Status Should Be   208

Atualizar status do departamento para inativo
    ${body}    Create Dictionary    status=${FALSE}
    Log        ${body}
    Criar sessão
    Entrar com usuário sysadmin
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${resposta}   PUT On Session      alias=Chips    url=/api/department/status/6582085d31248304b069dfef  json=${body}    headers=${headers}    expected_status=202
    Log    ${resposta.json()}
    Set Test Variable       ${RESPOSTA1}             ${resposta.json()}
    Conferir se o status do departamento foi alterado corretamente


Tentativa de atualização de status "FALSE" 208
    ${body}    Create Dictionary    status=${FALSE}
    Log        ${body}
    Criar sessão
    Entrar com usuário sysadmin
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${resposta}   PUT On Session      alias=Chips    url=/api/department/status/6582085d31248304b069dfef  json=${body}    headers=${headers}    expected_status=208
    Log    ${resposta.json()}
    Set Test Variable       ${RESPOSTA1}             ${resposta.json()}
    
Conferir se o status de inativado do departamento foi alterado
    Log    ${RESPOSTA1}
    Dictionary Should Contain Item    ${RESPOSTA1}    msg     Esse departamento já se encontra inativado.
    Status Should Be   208


Atualizar status do departamento para ativo sem o TOKEN
    ${body}    Create Dictionary    status=${TRUE}
    Log        ${body}
    Criar sessão
    Entrar com usuário sysadmin
    ${headers}    Create Dictionary    Authorization=
    ${resposta}   PUT On Session      alias=Chips    url=/api/department/status/6582085d31248304b069dfef  json=${body}    headers=${headers}    expected_status=403
    Log    ${resposta.json()}
    Set Test Variable       ${RESPOSTA1}             ${resposta.json()}
    Log    ${resposta.json()}
    Should Be Equal As Strings          ${resposta.status_code}                                                403
    Should Be Equal As Strings          ${resposta.json()["errors"]}                                           ['No token provided.']

Atualizar status do departamento com ENDPOINT incorreto 
    ${body}    Create Dictionary    status=${TRUE}
    Log        ${body}
    Criar sessão
    Entrar com usuário sysadmin
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${resposta}   PUT On Session      alias=Chips    url=/api/department/stat/6582085d31248304b069dfef  json=${body}    headers=${headers}    expected_status=404   
    Status Should Be   404


Atualizar status do departamento para inativo com ID inexistente
    ${body}    Create Dictionary    status=${FALSE}
    Log        ${body}
    Criar sessão
    Entrar com usuário sysadmin
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${resposta}   PUT On Session      alias=Chips    url=/api/department/status/2115  json=${body}    headers=${headers}    expected_status=500
    Log    ${resposta.json()}
    Set Test Variable       ${RESPOSTA1}             ${resposta.json()}
    Log    ${resposta.json()}
    Should Be Equal As Strings          ${resposta.status_code}                                                500
    Should Be Equal As Strings          ${resposta.json()["error"]}                                           CastError: Cast to ObjectId failed for value \"2115\" (type string) at path \"_id\" for model \"Department\"

Atualizar status do departamento para inativo com ID em branco
    ${body}    Create Dictionary    status=${FALSE}
    Log        ${body}
    Criar sessão
    Entrar com usuário sysadmin
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${resposta}   PUT On Session      alias=Chips    url=/api/department/status/  json=${body}    headers=${headers}    expected_status=400
    Log    ${resposta.json()}
    Set Test Variable       ${RESPOSTA1}             ${resposta.json()}
    Log    ${resposta.json()}
    Should Be Equal As Strings          ${resposta.status_code}                                                400
    Should Be Equal As Strings          ${resposta.json()["error"]}                                            ["O campo 'departamento' é obrigatório.", "O campo 'ID do centro de custos' é obrigatório."]
   
Atualizar status do departamento para inativo com ID não encontrado
    ${body}    Create Dictionary    status=${FALSE}
    Log        ${body}
    Criar sessão
    Entrar com usuário sysadmin
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${resposta}   PUT On Session      alias=Chips    url=/api/department/status/658238ef31248304b069e04b  json=${body}    headers=${headers}    expected_status=404
    Log    ${resposta.json()}
    Set Test Variable       ${RESPOSTA1}             ${resposta.json()}
    Log    ${resposta.json()}
    Should Be Equal As Strings          ${resposta.status_code}                                                404
    Should Be Equal As Strings          ${resposta.json()["msg"]}                                              Não foi possível encontrar a departamento com o id especificado


##### CASOS DE EXCESSÃO ########


Alterar departamento criado com mais de 50 caracteres
     Criar um novo departamento
     ${body}    Create Dictionary    departmentName=Sol&Luz&Mar&Montanha&Floresta&Planície&Estrela&Lua&Sol&Luz&Mar&Montanha&Floresta&Planície&Estrela&Lua   costCenterId=${id_centrocustos}  
     Log        ${body}
     Criar sessão
     Entrar com usuário sysadmin
     ${headers}    Create Dictionary    Authorization=${TOKEN}
     ${resposta}  PUT On Session      alias=Chips    url=/api/department/${id_department}  json=${body}    headers=${headers}    expected_status=400
     Log    ${resposta.json()}
     Should Be Equal As Strings          ${resposta.status_code}                                                400
     Should Be Equal As Strings          ${resposta.json()['error']}    ["O campo 'departamento' deve possuir no máximo 50 caracteres."]

Alterar o novo departamento criado com nome em branco
     ${body}    Create Dictionary    departmentName=   costCenterId=${id_centrocustos} 
     Log        ${body}
     Criar sessão
     Entrar com usuário sysadmin
     ${headers}    Create Dictionary    Authorization=${TOKEN}
     ${resposta}   PUT On Session      alias=Chips    url=/api/department/${id_department}   json=${body}    headers=${headers}    expected_status=400
     Log    ${resposta.json()}
     Should Be Equal As Strings          ${resposta.status_code}                                                400
     Should Be Equal As Strings          ${resposta.json()['error']}   ["O campo 'departamento' é obrigatório."]

Alterar departamento criado com caracteres especiais
     Criar um novo departamento
     ${body}    Create Dictionary    departmentName=@@@@@§§§§$$$$$$aAPD&   costCenterId=${id_centrocustos} 
     Log        ${body}
     Criar sessão
     Entrar com usuário sysadmin
     ${headers}    Create Dictionary    Authorization=${TOKEN}
     ${resposta}   PUT On Session      alias=Chips    url=/api/department/${id_department}   json=${body}    headers=${headers}    expected_status=400
     Log    ${resposta.json()}
     Should Be Equal As Strings          ${resposta.status_code}                                                400
     Should Be Equal As Strings          ${resposta.json()['error']}   ["O campo 'departamento' só pode conter letras e o caractere especial '&'."]

Alterar departamento criado sem o Centro de Custos
     ${body}    Create Dictionary    departmentName=${DEPARTAMENTO_NOME}  costCenterId=
     Log        ${body}
     Criar sessão
     Entrar com usuário sysadmin
     ${headers}    Create Dictionary    Authorization=${TOKEN}
     ${resposta}   PUT On Session      alias=Chips    url=/api/department/${id_department}   json=${body}    headers=${headers}    expected_status=400
     Log    ${resposta.json()}
     Should Be Equal As Strings          ${resposta.status_code}                                                400
     Should Be Equal As Strings          ${resposta.json()['error']}   ["O campo 'ID do centro de custos' é obrigatório."]

Alterar um novo departamento já existente com Centro de Custo incorreto
     ${body}    Create Dictionary    departmentName=Francelino&Anderson  costCenterId=658238ef31248304b069e041
     Log        ${body}
     Criar sessão
     Entrar com usuário sysadmin
     ${headers}    Create Dictionary    Authorization=${TOKEN}
     ${resposta}   PUT On Session      alias=Chips    url=/api/department/${id_department}     json=${body}    headers=${headers}    expected_status=409
     Log    ${resposta.json()}
     Should Be Equal As Strings          ${resposta.status_code}                                                409
     Should Be Equal As Strings          ${resposta.json()['msg']}    Não foi possível encontrar o centro de custos com o id especificado

Alterar um departamento sem TOKEN
     Criar um novo departamento
     ${body}    Create Dictionary    departmentName=${DEPARTAMENTO_NOME}  costCenterId=${id_centrocustos} 
     Log        ${body}
     Criar sessão
     Entrar com usuário sysadmin
     ${headers}    Create Dictionary    Authorization=
     ${resposta}   PUT On Session      alias=Chips    url=/api/department/${id_department}    json=${body}    headers=${headers}    expected_status=403
     Log    ${resposta.json()}
     Should Be Equal As Strings          ${resposta.status_code}                                                403
     Should Be Equal As Strings          ${resposta.json()["errors"]}                                           ['No token provided.']

Alterar Departamento com EndPoint incorreto
     ${body}    Create Dictionary    departmentName=${DEPARTAMENTO_NOME}  costCenterId=${id_centrocustos} 
     Log        ${body}
     Criar sessão
     Entrar com usuário sysadmin
     ${headers}    Create Dictionary    Authorization=${TOKEN}
     ${resposta}   PUT On Session     alias=Chips    url=/api/departmen/1234565  json=${body}    headers=${headers}    expected_status=404
     Should Be Equal As Strings          ${resposta.status_code}                                                404
    
Alterar Departamento com Id incorreto
     ${body}    Create Dictionary    departmentName=${DEPARTAMENTO_NOME}  costCenterId=${id_centrocustos} 
     Log        ${body}
     Criar sessão
     Entrar com usuário sysadmin
     ${headers}    Create Dictionary    Authorization=${TOKEN}
     ${resposta}   PUT On Session     alias=Chips    url=/api/department/1234565  json=${body}    headers=${headers}    expected_status=500
     Should Be Equal As Strings          ${resposta.status_code}                                                500
     Should Be Equal As Strings          ${resposta.json()["error"]}                                           CastError: Cast to ObjectId failed for value \"1234565\" (type string) at path \"_id\" for model \"Department\"




