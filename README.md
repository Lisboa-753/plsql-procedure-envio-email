# Procedure de Envio de E-mail - Relatório de Atendimento

Este projeto contém uma procedure (função no banco de dados Oracle) que envia um e-mail com informações sobre um atendimento feito a um paciente.

## Objetivo

O objetivo principal desta procedure é **automatizar o envio de relatórios** por e-mail com dados como:

- Nome do paciente
- Idade
- Identificação
- Quantidade de sessões realizadas
- Status do atendimento (continuidade, alta ou desistência)
- Usuário de preenchimento do relatório

Essas informações são mostradas em um modelo de e-mail em HTML, pronto para ser enviado.

## Como funciona

A procedure recebe alguns parâmetros com os dados do atendimento ao ser finalizado o relatório pelo profissional. Depois, ela:

1. Busca dados do paciente no banco de dados
2. Monta o conteúdo do e-mail com HTML
3. Chama uma função para enviar esse e-mail para os responsáveis

Tudo isso é feito de forma automática, sem precisar escrever o e-mail manualmente.

## Tecnologias utilizadas

- Oracle PL/SQL
- Banco de dados relacional
- HTML para formatar o e-mail

## Uso

Esta procedure pode ser útil para sistemas que:

- Registram atendimentos de pacientes
- Precisam enviar relatórios por e-mail
- Querem automatizar esse processo e ganhar tempo

---

> ⚠️ Atenção: este código é genérico e não utiliza dados reais de pacientes. Foi adaptado para fins de exemplo.

## Autor

Desenvolvido por Gabriel Lisboa 👨‍💻
