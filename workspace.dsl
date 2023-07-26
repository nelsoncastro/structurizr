// workspace (espaço de trabalho) é a construção de linguagem de nível superior e o wrapper para o model e views . 
// Um espaço de trabalho pode, opcionalmente, receber um nome e uma descrição. https://github.com/structurizr/dsl/blob/master/docs/language-reference.md#workspace
workspace "SEGUROS" "Diagramas dos sistemas de Seguros" {
   
   !identifiers hierarchical
   
   // Definição de Constantes
   
   // Shapes
   !constant SERVICE_API "Service API"
   !constant DATABASE "Database"
   
   // Protocols
   !constant SQL_TCP "SQL/TCP"
   !constant JSON_HTTPS "JSON/HTTPS"
   !constant SOAP_HTTPS "SOAP/HTTPS"
   !constant TCP_IP "TCP/IP"
   
   // Tecnologias
   !constant ORACLE "Oracle DB" 
   !constant JAVA_SPRING "Java/Spring MVC"
   
   // Cada workspace deve conter um bloco model, dentro do qual os elementos e relacionamentos são definidos.
   // https://github.com/structurizr/dsl/blob/master/docs/language-reference.md#model
   model {
      // A palavra-chave person define uma pessoa (por exemplo, um usuário, ator, função ou persona).
      // https://github.com/structurizr/dsl/blob/master/docs/language-reference.md#person
      user = person "Agente Poupex" "Usuários Unidades Atendimento" "User"
      
      // A palavra-chave group fornece uma maneira de definir um agrupamento nomeado de elementos, que será renderizado como um limite em torno desses elementos.
      // Os grupos só podem ser usados para agrupar elementos do mesmo tipo (ou seja, o mesmo nível de abstração), como segue:
      // Model => People and software systems
      // Software System => Containers
      // Container => Components
      // https://github.com/structurizr/dsl/blob/master/docs/language-reference.md#group
      group "ECOSISTEMAS DE SEGUROS" {
         
         // A palavra-chave softwareSystem define um sistema de software.
         // https://github.com/structurizr/dsl/blob/master/docs/language-reference.md#softwareSystem
         portalAssinatura = softwaresystem "Portal de Assinatura Eletrônica Poupex" "" "Existing System"
         scb = softwaresystem "SCB" "Sistema de Cobrança" "Existing System"
         spp = softwaresystem "SPP" "Sistema de Pagamento" "Existing System"
         sinistro = softwaresystem "Sinistro" "" "Existing System"
         bi = softwaresystem "BI" "" "Existing System"
         
         docusign = softwaresystem "Docusign" "Plataforma de Assiantura" "External Existing System"
         convenios = softwaresystem "Convênios" "EB/MAR/SIAPE/POUPEX" "External Existing System"
         bb = softwaresystem "BB" " " "External Existing System"
         mapfre = softwaresystem "Mapfre" "" "External Existing System"
         
         //FFA
         
         ffa = softwaresystem "FFA" "Sistema Fam Familia" "" {
            
            ffaFinService = group "FFA FINANCEIRO Service" {
               
               apiffaFin = container "FFA Financeiro API" "Permite operação sobre os dados financeiros do FFA" "${JAVA_SPRING}" {
                  tags "${SERVICE_API}"
               }
               
               container "FFA Financeiro DB" "Armazena dados financeiros do FFA" "${ORACLE}" {
                  tags "${DATABASE}"
                  apiffaFin -> this "" "${SQL_TCP}"
               }
               
               
            }            
            
            ffaAdminService = group "FFA ADMIN Service" {
               
               apiAdmin = container "FFA Admin API" "Permite operações sobre as configurações administrativas do FFA" "${JAVA_SPRING}" {
                  tags "${SERVICE_API}"
               }
               
               container "FFA Admin DB" "Armazena configurações administrativas do FFA" "${ORACLE}" {
                  tags "${DATABASE}"
                  apiAdmin -> this "" "${SQL_TCP}"
               }
            }
            
            ffaCotacaoService = group "FFA Cotação Service" {
               
               apiCotacao = container "FFA Cotação API" "Permite incluir e alterar cotações do FFA" "${JAVA_SPRING}"{
                  tags "${SERVICE_API}"
                  this -> apiAdmin "" "${JSON_HTTPS}"
               }
               
               container "FFA Cotação DB" "Armazena dados de cotações do FFA" "${ORACLE}" {
                  tags "${DATABASE}"
                  apiCotacao -> this "" "${SQL_TCP}"
               }
            }
            
            ffaPropostaService = group "FFA Proposta Service" {
               
               apiProposta = container "FFA Proposta API" "Permite incluir, cancelar, endossar propostas do FFA" "${JAVA_SPRING}"{
                  tags "${SERVICE_API}"
                  this -> apiAdmin "" "${JSON_HTTPS}"
                  this -> apiFFAFin "" "${JSON_HTTPS}"
               }
               
               container "FFA Proposta DB" "Armazena dados de propostas do FFA" "${ORACLE}" {
                  tags "${DATABASE}"
                  apiProposta -> this "" "${SQL_TCP}"
               }
            }
            
            ffaWeb = container "FFA WEB" "Prove todas as funcionalidades para as UTA's comercializarem o seguro FFA" "Angular" {
               tags "Web Browse"
               this -> apiAdmin "" "${JSON_HTTPS}"
               this -> apiCotacao "" "${JSON_HTTPS}"
               this -> apiProposta "" "${JSON_HTTPS}"
            }            
            
         }
         
         // FAM
         
         fam = softwaresystem "FAM" "Sistema de Seguro FAM" "" {
            
            
            famWeb = container "FAM WEB" "Prove todas as funcionalidades para gestão do seguro FAM" "Java/JSF" {
               tags "Web Browse"
            }
            
            famCobranca = container "FAM COBRANÇA" "Processamento em Lote" "Java/Quartz" {
               tags ""
            }
            
            famBatch = container "FAM BATCH" "Processamento em Lote" "Java/Quartz" {
               tags ""
            }
            
            famService = container "FAM SERVICE" "Permite realizar operações sobre os dados do FAM" "Java/SOAP" {
               tags ""
            }
            
            
            container "FAM DB" "Armazena dados do FAM" "${ORACLE}" {
               tags "${DATABASE}"
               famWeb -> this "Usa" "${SQL_TCP}"
               famBatch -> this "Usa" "${SQL_TCP}"
               famCobranca -> this "Usa" "${SQL_TCP}"
               famService -> this "Usa" "${SQL_TCP}"
            }
            
            
         }
         
         decessos = softwaresystem "DECESSOS" "Sistema Decessos" "" {
            
         }
         
         sse = softwaresystem "SSE" "Sistema Seguros Especiais" "" {
            
         }         
         
         softwareSystem = softwareSystem "SEGUROS" "" "Existing System"
         
      }
      
      # relationships between people and software systems
      user -> softwareSystem "usa"
      softwareSystem -> fam ""
      softwareSystem -> ffa ""
      softwareSystem -> decessos ""
      softwareSystem -> sse ""
      
      fam -> scb "usa"
      fam -> SPP "usa"
      fam -> sinistro "usa"
      
      decessos -> scb "usa"
      decessos -> SPP "usa"
      decessos -> sinistro "usa"
      
      ffa -> scb "usa"
      ffa -> SPP "usa"
      ffa -> portalAssinatura "usa"
      
      portalAssinatura -> docusign "usa"
      
      scb -> convenios "usa"
      
      spp -> bb "usa"
      
      sinistro -> mapfre "usa"
      
      fam -> bi "usa"
      decessos -> bi "usa"
      ffa -> bi "usa"
      sse -> bi "usa"
      
      bi -> mapfre "usa"
      
   }
   
   // Cada área de trabalho também pode conter uma ou mais Views, definidas com o bloco de views.
   // https://github.com/structurizr/dsl/blob/master/do!cs/language-reference.md#views
   views {
      
      systemLandscape "Seguros" {
         include *
         autolayout
      }
      
      systemContext ffa "FFA_SystemContext" {
         include *
         description "O diagrama de contexto do Sistema FAM Família"
         autoLayout
         properties {
            structurizr.groups false
         }
      }
      
      systemContext fam "FAM_SystemContext" {
         include *
         description "O diagrama de contexto do Sistema FAM"
         autoLayout
         properties {
            structurizr.groups false
         }
      }
      
      systemContext decessos "DEC_SystemContext" {
         include *
         description "O diagrama de contexto do Sistema DECESSOS"
         autoLayout
         properties {
            structurizr.groups false
         }
      }
      
      systemContext sse "SSE_SystemContext" {
         include *
         description "O diagrama de contexto do Sistema de Seguros Especiais"
         autoLayout
         properties {
            structurizr.groups false
         }
      }
      
      container ffa "Containers_FFA" "Diagrama de Container do sistema FAM Família" {
         include ->ffa.ffaAdminService->
         include ->ffa.ffaCotacaoService->
         include ->ffa.ffaPropostaService->
         include ->ffa.ffaFinService->
         autolayout
      }
      
      container fam "Containers_FAM" "Diagrama de Container do sistema FAM" {
         include ->fam.famWeb->
         include ->fam.famBatch->
         include ->fam.famCobranca->
         include ->fam.famService->
         autolayout
      }
      
      styles {
         element "Person" {
            color #ffffff
            fontSize 22
            shape Person
         }
         
         element "User" {
            background #08427b
         }
         
         element "Cliente" {
            background #999999
         }
         
         element "Bank Staff" {
            background #999999
         }
         
         element "${SERVICE_API}" {
         } 
         
         element "Software System" {
            background #1168bd
            color #ffffff
         }
         
         element "Existing System" {
            background #999999
            color #ffffff
         }
         
         element "External Existing System" {
            background #89ACFF
            color #ffffff
         }
         
         element "Container" {
            background #438dd5
            color #ffffff
         }
         
         element "Web Browse" {
            shape WebBrowser
         }
         
         element "Database" {
            shape Cylinder
         }
         
         element "Component" {
            background #85bbf0
            color #000000
         }
         
         element "Failover" {
            opacity 25
         }
      }
   }
   
}
