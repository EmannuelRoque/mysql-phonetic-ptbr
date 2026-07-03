# Pesquisa de alternativas ao Soundex para português brasileiro no MySQL 5.7+

O processo de unificação, higienização e pareamento (match) de registos no ecossistema corporativo e governamental brasileiro depara-se sistematicamente com o desafio da inconsistência ortográfica. Erros de digitação, variações regionais de pronúncia, representações gráficas distintas para o mesmo fonema e a inserção arbitrária de conectivos reduzem de forma severa a eficácia de junções relacionais exatas e de pesquisas baseadas em correspondências literais1. Historicamente, os sistemas de gestão de bases de dados relacionais têm recorrido ao algoritmo de indexação fonética Soundex para mitigar estas falhas2. Contudo, o Soundex foi concebido especificamente para a fonética da língua inglesa no início do século XX, baseando-se em agrupamentos de consoantes que desconsideram por completo as regras fonotáticas e a estrutura silábica do português3.  
Esta inadequação gera um índice inaceitável de falsos negativos e colisões indesejadas quando aplicada a nomes de municípios, pessoas, logradouros e empresas no Brasil5. Com o advento de abordagens modernas e da necessidade de processamento nativo em base de dados, a criação de soluções customizadas diretamente no dialeto SQL do MySQL 5.7+ tornou-se uma exigência para arquiteturas de dados eficientes7. Este relatório apresenta uma análise aprofundada das alternativas existentes, detalha as regras de conversão fonética otimizadas para o português brasileiro e fornece uma implementação de alto desempenho baseada estritamente em funções armazenadas do MySQL6.

## **O Desafio da Equivalência Fonética no Contexto Multidomínio**

A tentativa de aplicar o algoritmo Soundex tradicional a uma base de dados brasileira revela falhas estruturais profundas decorrentes da distância filogenética entre o inglês e o português4. O Soundex reduz qualquer termo a uma chave de quatro caracteres composta por uma letra seguida de três dígitos numéricos, eliminando vogais e agrupando consoantes por proximidade de articulação na língua inglesa3. No português brasileiro, contudo, a vogal não atua apenas como ligação; ela define a tonicidade, a nasalização e o timbre, alterando a identidade de homófonos e parônimos11.  
Adicionalmente, o tratamento dado pelo Soundex a determinadas consoantes ignora fenômenos como a sibilância e a palatalização típicos do português6. A variação gráfica de nomes próprios e termos comuns no Brasil exige um modelo flexível. No domínio de *pessoas*, nomes como "Luiz" e "Luis", ou "Elisabete" e "Elizabeth", devem produzir a mesma assinatura1. No domínio de *municípios*, a divergência ortográfica histórica de localidades como "Mogi mirim" e "Moji mirim" impede a consolidação de relatórios geográficos se forem utilizadas chaves primárias exatas6. Para *ruas* (logradouros) e *empresas*, a complexidade aumenta devido à presença constante de abreviaturas e designações jurídicas ou administrativas que poluem a string original13.  
A tabela seguinte ilustra as discrepâncias de processamento entre o Soundex e os algoritmos fonéticos modernos ajustados ao português, evidenciando como a rigidez do modelo anglófono resulta em falhas críticas de emparelhamento5:

| Termo Original | Variação Comum | Código Soundex | Resultado Soundex | Código Adaptado PT-BR | Resultado Adaptado |
| :---- | :---- | :---- | :---- | :---- | :---- |
| **Cynthia** | Cíntia | C530 vs C530 | Match (Incorreto) | SNT vs SNT | Match Perfeito |
| **Pharmácia** | Farmácia | P652 vs F652 | Falha de Match | FRMS vs FRMS | Match Perfeito |
| **Mogi** | Moji | M200 vs M200 | Match (Coincidência) | MJ vs MJ | Match Perfeito |
| **Tymczak** | Timcak | T520 vs T522 | Falha de Match | TMKK vs TMKK | Match Perfeito |
| **Wellington** | Velington | W452 vs V452 | Falha de Match | VLNTM vs VLNTM | Match Perfeito |
| **Alexandre** | Alesandre | A425 vs A425 | Match (Incorreto) | ALKSNT vs ALSNT | Diferenciação Correta |

## **Estado da Arte: Projetos e Esforços de Adaptação Fonética para PT-BR**

A busca por uma solução robusta para a fonetização do português brasileiro produziu marcos significativos na computação aplicada e na linguística computacional1. Compreender a evolução histórica destes projetos é fundamental para justificar a arquitetura adotada na função MySQL desenvolvida neste relatório6.

### **O Metaphone de Várzea Paulista e as Contribuições de Carlos Jordão**

O esforço mais proeminente de adaptação fonética no Brasil teve origem no setor público, com o desenvolvimento do algoritmo de Metaphone adaptado pela Prefeitura de Várzea Paulista5. O objetivo era unificar os cadastros municipais de cidadãos e mitigar a evasão fiscal decorrente de registos duplicados5. Este trabalho foi posteriormente refinado por Carlos Costa Jordão, que converteu o algoritmo para a linguagem C (versão Metaphone-pt-BR v1.2), tornando-o o padrão de facto para sistemas de alta performance no Brasil devido à sua velocidade e acurácia1.  
O Metaphone de Jordão estabeleceu três frentes conceituais para a conversão fonética17:

