# Vpon

O adaptador de mediação da Vpon permite integrar anúncios da Vpon no seu jogo Godot usando a mediação do AdMob.

## Integrações Suportadas

| Formato de Anúncio | Bidding | Waterfall |
| :--- | :--- | :--- |
| **Banner** | ❌ | |
| **Interstitial** | ❌ | |
| **Rewarded** | ❌ | |

## Passos de Integração

### Android

#### 1. Ativar Vpon nas Configurações do Projeto
- Ative o **Vpon** em `admob/android/mediation/vpon` nas Configurações do Projeto do Godot.

#### 2. Configurar Mediação no Console do AdMob
Configure a Vpon como parceira de mediação no console do AdMob:
1. Faça login na sua **conta AdMob**.
2. Navegue até **Mediação** e crie ou edite um **Grupo de Mediação**.
3. Na cascata de redes de anúncios, adicione a Vpon como um **Evento Personalizado**.
4. **Nome da Classe**: Insira `com.vpadn.mediation.VpadnAdapter`.
5. **Parâmetro**: Insira sua Chave de Licença Vpon.

---

### iOS

Como a Vpon é integrada via Eventos Personalizados no iOS, os desenvolvedores devem adicionar os arquivos do SDK da Vpon e do adaptador AdMob às configurações de build do Xcode durante a exportação.

#### 1. Configurar Mediação no Console do AdMob
1. Faça login na sua **conta AdMob**.
2. Navegue até **Mediação** e crie ou edite um **Grupo de Mediação**.
3. Na cascata de redes de anúncios, adicione a Vpon como um **Evento Personalizado**.
4. **Nome da Classe**: Insira `VponAdMobAdapter`.
5. **Parâmetro**: Insira sua Chave de Licença Vpon / ID da Unidade de Anúncio.
