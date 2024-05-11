*** Settings ***
Resource       ../resource/data/login.robot
Resource       ../resource/geral.resource
Resource       ../resource/login_user.resource
Resource       ../resource/criar_centroDeCustos.resource
Resource       ../resource/criar_departamento.resource

*** Test Cases ***
CT01 - Criar departamento
    Criar sessão
    Entrar com usuário sysadmin
    Criar uma nova diretoria
    Cadastrar a nova diretoria criada
    Conferir se esta nova diretoria foi cadastrada corretamente
    Criar um novo centro de custos
    Cadastrar o novo centro de custos criado
    Conferir se este novo centro de custos foi cadastrado corretamente
    Criar um novo departamento
    Cadastrar o novo departamento criado
    Conferir se este novo departamento foi cadastrado corretamente

CT02 - Criar departamento não funcional
    Criar sessão
    Entrar com usuário sysadmin
    Criar uma nova diretoria
    Cadastrar a nova diretoria criada
    Conferir se esta nova diretoria foi cadastrada corretamente
    Criar um novo centro de custos
    Cadastrar o novo centro de custos criado
    Conferir se este novo centro de custos foi cadastrado corretamente
    Cadastrar o novo departamento criado com mais de 50 caracteres
    Cadastrar o novo departamento criado com nome em branco
    Cadastrar o novo departamento criado com caracteres especiais
    Cadastrar o novo departamento criado sem o Centro de Custos
    Cadastrar um novo departamento já existente
    Cadastrar um novo departamento sem TOKEN
    Cadastrar um novo Departamento com ID
   