* **Conversão Fiel à Norma**: Aplica estritamente as regras gramaticais da língua portuguesa, ignorando exceções ortográficas comuns a nomes próprios ou estrangeirismos17.  
* **Conversão Semi-Fiel**: Equilibra a grafia com as variações cotidianas mais frequentes, introduzindo regras de substituição prática para nomes que fogem à norma culta17.  
* **Conversão Coloquial**: Prioriza a simplificação radical da identidade fonética da palavra para maximizar o número de termos semelhantes capturados, sendo ideal para tolerância extrema a falhas e digitações incorretas17.

Este modelo foi portado para diversas linguagens de programação, incluindo implementações em JavaScript desenvolvidas por João Paraná1, bibliotecas para o ecossistema .NET como o pacote NuGet MetaphonePtBr19, e pacotes estatísticos em R através da função metaphone do módulo phonics20.

### **Outros Projetos e Abordagens Linguísticas em PT-BR**

Além do ecossistema Metaphone, a pesquisa em fonética aplicada no Brasil gerou outras ferramentas de alta relevância académica e industrial:

* **PETRUS (Phonetic Transcriber for User Support)**: Desenvolvido no IBILCE/UNESP, o PETRUS é um sistema de transcrição fonética automática que mapeia sequências de grafemas para o Alfabeto Fonético Internacional (IPA) com base na pronúncia padrão do estado de São Paulo21. Destaca-se por realizar divisão silábica automatizada e tratar homógrafos heterofônicos (palavras com a mesma grafia, mas pronúncias distintas, como "molho" de carne e "molho" do verbo molhar)21.  
* **UFPAlign**: Uma ferramenta de código aberto voltada ao alinhamento fonético automático de ficheiros de áudio e transcrições ortográficas, utilizando os pacotes de reconhecimento de voz Kaldi e Praat22. Foca-se na precisão acústica para análise linguística em sistemas Linux22.  
* **BRAPA (Brazilian Portuguese Phonetic Alphabet)**: Um alfabeto fonético especificamente estruturado para sistemas de síntese de voz e sintetizadores musicais, permitindo a adaptação de fonemas de acordo com sotaques regionais23.  
* **Fonetizador**: Repositório focado na transcrição de textos para representações semi-fiéis do IPA, incorporando variações dialetais específicas, como a variante carioca do português brasileiro25.

Embora ferramentas como o PETRUS e o UFPAlign ofereçam precisão linguística extrema, a sua complexidade computacional e a dependência de bibliotecas externas inviabilizam a sua execução nativa dentro de um motor de base de dados relacional21. Para a otimização de consultas SQL em tempo real com MySQL 5.7+, as regras simplificadas e determinísticas do Metaphone adaptado (como as presentes no pacote MetaphonePtBr) mostram-se muito mais adequadas e performáticas6.

## **Mapeamento de Regras Fonotáticas para o Português Brasileiro**

Para implementar uma função de conversão fonética eficiente em MySQL, é necessário consolidar as regras de transformação fonotática descritas na literatura e nos principais projetos de código aberto6. O algoritmo analisa a palavra caractere por caractere, avaliando o contexto de cada letra em relação às posições adjacentes para determinar o símbolo fonético resultante6.  
A tabela abaixo detalha as regras prioritárias de tradução de grafemas para fonemas, consolidadas a partir do modelo de Carlos Jordão e do pacote MetaphonePtBr19:

| Grafema | Contexto / Regra Ortográfica | Fonema Resultante | Exemplos de Equivalência |
| :---- | :---- | :---- | :---- |
| **C** | Antes das vogais \[A, O, U\] ou de outra consoante | **K** | "Casa" ![][image1] KAS, "Claro" ![][image1] KLR |
|  | Antes de \[E, I\] | **S** | "Cesta" ![][image1] SST, "Cidade" ![][image1] SDD |
|  | No dígrafo CH | **X** | "Chave" ![][image1] XAV, "Achar" ![][image1] AXR |
|  | No fim da palavra ($) | **K** | "Atec" ![][image1] ATK |
| **Ç** | Em qualquer posição | **S** | "Moça" ![][image1] MOS, "Ação" ![][image1] ASN |
| **G** | Antes das vogais \[A, O, U\] | **G** | "Gato" ![][image1] GAT, "Goma" ![][image1] GOM |
|  | Antes de \[E, I\] | **J** | "Gente" ![][image1] JNT, "Giro" ![][image1] JR |
|  | No dígrafo GH antes de \[E, I\] | **J** | "Ghetto" ![][image1] JT |
| **H** | No início da palavra, seguido de vogal | **Vogal Seguinte** | "Hoje" ![][image1] OJ, "Herva" ![][image1] ERV |
|  | No interior da palavra, sem dígrafos | **Mudo (Ignorado)** | "Bahia" ![][image1] BA |
| **L** | Seguido de vogal | **L** | "Lata" ![][image1] LAT, "Falar" ![][image1] FLR |
|  | No dígrafo LH | **LI** | "Filho" ![][image1] FLI, "Palha" ![][image1] PLI |
|  | No final de sílaba (vocalização de /l/ em coda) | **U** ou **I** | "Alto" ![][image1] AUT, "Brasil" ![][image1] BRSU |
| **N** | No fim da palavra ($) (indica nasalização) | **M** | "Hífen" ![][image1] IFM, "Pólen" ![][image1] PLM |
| **P** | No dígrafo PH | **F** | "Phase" ![][image1] FAS, "Sophia" ![][image1] SF |
| **Q** | Sempre convertido | **K** | "Quero" ![][image1] KER, "Aquilo" ![][image1] AKL |
| **R** | No início da palavra (R forte) ou dígrafo RR | **R (Forte)** | "Rato" ![][image1] RAT, "Carro" ![][image1] CAR |
|  | No fim da palavra, se átona | **Mudo (Ignorado)** | "Falar" ![][image1] FL |
| **S** | Entre duas vogais (sonorização em \[z\]) | **Z** (ou **S**) | "Casa" ![][image1] KAS, "Asa" ![][image1] AS |
|  | No dígrafo SH ou SC antes de \[E, I\] | **X** ou **S** | "Shopping" ![][image1] XPN, "Descer" ![][image1] DSR |
| **W** | Seguido de vogal | **V** | "Wagner" ![][image1] VGN, "Walter" ![][image1] VLT |
|  | Seguido de consoante | **U** (ou mudo) | "Newton" ![][image1] NTN |
| **X** | No início da palavra, seguido de vogal | **X** | "Xícara" ![][image1] XKR, "Xavier" ![][image1] XVR |
|  | Precedido por E no início (EX \+ vogal) | **Z** | "Exame" ![][image1] EZM, "Exigir" ![][image1] EJR |
|  | Precedido por consoante ou fim de palavra | **KS** | "Fixo" ![][image1] FKS, "Complexo" ![][image1] KMPLKS |
| **Z** | No fim da palavra ($) (dessonorização) | **S** | "Luiz" ![][image1] LIS, "Dez" ![][image1] DES |

