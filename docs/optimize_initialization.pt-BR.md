# Otimizar inicialização e carregamento de anúncios

Este guia descreve como otimizar a inicialização e o carregamento de anúncios no seu projeto Godot.

## Atualizar suas configurações do Google Mobile Ads

O Godot Plugin do Google Mobile Ads habilita a otimização por padrão e instrui o SDK a executar as tarefas de inicialização e carregamento de anúncios em threads em segundo plano.

As seguintes opções estão disponíveis nas Configurações do Projeto do Godot:

* Desativar otimização de inicialização
* Desativar otimização de carregamento de anúncios

Marque essas opções para instruir o SDK a inicializar e carregar anúncios na thread principal:

| Configuração | Comportamento |
| :--- | :--- |
| **Disable Initialization Optimization** | Desativa a otimização da chamada de inicialização `MobileAds.initialize()`. |
| **Disable Ad Loading Optimization** | Desativa a otimização das chamadas de carregamento de anúncios para todos os formatos de anúncio. |

Você pode acessar as configurações do Google Mobile Ads através do menu de Configurações do Projeto do Godot:

**Project > Project Settings > Admob > General > Android**

Após selecionado, a interface de configurações aparecerá na seção **Android**:

![Configurações de Otimização da Inicialização](assets/optimize_initialization.png)
