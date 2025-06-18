CREATE OR REPLACE PROCEDURE PRC_ENVIA_EMAIL_ATENDIMENTO(
    pUSUARIO                         VARCHAR2,
    pSESSOES_CONCLUSAO              VARCHAR2,
    pSESSOES_REALIZADAS             VARCHAR2,
    pOPCAO_CONTINUIDADE             VARCHAR2,
    pOPCAO_ALTA_TRATAMENTO          VARCHAR2,
    pOPCAO_ALTA_DESISTENCIA         VARCHAR2,
    pTIPO_TRATAMENTO_A              VARCHAR2,
    pTIPO_TRATAMENTO_B              VARCHAR2,
    pID_ATENDIMENTO                 NUMBER
)
AS
    TEXTO                        CLOB;
    TEXTO_ASSUNTO               VARCHAR2(100);
    vNOME_PACIENTE              VARCHAR2(200);
    vIDADE_PACIENTE             VARCHAR2(20);
    vNUM_IDENTIFICACAO          VARCHAR2(100);
    vDATA_DOCUMENTO             VARCHAR2(30);

  
    vUSUARIO                    VARCHAR2(1000);
    vSESSOES_CONCLUSAO          VARCHAR2(1000);
    vSESSOES_REALIZADAS         VARCHAR2(1000);
    vOPCAO_CONTINUIDADE         VARCHAR2(1000);
    vOPCAO_ALTA_TRATAMENTO      VARCHAR2(1000);
    vOPCAO_ALTA_DESISTENCIA     VARCHAR2(1000);
    vTIPO_TRATAMENTO_A          VARCHAR2(1000);
    vTIPO_TRATAMENTO_B          VARCHAR2(1000);
    vTIPO_TRATAMENTO            VARCHAR2(1000);
    vID_ATENDIMENTO             NUMBER;