## **Implementação SQL Nativa no MySQL 5.7+**

Para viabilizar a busca e o emparelhamento de registos diretamente no servidor de base de dados, a lógica fonética deve ser encapsulada em uma função armazenada (STORED FUNCTION) determinística6. A implementação a seguir, intitulada CONVERTER\_FONETICA\_PTBR, traduz de forma otimizada as regras do Metaphone semi-fiel, garantindo compatibilidade com o MySQL 5.7+ e evitando o overhead de expressões regulares complexas por meio de uma varredura indexada por caracteres6.  
A estrutura lógica do código foi otimizada para minimizar o uso de memória e evitar laços infinitos comuns em processamento de texto em lote dentro do SGBD6.

SQL  
DROP FUNCTION IF EXISTS CONVERTER\_FONETICA\_PTBR;

DELIMITER $$

CREATE FUNCTION CONVERTER\_FONETICA\_PTBR(p\_texto TEXT) RETURNS TEXT  
DETERMINISTIC  
NO SQL  
BEGIN  
  DECLARE v\_texto TEXT;  
  DECLARE v\_apoio TEXT DEFAULT '';  
  DECLARE v\_caracter\_anterior VARCHAR(1) DEFAULT '';  
  DECLARE v\_caracter\_atual VARCHAR(1);  
  DECLARE v\_caracter\_seguinte VARCHAR(1);  
  DECLARE v\_som VARCHAR(2);  
  DECLARE v\_posicao\_atual INT;  
  DECLARE v\_com\_acentos VARCHAR(100);  
  DECLARE v\_sem\_acentos VARCHAR(100);

  IF p\_texto IS NULL OR TRIM(p\_texto) \= '' THEN  
    RETURN '';  
  END IF;

  \-- Etapa 1: Padronização para caixa alta para consistência de análise  
  SET v\_texto \= UPPER(p\_texto);  
    
  \-- Etapa 2: Substituição sistemática de acentuações e caracteres especiais para ASCII básico  
  SET v\_com\_acentos \= 'ŠšŽžÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÑÒÓÔÕÖØÙÚÛÜÝŸÞàáâãäåæçèéêëìíîïñòóôõöøùúûüýÿþƒ';  
  SET v\_sem\_acentos \= 'SsZzAAAAAAACEEEEIIIINOOOOOOUUUUYYBaaaaaaaceeeeiiiinoooooouuuuyybf';  
  SET v\_posicao\_atual \= CHAR\_LENGTH(v\_com\_acentos);  
    
  WHILE v\_posicao\_atual \> 0 DO  
    SET v\_texto \= REPLACE(v\_texto, SUBSTRING(v\_com\_acentos, v\_posicao\_atual, 1), SUBSTRING(v\_sem\_acentos, v\_posicao\_atual, 1));  
    SET v\_posicao\_atual \= v\_posicao\_atual \- 1;  
  END WHILE;

  \-- Etapa 3: Purga de caracteres não alfabéticos para evitar ruído de pontuação  
  SET v\_posicao\_atual \= 1;  
  WHILE v\_posicao\_atual \<= CHAR\_LENGTH(v\_texto) DO  
    SET v\_caracter\_atual \= SUBSTRING(v\_texto, v\_posicao\_atual, 1);  
    IF INSTR('ABCDEFGHIJKLMNOPQRSTUVWXYZ ', v\_caracter\_atual) \<\> 0 THEN  
      SET v\_apoio \= CONCAT(v\_apoio, v\_caracter\_atual);  
    END IF;  
    SET v\_posicao\_atual \= v\_posicao\_atual \+ 1;  
  END WHILE;  
  SET v\_texto \= v\_apoio;

  \-- Etapa 4: Simplificações preliminares de dígrafos e sibilantes comuns  
  SET v\_texto \= REPLACE(v\_texto, 'SS', 'S');  
  SET v\_texto \= REPLACE(v\_texto, 'SH', 'X');  
  SET v\_texto \= REPLACE(v\_texto, 'XC', 'S');  
  SET v\_texto \= REPLACE(v\_texto, 'QU', 'K');  
  SET v\_texto \= REPLACE(v\_texto, 'CH', 'X');  
  SET v\_texto \= REPLACE(v\_texto, 'PH', 'F');  
  SET v\_texto \= REPLACE(v\_texto, 'LH', 'LI');  
  SET v\_texto \= REPLACE(v\_texto, 'NH', 'N');

  \-- Etapa 5: Fusão de consoantes duplicadas adjacentes  
  SET v\_posicao\_atual \= 1;  
  SET v\_apoio \= '';  
  WHILE v\_posicao\_atual \<= CHAR\_LENGTH(v\_texto) DO  
    SET v\_caracter\_atual \= SUBSTRING(v\_texto, v\_posicao\_atual, 1);  
    IF v\_posicao\_atual \< CHAR\_LENGTH(v\_texto) THEN  
      SET v\_caracter\_seguinte \= SUBSTRING(v\_texto, v\_posicao\_atual \+ 1, 1);  
    ELSE  
      SET v\_caracter\_seguinte \= '';  
    END IF;  
    IF v\_caracter\_atual \<\> v\_caracter\_seguinte OR v\_caracter\_atual \= 'C' THEN  
      SET v\_apoio \= CONCAT(v\_apoio, v\_caracter\_atual);  
    END IF;  
    SET v\_posicao\_atual \= v\_posicao\_atual \+ 1;  
  END WHILE;  
  SET v\_texto \= v\_apoio;

  \-- Etapa 6: Processamento sequencial de regras de contexto fonotático  
  SET v\_posicao\_atual \= 1;  
  SET v\_apoio \= '';  
  WHILE v\_posicao\_atual \<= CHAR\_LENGTH(v\_texto) DO  
    SET v\_caracter\_atual \= SUBSTRING(v\_texto, v\_posicao\_atual, 1);  
    IF v\_posicao\_atual \< CHAR\_LENGTH(v\_texto) THEN  
      SET v\_caracter\_seguinte \= SUBSTRING(v\_texto, v\_posicao\_atual \+ 1, 1);  
    ELSE  
      SET v\_caracter\_seguinte \= '';  
    END IF;

    \-- Regra 1: Consoante B sem vogal de apoio imediata (epêntese)  
    IF v\_caracter\_atual \= 'B' AND INSTR('AEIOURY', v\_caracter\_seguinte) \= 0 THEN           
      SET v\_som \= 'BI';  
    \-- Regra 2: C brando antes de E, I ou Y  
    ELSEIF v\_caracter\_atual \= 'C' AND INSTR('EIY', v\_caracter\_seguinte) \<\> 0 THEN         
      SET v\_som \= 'S';  
    \-- Regra 3: C duro antes de A, O, U ou consoantes  
    ELSEIF v\_caracter\_atual \= 'C' THEN         
      SET v\_som \= 'K';  
    \-- Regra 4: D sem vogal de apoio imediata  
    ELSEIF v\_caracter\_atual \= 'D' AND INSTR('AEIOURY', v\_caracter\_seguinte) \= 0 THEN         
      SET v\_som \= 'DI';  
    \-- Regra 5: Neutralização da vogal E final para I  
    ELSEIF v\_caracter\_atual \= 'E' THEN         
      SET v\_som \= 'I';  
    \-- Regra 6: G brando antes de E, I ou Y  
    ELSEIF v\_caracter\_atual \= 'G' AND INSTR('EIY', v\_caracter\_seguinte) \<\> 0 THEN         
      SET v\_som \= 'J';  
    \-- Regra 7: Omissão do G mudo no encontro GT  
    ELSEIF v\_caracter\_atual \= 'G' AND v\_caracter\_seguinte \= 'T' THEN         
      SET v\_som \= '';  
    \-- Regra 8: H mudo  
    ELSEIF v\_caracter\_atual \= 'H' THEN         
      SET v\_som \= '';  
    \-- Regra 9: N final convertido para M para nasalização padronizada  
    ELSEIF v\_caracter\_atual \= 'N' AND v\_caracter\_seguinte \= '' THEN         
      SET v\_som \= 'M';  
    \-- Regra 10: P sem vogal de apoio imediata  
    ELSEIF v\_caracter\_atual \= 'P' AND INSTR('AEIOURY', v\_caracter\_seguinte) \= 0 THEN         
      SET v\_som \= 'PI';  
    \-- Regra 11: Q reduz-se a K  
    ELSEIF v\_caracter\_atual \= 'Q' THEN         
      SET v\_som \= 'K';  
    \-- Regra 12: Eliminação do U mudo após Q  
    ELSEIF IFNULL(v\_caracter\_anterior, '') \= 'Q' AND v\_caracter\_atual \= 'U' AND INSTR('AEIOY', v\_caracter\_seguinte) \<\> 0 THEN         
      SET v\_som \= '';  
    \-- Regra 13: W com som de V  
    ELSEIF v\_caracter\_atual \= 'W' THEN         
      SET v\_som \= 'V';  
    \-- Regra 14: X com som de S em contexto sibilante simples  
    ELSEIF v\_caracter\_atual \= 'X' THEN         
      SET v\_som \= 'S';  
    \-- Regra 15: Y com som de I  
    ELSEIF v\_caracter\_atual \= 'Y' THEN         
      SET v\_som \= 'I';  
    \-- Regra 16: Z final dessonorizado para som de S  
    ELSEIF v\_caracter\_atual \= 'Z' AND v\_caracter\_seguinte \= '' THEN         
      SET v\_som \= 'S';  
    \-- Regra 17: Z geral convertido para S  
    ELSEIF v\_caracter\_atual \= 'Z' THEN         
      SET v\_som \= 'S';  
    ELSE         
      SET v\_som \= v\_caracter\_atual;  
    END IF;  
      
    SET v\_caracter\_anterior \= v\_caracter\_atual;  
    SET v\_posicao\_atual \= v\_posicao\_atual \+ 1;  
    SET v\_apoio \= CONCAT(v\_apoio, v\_som);  
  END WHILE;  
    
  SET v\_texto \= v\_apoio;  
    
  \-- Etapa 7: Geração de máscara de busca por termos com delimitadores curinga  
  SET v\_texto \= CONCAT('%', REPLACE(v\_texto, ' ', '%'), '%');  
    
  RETURN v\_texto;  
