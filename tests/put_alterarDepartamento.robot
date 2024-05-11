*** Settings ***
Resource       ../resource/data/login.robot
Resource       ../resource/geral.resource
Resource       ../resource/login_user.resource
Resource       ../resource/criar_centroDeCustos.resource
Resource       ../resource/criar_departamento.resource
Resource       ../resource/alterar_departamento.resource

*** Test Cases ***
CT01 - Alterar o novo departamento criado
    Criar sessão
    Entrar com usuário sysadmin
    Alterar o novo departamento criado
    Conferir se este departamento foi alterado corretamente

CT02 - Alterar status do departamento
    Atualizar status do departamento para ativo
    Conferir se o status do departamento foi alterado corretamente
    Tentativa de atualização de status "TRUE" 208   
    Conferir se o status do departamento foi alterado   
    Atualizar status do departamento para inativo
    Tentativa de atualização de status "FALSE" 208
    Conferir se o status de inativado do departamento foi alterado
    Atualizar status do departamento com ENDPOINT incorreto 
    Atualizar status do departamento para ativo sem o TOKEN
    Atualizar status do departamento para inativo com ID inexistente
    Atualizar status do departamento para inativo com ID em branco
    Atualizar status do departamento para inativo com ID não encontrado

CT03 - Não funcional - Alterar departamento criado
    Alterar departamento criado com mais de 50 caracteres
    Alterar o novo departamento criado com nome em branco
    Alterar departamento criado com caracteres especiais
    Alterar departamento criado sem o Centro de Custos
    Alterar um novo departamento já existente com Centro de Custo incorreto
    Alterar um departamento sem TOKEN
    Alterar Departamento com EndPoint incorreto
    Alterar Departamento com Id incorreto