BEGIN
 
    vUSUARIO               := NVL(pUSUARIO, '');
    vSESSOES_CONCLUSAO     := NVL(pSESSOES_CONCLUSAO, '');
    vSESSOES_REALIZADAS    := NVL(pSESSOES_REALIZADAS, '');
    vOPCAO_CONTINUIDADE    := NVL(pOPCAO_CONTINUIDADE, '');
    vOPCAO_ALTA_TRATAMENTO := NVL(pOPCAO_ALTA_TRATAMENTO, '');
    vOPCAO_ALTA_DESISTENCIA:= NVL(pOPCAO_ALTA_DESISTENCIA, '');
    vTIPO_TRATAMENTO_A     := NVL(pTIPO_TRATAMENTO_A, '');
    vTIPO_TRATAMENTO_B     := NVL(pTIPO_TRATAMENTO_B, '');
    vID_ATENDIMENTO        := NVL(pID_ATENDIMENTO, 0);

    IF vOPCAO_CONTINUIDADE = 'true' OR vOPCAO_ALTA_TRATAMENTO = 'true' OR vOPCAO_ALTA_DESISTENCIA = 'true' THEN
        vTIPO_TRATAMENTO := CASE 
                              WHEN vTIPO_TRATAMENTO_A = 'true' THEN 'Tipo A'
                              WHEN vTIPO_TRATAMENTO_B = 'true' THEN 'Tipo B'
                              ELSE NULL
                            END;
    END IF;

   
    BEGIN
        SELECT P.NOME_PACIENTE,
               P.NUM_IDENTIFICACAO,
               CALCULA_IDADE(P.DATA_NASCIMENTO),
               TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS')
          INTO vNOME_PACIENTE,
               vNUM_IDENTIFICACAO,
               vIDADE_PACIENTE,
               vDATA_DOCUMENTO
          FROM ATENDIMENTOS A
    INNER JOIN PACIENTES P           ON P.ID_PACIENTE = A.ID_PACIENTE
    INNER JOIN DOCUMENTOS D          ON D.ID_ATENDIMENTO = A.ID_ATENDIMENTO
         WHERE A.ID_ATENDIMENTO = vID_ATENDIMENTO
           AND D.COD_DOCUMENTO = 9999
         ORDER BY D.DATA_CRIACAO DESC
         FETCH NEXT 1 ROWS ONLY;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            vNOME_PACIENTE := '';
            vNUM_IDENTIFICACAO := '';
            vIDADE_PACIENTE := '';
            vDATA_DOCUMENTO := '';
    END;

    -- Montagem do conteúdo do email
    IF vOPCAO_CONTINUIDADE = 'true' AND vTIPO_TRATAMENTO IS NOT NULL THEN
        TEXTO_ASSUNTO := 'Relatório de Atendimento - Continuidade';

        TEXTO := '<html><body>'||
                 '<h2>'||vNOME_PACIENTE||'</h2>'||
                     '<p><b>ID:</b> '||vNUM_IDENTIFICACAO||'</p>'||
                     '<p><b>Idade:</b> '||vIDADE_PACIENTE||'</p>'||
                     '<p><b>Sessões realizadas:</b> '||vSESSOES_REALIZADAS||'</p>'||
                     '<p><b>Sessões para conclusão:</b> '||vSESSOES_CONCLUSAO||'</p>'||
                     '<p><b>Data do documento:</b> '||vDATA_DOCUMENTO||'</p>'||
                     '<p><b>Usuário:</b> '||vUSUARIO||'</p>'||
                     '<p><b>Tipo de tratamento:</b> '||vTIPO_TRATAMENTO||'</p>'||
                     '<p><b>Status:</b> Necessita continuidade</p>'||
                 '</body></html>';
    
    ELSIF vOPCAO_ALTA_TRATAMENTO = 'true' AND vTIPO_TRATAMENTO IS NOT NULL THEN
        TEXTO_ASSUNTO := 'Relatório de Atendimento - Alta';

        TEXTO := '<html><body>'||
                     '<h2>'||vNOME_PACIENTE||'</h2>'||
                     '<p><b>ID:</b> '||vNUM_IDENTIFICACAO||'</p>'||
                     '<p><b>Idade:</b> '||vIDADE_PACIENTE||'</p>'||
                     '<p><b>Sessões realizadas:</b> '||vSESSOES_REALIZADAS||'</p>'||
                     '<p><b>Data do documento:</b> '||vDATA_DOCUMENTO||'</p>'||
                     '<p><b>Usuário:</b> '||vUSUARIO||'</p>'||
                     '<p><b>Tipo de tratamento:</b> '||vTIPO_TRATAMENTO||'</p>'||
                     '<p><b>Status:</b> Alta do tratamento</p>'||
                 '</body></html>';
    
    ELSIF vOPCAO_ALTA_DESISTENCIA = 'true' AND vTIPO_TRATAMENTO IS NOT NULL THEN
        TEXTO_ASSUNTO := 'Relatório de Atendimento - Desistência';

        TEXTO := '<html><body>'||
                     '<h2>'||vNOME_PACIENTE||'</h2>'||
                     '<p><b>ID:</b> '||vNUM_IDENTIFICACAO||'</p>'||
                     '<p><b>Idade:</b> '||vIDADE_PACIENTE||'</p>'||
                     '<p><b>Sessões realizadas:</b> '||vSESSOES_REALIZADAS||'</p>'||
                     '<p><b>Data do documento:</b> '||vDATA_DOCUMENTO||'</p>'||
                     '<p><b>Usuário:</b> '||vUSUARIO||'</p>'||
                     '<p><b>Tipo de tratamento:</b> '||vTIPO_TRATAMENTO||'</p>'||
                     '<p><b>Status:</b> Alta por desistência</p>'||
                 '</body></html>';
    END IF;


    ENVIAR_EMAIL(
        pTIPO_CONTEUDO   => 'text/html',
        pASSUNTO         => 'Documento Atendimento',
        pDEPARTAMENTO    => 'TI',
        pEMAIL_REMETENTE => 'sistema@empresa.com',
        pNOME_DESTINO    => 'Equipe Atendimento',
        pEMAIL_DESTINO   => 'equipe@empresa.com',
        pTITULO          => TEXTO_ASSUNTO,
        pCONTEUDO        => TEXTO
    );

END;