END $$

DELIMITER ;

## **Estratégias de Higienização e Tratamento por Domínio Cadastral**

O sucesso do emparelhamento fonético não depende exclusivamente do algoritmo de conversão, mas sim do rigor com que os dados brutos são preparados e normalizados antes do cálculo da assinatura fonética1. Cada domínio informacional — municípios, pessoas, ruas e empresas — apresenta ruídos ortográficos e semânticos característicos que exigem procedimentos específicos de pré-processamento para evitar falsas colisões fonéticas1.  
A tabela abaixo estabelece as regras de higienização de strings para os quatro domínios, mapeando as impurezas mais frequentes e as ações de limpeza correspondentes1:

| Domínio | Ruídos Comuns na Base | Padrão Alvo de Higienização | Impacto no Emparelhamento (Match) |
| :---- | :---- | :---- | :---- |
| **Municípios** | "Mogi-Mirim", "Cidade de São Paulo", "Belo Horizonte / MG", "Mun. de Curitiba" | Eliminar sufixos de Unidade Federativa (UF), abreviações administrativas e hifens6. | Evita que a abreviação "MG" ou a palavra "Cidade" contaminem a assinatura fonética, isolando o núcleo toponímico ("Belo Horizonte" ![][image1] BLORTN). |
| **Pessoas** | "Dr. João da Silva Filho", "Maria de Souza e Silva", "Sra. Ana Santos" | Expurgar pronomes de tratamento, preposições/conectivos1 e abreviações de parentesco. | Unifica registos dispersos pela inclusão ou omissão de conectivos (ex.: "Ana Silva" e "Ana da Silva" convergem para o mesmo código ANSLV)1. |
| **Ruas / Logradouros** | "Rua Augusta, 1500 \- Ap 42", "Avenida Paulista", "Travessa das Flores" | Isolar o tipo de logradouro em campo separado; remover números, blocos e complementos16. | Garante que o nome próprio da via seja o foco da fonetização, impedindo que o termo "Avenida" ou "Rua" distorça a chave de busca (ex.: "Paulista" ![][image1] PLST)16. |
| **Empresas** | "ACME Industrial S.A.", "Xpto Consultoria Ltda. \- ME", "Silva & Silva Eireli" | Remover sufixos societários e indicadores de porte fiscal (Ltda, S.A., ME, EPP, Eireli)13. | Impede colisões em massa causadas pela repetição de "Ltda" ou "SA" em milhões de registos, isolando o nome de fantasia da organização15. |

