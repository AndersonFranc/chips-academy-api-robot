*** Settings ***
Resource     ../resource/geral.resource
Resource     ../resource/login_user.resource
Resource     ../resource/listar_departamento.resource

*** Test Cases ***
CT01 - Listar departamentos
    Criar sessão
    Entrar com usuário sysadmin
    Listar todos os departamentos
    Listar todos os departamentos erro de token 403

CT02 - Listar departamento por ID
    Criar sessão
    Entrar com usuário sysadmin
    Listar departamento por ID    ${id_do_usuario}     
    Listar departamento por ID erro de token 403
CT02 - Listar departamento por ID inválido
    Criar sessão
    Entrar com usuário sysadmin
    Listar departamento por ID inválido 404   ${id_invalido}
    Listar departamento por ID inexistente 500
 
CT03 - Listar total de departamentos
    Criar sessão
    Entrar com usuário sysadmin
    Listar total de departamentos
    Listar total de departamentos com id 404
    Listar total de departamentos com erro 500
    Listar total dos departamentos erro de token 403