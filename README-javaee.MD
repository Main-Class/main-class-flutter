# [PROJETO] Back-End

Projeto de API para a solução **[PROJETO]**

# IMPORTANTE!
**Antes de iniciar o desenvolvimento atente-se a configuração do gitflow descrita no passo 9**

# Ambiente de Desenvolvimento

> Obs.: Recomenda-se o uso de Sistema Operacional Unix para o desenvolvimento, apesar de que a solução pode ser desenvolvida em qualquer sistema operacional.

## 1. Git

A solução de versionamento utilizada será o **Git**, que deve ser baixado no link a seguir:

[https://git-scm.com/downloads](https://git-scm.com/downloads)

> Opcionalmente, no Linux, é possível instalar utilizando a solução de gerenciados de pacotes (ex: apt-get, yum)

> Caso o sistema operacional utilizado seja Windows, após a instalação adicione o seguinte path nas variáveis de ambiente: <raiz do git>\usr\bin

## 2. Gitflow

O **gitflow** será utilizado para facilitar e padronizar o uso do git. Sua instalação pode ser feita seguindo os passos descritos no link abaixo:

[https://github.com/nvie/gitflow/wiki/Installation](https://github.com/nvie/gitflow/wiki/Installation)

## 3. Java

O **Java** é utilizado como a linguagem de programação do projeto e portanto será necesária para o desenvolvimento. Para realizar sua instalação baixe e instale a **versão 1.8 da JDK** disponível no link abaixo:

[https://www.java.com/pt-BR/download/](https://www.java.com/pt-BR/download/)

> Opcionalmente, no Linux, é possível instalar utilizando a solução de gerenciados de pacotes (ex: apt-get, yum)

## 4. Maven

O **Maven** é utilizado para estruturar os módulos do projeto e organizar as dependências utilizadas. Instale a **versão 6.3.X do Maven** pelo link a seguir:

[https://maven.apache.org/download.cgi](https://maven.apache.org/download.cgi)

## 5. Docker (opcional)

O **Docker** é utilizado para a implantação de homologação e produção. Opcionalmente pode ser utilizado para evitar o esforço de instalação e configuração do WildFly em ambiente de desenvolvimento. Para instalar o Docker, acesse o link a seguir:

[https://www.docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop)

> Opcionalmente, no Linux, é possível instalar utilizando a solução de gerenciados de pacotes (ex: apt-get, yum)

## 7. Banco de Dados (opcional)

TODO

## 6. WildFly (opcional)

Em alternativa ao Docker, o WildFly pode ser instalado e configurado localmente para facilitar o desenvolvimento. Caso seja necessário instalar, faça o download da versão *10.1.0.Final* no link abaixo:

[https://www.wildfly.org/downloads/](https://www.wildfly.org/downloads/)

Após o download, faça a configuração conforme os passos abaixo:

### 6.1 Module

Copie a estrutura de diretórios presente no repositório em docker/modules para o diretório <JBOSS_HOME>/modules do WildFly instalado. 

### 6.2 standalone.xml

Salve a versão original do arquivo <JBOSS_HOME>/standalone/configuration/standalone.xml como standalone.xml.bkp e depois copie o arquivo presente no repositório em docker/standalone.xml para o diretório <JBOSS_HOME>/standalone/configuration.

### 6.3 Banco de Dados

Após copiar o standalone.xml para o diretório de configurações do WildFly, edite-o e localise o trecho abaixo:

```xml
                <datasource jndi-name="java:/jdbc/oracle" pool-name="oraclePool" enabled="true"
                            use-java-context="true">
                    <connection-url>${env.DB_URL}</connection-url>
                    <driver>ojdbc7</driver>
                    <pool>
                        <min-pool-size>1</min-pool-size>
                        <max-pool-size>5</max-pool-size>
                        <prefill>true</prefill>
                    </pool>
                    <validation>
                        <check-valid-connection-sql>SELECT 1 FROM DUAL</check-valid-connection-sql>
                        <validate-on-match>false</validate-on-match>
                        <background-validation>false</background-validation>
                        <use-fast-fail>true</use-fast-fail>
                    </validation>
                    <security>
                        <user-name>${env.DB_USER}</user-name>
                        <password>${env.DB_PASS}</password>
                    </security>
                </datasource>
```

Substitua as expressões de variáveis pelos valores que apontarão para o banco de dados, conforme exemplo abaixo:

| Expressão      | Valor                                                                                  |
|----------------|----------------------------------------------------------------------------------------|
| ${env.DB_URL}  | URL do Banco de dados, seguindo o padrão jdbc:<sgbd>://<host>:<porta>/<banco de dados> |
| ${env.DB_USER} | usuário do banco de dados                                                              |
| ${env.DB_PASS} | senha do banco de dados                                                                | 

## 7. IDE

Para realizar o desenvolvimento será necessária uma IDE que dê suporte ao desenvolvimento de JavaEE. O projeto utiliza por padrão o IntelliJ porém não há restrições quanto ao uso de outras soluções de escolha. Abaixo seguem os links para o download e instalação das principais IDEs de mercado:

Intellij: [https://www.jetbrains.com/idea/promo/ultimate/](https://www.jetbrains.com/idea/promo/ultimate/)
Eclipse: [https://www.eclipse.org/downloads/packages/](https://www.eclipse.org/downloads/packages/)
NetBeans: [https://netbeans.org/downloads/8.2/rc/](https://netbeans.org/downloads/8.2/rc/)

## 8. Dependências

Antes de iniciar o desenvolvimento e também com o objetivo de validar a montagem do ambiente recomenda-se rodar uma construção do projeto. Para construir o projeto instalando suas dependências, acesse o diretório do projeto e execute o comando a seguir:

`mvn clean install`

## 9. Iniciando uma Feature

Antes de realizar qualquer alteração no repositório, lembre-se 
de utilizar os comandos do *gitflow* para criar uma *feature/bugifx* pra
realizar seu trabalho de forma independente.

### Para configurar o git flow, utilize o script presente em *bin/setup*

# Conclusão

Por fim, para realizar qualquer desenvolvimento entenda e alinhe primeiramente o fluxo de desenvolvimento a ser seguido.