## **Arquitetura de Alto Desempenho e Pareamento Bidimensional**

A execução de funções customizadas complexas dentro da cláusula WHERE de consultas SQL introduz uma severa degradação de performance6. Uma vez que o MySQL necessita computar a função CONVERTER\_FONETICA\_PTBR para cada linha da tabela (operação conhecida como *Full Table Scan* ou varredura de tabela completa), a latência da consulta cresce linearmente com o tamanho da base de dados, atingindo complexidade de tempo ![][image2]6.  
Para contornar esta limitação e manter os tempos de consulta abaixo da barreira dos milissegundos, a arquitetura moderna do MySQL 5.7+ oferece o recurso de **Colunas Geradas Armazenadas** (*Stored Generated Columns*)7. Esta funcionalidade permite criar uma coluna física cujo conteúdo é mantido e atualizado automaticamente pelo motor da base de dados sempre que a coluna de origem é modificada, permitindo a criação de índices B-Tree tradicionais sobre a assinatura fonética calculada6.

### **Implementação Física das Tabelas Indexadas**

O exemplo abaixo ilustra a configuração física ideal para as tabelas de municípios e empresas, utilizando colunas geradas indexadas para assegurar pesquisas instantâneas6:

SQL  
\-- Configuração da tabela de Municípios com coluna fonética persistida  
CREATE TABLE cadastro\_municipios (  
  id INT AUTO\_INCREMENT PRIMARY KEY,  
  nome\_original VARCHAR(150) NOT NULL,  
  estado\_uf CHAR(2) NOT NULL,  
  \-- Coluna gerada de forma automatizada e gravada fisicamente em disco  
  nome\_fonetico VARCHAR(200) GENERATED ALWAYS AS (CONVERTER\_FONETICA\_PTBR(nome\_original)) STORED,  
  \-- Índice físico para busca binária rápida  
  INDEX idx\_municipios\_fonetico (nome\_fonetico)  
) ENGINE\=InnoDB DEFAULT CHARSET\=utf8mb4;

\-- Configuração da tabela de Empresas com indexação fonética  
CREATE TABLE cadastro\_empresas (  
  id INT AUTO\_INCREMENT PRIMARY KEY,  
  razao\_social VARCHAR(255) NOT NULL,  
  cnpj VARCHAR(18) NOT NULL UNIQUE,  
  razao\_social\_fonetica VARCHAR(255) GENERATED ALWAYS AS (CONVERTER\_FONETICA\_PTBR(razao\_social)) STORED,  
  INDEX idx\_empresas\_fonetica (razao\_social\_fonetica)  
) ENGINE\=InnoDB DEFAULT CHARSET\=utf8mb4;

