# Projeto2

Este projeto consiste na implementação de um sistema de gerenciamento para uma loja de joias. O sistema foi desenvolvido para lidar com as operações de uma joalheria, incluindo gestão de clientes, fornecedores, funcionários, pedidos e estoque de joias. A implementação é baseada em um banco de dados relacional MySQL e segue boas práticas de organização e normalização de dados.

---------------------------Funcionalidades------------------------------

O sistema oferece as seguintes funcionalidades principais:

Gestão de Clientes;
Gestão de Funcionários;
Gestão de Joias;
Gestão de Fornecedores;
Gestão de Pedidos e Pagamentos.




------------------------Estrutura do Banco de Dados-------------------------


Cargo: Registra os tipos de cargo (Gerente, Vendedor).

Funcionarios: Armazena informações dos funcionários.

Gerente: Contém dados específicos de gerentes.

Cliente: Registra informações de clientes.

Fornecedor: Registra informações de fornecedores.

Tipo: Define os tipos de joias (brinco, colar, anel).

Joia: Armazena informações detalhadas sobre cada joia.

JoiaFornecedor: Relaciona fornecedores às joias que fornecem.

Pedidos: Armazena os pedidos realizados pelos clientes.

PedidoJoia: Relaciona os itens (joias) aos pedidos.

Pagamentos: Registra informações de pagamentos realizados.



--------------------Relacionamentos-------------------------

O banco de dados foi estruturado com integridade referencial, incluindo:

Relações entre Pedidos e Clientes.

Relações entre Joias e seus tipos, bem como fornecimentos.

Restrições para garantir a exclusão segura de dados vinculados.



--------------------READ---------------

Consulta de pedidos de um cliente.

Verificação do estoque de uma joia.

Consulta de todas as joias fornecidas por um fornecedor.

Listagem de todos os pedidos com status pendente.



-------------Atualizações (UPDATE)-----------

Atualização do estoque ou preço de uma joia.

Atualização do status de um pedido.

Atualização de quantidades fornecidas por fornecedores.



---------------Exclusões (DELETE)------------------

Exclusão de clientes e verificação de dependências.

Exclusão de funcionários considerando a hierarquia de cargos.



----------------Como Usar------------------

Importe os scripts SQL para seu ambiente MySQL.

Configure as credenciais no seu cliente MySQL.

Execute os comandos de criação e popularização.

Utilize os exemplos de consultas e atualizações para interagir com o banco de dados.




--------------Ferramentas Recomendadas----------------

MySQL Workbench



Caso tenha dúvidas ou sugestões sobre o projeto, entre em contato:

Nome: Hélvio Lourenço

E-mail: helvio.lourenco12@hotmail.com

