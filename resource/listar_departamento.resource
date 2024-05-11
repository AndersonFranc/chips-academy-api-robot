*** Settings ***
Resource    ../resource/data/login.robot
Resource    ../resource/geral.resource
Resource    ../resource/login_user.resource
Library     RequestsLibrary
Library     String
Library     Collections

*** Variables ***
${id_do_usuario}       6582085d31248304b069dfef
${id_invalido}         6582085d31248304b069dfe1  

*** Keywords ***
Listar todos os departamentos
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${resposta}   GET On Session       alias=Chips    url=/api/department    headers=${headers}    expected_status=200
    Log           ${resposta}

    ${json}    Set Variable    ${resposta.json()}
    ${department_name}    Set To Dictionary    ${json}[0]
    Log    ${department_name}

    Should Not Be Empty    ${department_name["departmentName"]}
    Should Not Be Empty    ${department_name["costCenter"]["costCenterName"]}

Listar todos os departamentos erro de token 403
    ${headers}    Create Dictionary    Authorization=
    ${resposta}   GET On Session       alias=Chips    url=/api/department    headers=${headers}    expected_status=403
    Log           ${resposta}
    Should Be Equal As Strings          ${resposta.status_code}                                                403
    Should Be Equal As Strings          ${resposta.json()["errors"]}                                           ['No token provided.']
Listar departamento por ID
    [Arguments]    ${id}
    ${headers}     Create Dictionary    Authorization=${TOKEN}
    ${resposta}    GET On Session       alias=Chips    url=/api/department/${id}    headers=${headers}        expected_status=200
    Log     ${resposta}

    Should Be Equal As Strings          ${resposta.status_code}                                                200
    Should Be Equal As Strings          ${resposta.json()["department"]["departmentName"]}                     Novo Departamento
    Should Be Equal As Strings          ${resposta.json()["department"]["_id"]}    ${id} 
    Should Be Equal As Strings          ${resposta.json()["department"]["costCenter"]["_id"]}                  6582072531248304b069dfe5  
    Should Be Equal As Strings          ${resposta.json()["department"]["costCenter"]["costCenterName"]}       Financeiro
    Should Be Equal As Strings         ${resposta.json()["department"]["status"]}    ${FALSE}        
    Log     ${resposta.json()}
    Log     ${resposta.json()["department"]["departmentName"]}  

Listar departamento por ID erro de token 403
    ${headers}    Create Dictionary    Authorization=
    ${resposta}   GET On Session       alias=Chips    url=/api/department/   headers=${headers}    expected_status=403
    Log           ${resposta}
    Should Be Equal As Strings          ${resposta.status_code}                                                403
    Should Be Equal As Strings          ${resposta.json()["errors"]}                                           ['No token provided.']


Listar departamento por ID inválido 404
    [Arguments]    ${id_invalido}
    ${headers}     Create Dictionary    Authorization=${TOKEN}
    ${resposta}    GET On Session       alias=Chips    url=/api/department/${id_invalido}    headers=${headers}        expected_status=404
    Log     ${resposta}
    Should Be Equal As Strings          ${resposta.status_code}                                                404
    Should Be Equal As Strings          ${resposta.json()["msg"]}                                              Não foi possível encontrar o departamento com o id especificado

    Log     ${resposta.json()}
    Log     ${resposta.json()["msg"]} 

Listar total de departamentos
    ${headers}     Create Dictionary    Authorization=${TOKEN}
    ${resposta}    GET On Session       alias=Chips    url=/api/department/count    headers=${headers}        expected_status=200
    Log            ${resposta}

    Should Be Equal As Strings          ${resposta.status_code}                     200

    ${total_departamentos}    Convert To Integer    ${resposta.json()["count"]}
    Should Be True             ${total_departamentos} > 0

Listar total de departamentos com id 404
    ${headers}     Create Dictionary    Authorization=${TOKEN}
    ${resposta}    GET On Session       alias=Chips    url=/api/department/count/13245    headers=${headers}        expected_status=404
    Log            ${resposta}

    Should Be Equal As Strings          ${resposta.status_code}                                                404

Listar total de departamentos com erro 500
    ${headers}     Create Dictionary    Authorization=${TOKEN}
    ${resposta}    GET On Session       alias=Chips    url=/api/department/coun    headers=${headers}        expected_status=500
    Log            ${resposta}

    Should Be Equal As Strings          ${resposta.status_code}                                                500

Listar total dos departamentos erro de token 403
    ${headers}    Create Dictionary    Authorization=
    ${resposta}   GET On Session       alias=Chips    url=/api/department/count    headers=${headers}    expected_status=403
    Log           ${resposta}
    Should Be Equal As Strings          ${resposta.status_code}                                                403
    Should Be Equal As Strings          ${resposta.json()["errors"]}                                           ['No token provided.']

    




Listar departamento por ID inexistente 500
    ${headers}     Create Dictionary    Authorization=${TOKEN}
    ${resposta}    GET On Session       alias=Chips    url=/api/department/6582085d31248304b069dfef1   headers=${headers}        expected_status=500
    Log     ${resposta}
    Should Be Equal As Strings          ${resposta.status_code}                                                500
    Should Be Equal As Strings          ${resposta.json()["error"]}                                            CastError: Cast to ObjectId failed for value \"6582085d31248304b069dfef1\" (type string) at path \"_id\" for model \"Department"\

    Log     ${resposta.json()}
    Log     ${resposta.json()["error"]} 