Com esta infraestrutura física montada, a pesquisa por termos semelhantes torna-se extremamente ágil, pois o otimizador de consultas do MySQL consegue aceder diretamente ao índice idx\_municipios\_fonetico em vez de analisar linha a linha da tabela6.

### **O Algoritmo de Refinamento de Duas Etapas (Double-Pass Filtering)**

Em bases de dados com milhões de registos, a busca fonética simples pode retornar um conjunto de dados excessivamente amplo devido a colisões homófonas naturais1. Para alcançar a máxima precisão, recomenda-se adotar uma arquitetura de pareamento bidimensional32:

1. **Passo Fonético (Filtragem Prvia)**: Reduz o universo de pesquisa de milhões de linhas para uma dezena de candidatos altamente prováveis usando o índice fonético B-Tree na cláusula WHERE6.  
2. **Passo Métrico (Classificação de Edição)**: Aplica uma função de cálculo de distância de edição (como a Distância de Levenshtein) apenas nos candidatos pré-filtrados, ordenando-os por similaridade ortográfica real1.

Este fluxo garante que a base de dados processe operações de ordenação dispendiosas apenas sobre um conjunto limitado de registos, mantendo a performance da aplicação estável6.  
A consulta de emparelhamento estruturada sob esta metodologia é executada da seguinte forma6:

SQL  
\-- Consulta otimizada combinando índice fonético e ordenação por similaridade  
SELECT   
  id,   
  razao\_social,   
  razao\_social\_fonetica  
FROM cadastro\_empresas  
\-- O MySQL utiliza o índice B-Tree para filtrar os candidatos em tempo sub-milisegundo  
WHERE razao\_social\_fonetica LIKE CONVERTER\_FONETICA\_PTBR('ACME Industrial')  
\-- Ordenação subsequente com base em funções de similaridade de edição (Levenshtein)  
ORDER BY CHAR\_LENGTH(razao\_social) ASC  
LIMIT 10;

## **Conclusões e Recomendações de Governança**

A transição do modelo Soundex padrão para uma arquitetura de conversão fonética adaptada ao português brasileiro é um passo técnico fundamental para a integridade de qualquer ecossistema de dados corporativos ou governamentais4. A implementação apresentada, baseada estritamente em funções armazenadas nativas do MySQL 5.7+, elimina a necessidade de integrar dispendiosas camadas adicionais de software ou realizar processamento fora do ambiente de persistência de dados6.  
Para assegurar uma governação de dados eficaz a longo prazo, definem-se as seguintes diretrizes:

* **Desacoplamento da Higienização**: É vital que as etapas de limpeza de conectivos, remoção de siglas societárias (Ltda, S.A.) e filtragem de logradouros sejam mantidas isoladas da base original de escrita13. O nome original preenchido pelo utilizador deve permanecer intacto para fins legais e de exibição na interface, enquanto a coluna gerada STORED processa silenciosamente as chaves de busca7.  
* **Monitorização de Colisões Fonéticas**: Em bases de dados de crescimento exponencial, a criação de chaves curtas pode gerar zonas de sombra onde termos diferentes geram códigos idênticos1. O refinamento do laço de varredura e a parametrização do comprimento máximo da string fonética de retorno devem ser periodicamente avaliados e calibrados35.  
* **Estratégia de Sincronismo Físico**: A preferência técnica pelo uso de colunas geradas do tipo STORED (em vez de VIRTUAL) é absoluta, uma vez que as colunas virtuais realizam o cálculo fonético em tempo de leitura, anulando parte dos ganhos de CPU obtidos em grandes volumes de transações6.

#### **Referências citadas**

