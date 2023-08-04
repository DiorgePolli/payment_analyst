# payment_analyst
Um estudo de caso relatando como é o fluxo de pagamento no Brasil e as possibilidades de se evitar fraudes.

# Estudo de Caso para Payment Analyst
Este é um estudo de caso que explora o fluxo de pagamento e o papel dos principais participantes em uma transação financeira, como o portador (cliente), o lojista (estabelecimento comercial), a credenciadora, os facilitadores, a bandeira e o banco emissor.

O estudo também aborda as diferenças entre adquirente, sub-adquirente e gateway de pagamento, destacando suas funções específicas no processo de transação.

É discutido o conceito de chargebacks e sua relação com fraudes, além de enfatizar a importância de preveni-los para proteger os lojistas. Dicas são oferecidas sobre como lidar com casos de chargebacks e prevenir fraudes, bem como melhorar os processos internos para garantir transações seguras.

O exemplo de resposta fornecido demonstra uma abordagem empática para lidar com um cliente que está contestando uma transação, oferecendo suporte e sugestões para resolver a disputa de chargeback.

# Análise de Dados

 O conjunto de dados contém informações sobre 3199 transações, incluindo detalhes como transaction_id, merchant_id, user_id, card_number, transaction_date, transaction_amount, device_id e has_cbk. Os valores nulos foram encontrados apenas na coluna device_id, o que pode indicar transações online.

Durante a análise superficial, foram identificados 830 transações com device_id em branco, possivelmente indicando transações online. Além disso, o campo has_cbk possui alguns valores TRUE, apontando para pedidos de chargeback anteriores, o que pode sugerir a ocorrência de fraudes prévias.

Para aprimorar a análise, informações adicionais sobre os usuários e vendedores podem ser úteis. Observar o histórico de compras do usuário, a localização (IP), o meio de compra, o horário das transações e o padrão de valor gasto podem revelar padrões de comportamento e detectar atividades suspeitas.

Quanto aos vendedores, verificar o histórico de ataques hackers, o histórico de chargebacks, o valor médio de vendas e o horário de funcionamento podem ser indicadores importantes para identificar possíveis fraudes em compras online.

Para prevenir fraudes, são sugeridas medidas como análise em tempo real de padrões de compra, estabelecer limites de valor para transações em certos horários, utilizar autenticação de 2 fatores para transações específicas, alertar sobre chargebacks e outros fatores de risco, bloquear tentativas seguidas de transações em curto espaço de tempo e incentivar a documentação das transações pelos estabelecimentos.

Essas estratégias visam proteger tanto os consumidores quanto os vendedores, garantindo transações seguras e reduzindo o risco de fraudes.

# SQL

Foi desenvolvida uma query SQL com o intuito de prever possiveis fraudes a partir dos dados fornecidos. Bloquear operações como:
- Chargeback prévio
- Fora do horário e valor predefinidos
- Multiplas operações em sequencia num tempo que o predefinido.