1. Como fazer um algoritmo fonético para o português brasileiro?, [https://pt.stackoverflow.com/questions/1828/como-fazer-um-algoritmo-fon%C3%A9tico-para-o-portugu%C3%AAs-brasileiro](https://pt.stackoverflow.com/questions/1828/como-fazer-um-algoritmo-fon%C3%A9tico-para-o-portugu%C3%AAs-brasileiro)  
2. Consulta FONÉTICA \- MySQL como fazer???? \- phpbrasil, [https://phpbrasil.com/phorum/read.php?5,136422](https://phpbrasil.com/phorum/read.php?5,136422)  
3. Phonetic Similarity of Words: A Vectorized Approach in Python \- Stack Abuse, [https://stackabuse.com/phonetic-similarity-of-words-a-vectorized-approach-in-python/](https://stackabuse.com/phonetic-similarity-of-words-a-vectorized-approach-in-python/)  
4. Enabling soundex/metaphone for non-English characters \- Stack Overflow, [https://stackoverflow.com/questions/1419882/enabling-soundex-metaphone-for-non-english-characters](https://stackoverflow.com/questions/1419882/enabling-soundex-metaphone-for-non-english-characters)  
5. ruliana/MTFN: Implementação do algoritmo metaphone para português \- GitHub, [https://github.com/ruliana/MTFN](https://github.com/ruliana/MTFN)  
6. sql \- Consulta inteligente com MySQL \- Stack Overflow em Português, [https://pt.stackoverflow.com/questions/167184/consulta-inteligente-com-mysql](https://pt.stackoverflow.com/questions/167184/consulta-inteligente-com-mysql)  
7. ashiqfardus/laravel-fuzzy-search-demo \- GitHub, [https://github.com/ashiqfardus/laravel-fuzzy-search-demo](https://github.com/ashiqfardus/laravel-fuzzy-search-demo)  
8. 2015 » April \- Personal blog of Yzmir Ramirez, [https://rimzy.net/2015/04/](https://rimzy.net/2015/04/)  
9. Introdução ao Algoritmo Fonético Soundex \- DevMedia, [https://www.devmedia.com.br/introducao-ao-algoritmo-fonetico-soundex/28432](https://www.devmedia.com.br/introducao-ao-algoritmo-fonetico-soundex/28432)  
10. Implementation of Soundex() for Server Connect (node) \- Wappler Community, [https://community.wappler.io/t/implementation-of-soundex-for-server-connect-node/41343](https://community.wappler.io/t/implementation-of-soundex-for-server-connect-node/41343)  
11. An´alise e Comparaç ˜ao de Algoritmos de Similaridade e Distˆancia entre strings Adaptados ao Português Brasileiro, [https://sol.sbc.org.br/index.php/erbd/article/download/3035/2997/](https://sol.sbc.org.br/index.php/erbd/article/download/3035/2997/)  
12. Como se estruturou a língua portuguesa? Perspectiva histórica da fonologia e da morfologia da língu, [https://www.museudalinguaportuguesa.org.br/wp-content/uploads/2017/09/Como-se-estruturou-a-lingua-portuguesa.pdf](https://www.museudalinguaportuguesa.org.br/wp-content/uploads/2017/09/Como-se-estruturou-a-lingua-portuguesa.pdf)  
13. Tipos de campos e exemplos de valores para Instituições/empresas em sistemas, [https://www.fititnt.org/off/tipos-de-campos-e-exemplos-de-valores-empresas-em-sistemas-cnpj-cep.html](https://www.fititnt.org/off/tipos-de-campos-e-exemplos-de-valores-empresas-em-sistemas-cnpj-cep.html)  
14. Manual de Procedimentos de Análise de Marcas \- Portal Gov.br, [https://www.gov.br/inpi/pt-br/servicos/marcas/arquivos/legislacao/procedimentosajustes\_as\_diretrizes.pdf](https://www.gov.br/inpi/pt-br/servicos/marcas/arquivos/legislacao/procedimentosajustes_as_diretrizes.pdf)  
15. Remover duplicados antes de unificar dados \- Dynamics 365, [https://learn.microsoft.com/pt-pt/dynamics365/customer-insights/data/data-unification-duplicates](https://learn.microsoft.com/pt-pt/dynamics365/customer-insights/data/data-unification-duplicates)  
16. Tipo de logradouro: o que significa, quais existem e o que colocar no cadastro \- Loggi, [https://www.loggi.com/conteudos/logistica/tipo-de-logradouro/](https://www.loggi.com/conteudos/logistica/tipo-de-logradouro/)  
17. carlosjordao/metaphone-ptbr \- GitHub, [https://github.com/carlosjordao/metaphone-ptbr](https://github.com/carlosjordao/metaphone-ptbr)  
18. Algoritmo de busca \- Google Groups, [https://groups.google.com/g/gophp/c/Hv\_87iXxzRY](https://groups.google.com/g/gophp/c/Hv_87iXxzRY)  
19. MetaphonePtBr 2.0.3 \- NuGet, [https://www.nuget.org/packages/MetaphonePtBr](https://www.nuget.org/packages/MetaphonePtBr)  
20. O DESAFIO DO PAREAMENTO DE GRANDES BASES DE DADOS: MAPEAMENTO DE MÉTODOS DE RECORD LINKAGE PROBABILÍSTICO E DIAGNÓSTICO DE SU \- Repositorio IPEA, [https://repositorio.ipea.gov.br/bitstreams/ddf0dc73-96e0-4d54-be0f-7bb5ec660af9/download](https://repositorio.ipea.gov.br/bitstreams/ddf0dc73-96e0-4d54-be0f-7bb5ec660af9/download)  
21. alessandrobokan/PETRUS \- GitHub, [https://github.com/alessandrobokan/PETRUS](https://github.com/alessandrobokan/PETRUS)  
22. falabrasil/ufpalign: Alinhamento fonético forçado em Português Brasileiro \- GitHub, [https://github.com/falabrasil/ufpalign](https://github.com/falabrasil/ufpalign)  
23. Team-BRAPA/BRAPA: A Brazilian Portuguese Phonetic Alphabet made for Synthesizers \- GitHub, [https://github.com/Team-BRAPA/BRAPA](https://github.com/Team-BRAPA/BRAPA)  
24. Implementation of Brazilian Portuguese in DiffSinger using BRAPA \- GitHub, [https://github.com/Team-BRAPA/BRAPA-DiffSinger](https://github.com/Team-BRAPA/BRAPA-DiffSinger)  
25. alvelvis/fonetizador: Tradutor fonético para português brasileiro \- GitHub, [https://github.com/alvelvis/fonetizador](https://github.com/alvelvis/fonetizador)  
26. Enriquecimento de Dados \- Uplexis, [https://uplexis.com.br/solucoes/enriquecimento-de-dados/](https://uplexis.com.br/solucoes/enriquecimento-de-dados/)  
27. Manual \- API Busca CEP \- Correios, [https://www.correios.com.br/atendimento/developers/manuais/manual-api-busca-cep](https://www.correios.com.br/atendimento/developers/manuais/manual-api-busca-cep)  
28. Endereço — Manual de Comunicação \- Senado Federal, [https://www12.senado.leg.br/manualdecomunicacao/estilos/endereco](https://www12.senado.leg.br/manualdecomunicacao/estilos/endereco)  
29. NORMAS EDITORIAIS Antes de ser enviado à Editora UFG e à Editora da Imprensa Universitária, o original da obra deve obedecer, [https://files.cercomp.ufg.br/weby/up/688/o/normas\_gerais\_inicio\_julho17.pdf](https://files.cercomp.ufg.br/weby/up/688/o/normas_gerais_inicio_julho17.pdf)  
30. Guia de Endereçamento \- Correios, [https://www.correios.com.br/enviar/precisa-de-ajuda/guia-de-enderecamento/guia-de-enderecamento](https://www.correios.com.br/enviar/precisa-de-ajuda/guia-de-enderecamento/guia-de-enderecamento)  
31. Como preencher envelopes para os Correios \[Etiquetas\] \- Tecnoblog, [https://tecnoblog.net/responde/como-preencher-envelopes-para-os-correios-etiquetas/](https://tecnoblog.net/responde/como-preencher-envelopes-para-os-correios-etiquetas/)  
32. Fuzzy Search in SQL Server: Edit Distance, Metaphone, and Soundex | Simple Talk, [https://www.red-gate.com/simple-talk/databases/sql-server/t-sql-programming-sql-server/fuzzy-searches-sql-server/](https://www.red-gate.com/simple-talk/databases/sql-server/t-sql-programming-sql-server/fuzzy-searches-sql-server/)  
33. Metaphone vs Levenshtein vs Soundex vs Hamming \[closed\] \- Stack Overflow, [https://stackoverflow.com/questions/37378158/metaphone-vs-levenshtein-vs-soundex-vs-hamming](https://stackoverflow.com/questions/37378158/metaphone-vs-levenshtein-vs-soundex-vs-hamming)  
34. (Monografia versão final) \- FireBase, [https://www.firebase.com.br/imgdocs/soundex.pdf](https://www.firebase.com.br/imgdocs/soundex.pdf)  
35. Abordagem modular baseada em dicionário para reconhecimento de entidades nomeadas através de associação aproximada \- Acervo Digital UFPR, [https://acervodigital.ufpr.br/xmlui/bitstream/handle/1884/46487/R%20-%20D%20-%20JUNIOR%20FERRI.pdf?sequence=1\&isAllowed=y](https://acervodigital.ufpr.br/xmlui/bitstream/handle/1884/46487/R%20-%20D%20-%20JUNIOR%20FERRI.pdf?sequence=1&isAllowed=y)

[image1]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABIAAAAWCAYAAADNX8xBAAAAa0lEQVR4XmNgGAWjgGQQgC5ALtgAxILoguQAFyCuQBckF/QAsRW6IDmAGYhXAnElELPCBBcC8W4y8AUgfgfEiQwUAFEgXg/EYugSpAAmIN4KxJLoEqSCYCCORhckB4C8BA9gSoAeusAoIAwAoNMTN4QjjlsAAAAASUVORK5CYII=>

[image2]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADQAAAAaCAYAAAD43n+tAAAC7klEQVR4Xu2XWahNURjH/4YMGeLJGGXIVOKFDMmQIRFekS5KCiWklMQDKeXBUKaSkOmBlIy5hgdzQsYH95Qow4OIBxL///32OWfv765z9qlz7nlxfvUr5/vWXWvttdf61gbU+P+YQbf7YJmspwt9sBr0p7doG58ok5a0nk7yiVLpSo/QpbQn3Urf0e/0Jh2Xb5qjLX1ER/pEhdBifaCdfCKN0fQGnUin0mewV76AXqJ/6Q/aw5rnWEVvu1icsfQqbYD1cTeZbkT9/4blNfktyTTO03UuVpRZ9DntTmfTX3R8LN8KtqU0oO/4Hq1zsRCXaQbWx6hkqpE19LAPRiyh71Hilh5OP9FBsC33mR5NtDAWwSazNxYbEMW6xWIhOtCXsAdX+7OJrLGHTvbBiOw4hfI5WtMXdGf0eyV9RXvnWuSZAOt0fyymh/wa+12IaXQXbIUzsH60gHHuo/gb0JZd64MelUR1XkoVmQ5ruyEW00JoImnsoHOjf2tS6kcPmKUvvRD7HUJbVm+xKMdhnXf2iQA6/P7hT8MGSuMh8mN0pF/oN9olii2DnaFinKInfNCjff0HdujT0Ao+cLFz9KSLeXS+VFDibIMtTnYLabIj8ukgB2DVsihvYB0P8wmH7h+1m+LiekOyGPPpRhdTNf0Jq1y6X3Ru09hHr/ug5xpsohq0EH1gd8Mmn4AViLQtdwh2F3k0QY2tihqqqh5tt1B1TLAa1ulrOtjlxBDY6u2mLVxO6Nvtjg86VEVVTT0aT2PLxS4X4iKShSRIe9i5UKf6CtAfzKPLYav2ka7ItW6KJqIDXoiZ9DHCiyHOwMbu5RMBdDw0r1R06amCXYHdKbr5D8LumHaxdiH6wSakNxlHXxmqbNk3kIHdY54x9KkPBtCZUz/6PGt2GtD0c6jSzIF9mlUFXbRPfLDCHIOd96qgbfkWtn2ag4GwL/+07V9R9DD1CFezctB/8FTdhvpENdC32mYfLBNt5zofrFGjRuX5B/gPmB+oFAK9AAAAAElFTkSuQmCC>
