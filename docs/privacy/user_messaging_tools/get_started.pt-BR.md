# Primeiros Passos

Sob a [Política de Consentimento de Usuários da UE](https://www.google.com/about/company/user-consent-policy/) do Google, você deve fazer certas divulgações aos seus usuários no Espaço Econômico Europeu (EEE) junto com o Reino Unido e obter seu consentimento para usar cookies ou outro armazenamento local, onde legalmente exigido, e para usar dados pessoais (como o AdID) para veicular anúncios. Esta política reflete os requisitos da Diretiva ePrivacy da UE e do Regulamento Geral sobre a Proteção de Dados (GDPR).

Para apoiar os editores no cumprimento de seus deveres sob esta política, o Google oferece o SDK da User Messaging Platform (UMP). O SDK da UMP foi atualizado para suportar os padrões IAB mais recentes. Todas essas configurações agora podem ser convenientemente gerenciadas no menu Privacidade e Mensagens do AdMob.

Este documento é baseado em:

- [Documentação do SDK do Google Mobile Ads para Android (Inglês)](https://developers.google.com/admob/android/privacy)
- [Documentação do SDK do Google Mobile Ads para iOS (Inglês)](https://developers.google.com/admob/ios/privacy)

## Pré-requisitos

- Complete o [Guia de Primeiros Passos](../../index.md)
- Se você estiver trabalhando em requisitos relacionados ao GDPR, leia [Como os requisitos do IAB afetam as mensagens de consentimento da UE](https://support.google.com/admob/answer/10207733).

## Criar um tipo de mensagem
Crie mensagens de usuário com um dos [tipos de mensagens de usuário disponíveis](https://support.google.com/admob/answer/10114020) na aba **Privacidade e Mensagens** da sua conta do AdMob. O SDK do UMP tenta exibir uma mensagem de usuário criada a partir do ID do Aplicativo AdMob configurado no seu projeto. Se nenhuma mensagem estiver configurada para o seu aplicativo, o SDK retornará um erro.

Para mais detalhes, consulte [Sobre privacidade e mensagens](https://support.google.com/admob/answer/10107561).

## Determinar se uma mensagem precisa ser exibida
Você deve solicitar uma atualização das informações de consentimento do usuário a cada inicialização do aplicativo, usando `update()` antes de carregar um formulário. Isso pode determinar se o seu usuário precisa ou não fornecer consentimento se ainda não o fez ou se o consentimento dele expirou.

Use as informações armazenadas no objeto `consentInformation` ao apresentar o formulário quando necessário.

!!! warning
    O uso de formas alternativas de verificar o status de consentimento — como verificar um cache que seu aplicativo utiliza ou procurar por uma string de consentimento no armazenamento — é fortemente desencorajado, pois o conjunto de parceiros de tecnologia de anúncios pode ter mudado desde o último consentimento do usuário.

Aqui está um exemplo de como verificar o status na inicialização do aplicativo:

=== "GDScript"

    ```gdscript
    extends Node
    
    func _ready():
    	var request := ConsentRequestParameters.new()
        # Set tag for underage of consent. false means users are not underage.
    	request.tag_for_under_age_of_consent = false
    	UserMessagingPlatform.consent_information.update(request, _on_consent_info_updated_success, _on_consent_info_updated_failure)
    
    func _on_consent_info_updated_success():
    	# The consent information state was updated.
    	# You are now ready to check if a form is available.
    	pass
    
    func _on_consent_info_updated_failure(form_error : FormError):
    	# Handle the error.
    	pass
    ```

=== "C#"

    ```csharp
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Ump.Api;
    using PoingStudios.AdMob.Ump.Core;
    
    public partial class UmpExample : Node
    {
        public override void _Ready()
        {
            var request = new ConsentRequestParameters();
            // Set tag for underage of consent. false means users are not underage.
            request.TagForUnderAgeOfConsent = false;
            UserMessagingPlatform.ConsentInformation.Update(request, OnConsentInfoUpdatedSuccess, OnConsentInfoUpdatedFailure);
        }
    
        private void OnConsentInfoUpdatedSuccess()
        {
            // The consent information state was updated.
            // You are now ready to check if a form is available.
        }
    
        private void OnConsentInfoUpdatedFailure(FormError formError)
        {
            // Handle the error.
        }
    }
    ```

## Carregar um formulário se disponível

Antes de exibir um formulário, primeiro você precisa determinar se um está disponível. Formulários indisponíveis podem ser devidos ao fato do usuário habilitar o rastreamento limitado de anúncios ou se você os marcou como abaixo da idade de consentimento.

Para verificar a disponibilidade de um formulário, use a função `get_is_consent_form_available()` na instância estática `consent_information` da classe `UserMessagingPlatform`.

Em seguida, adicione uma função wrapper para carregar o formulário:

=== "GDScript"

    ```gdscript
    #...
    func _on_consent_info_updated_success():
    	# The consent information state was updated.
    	# You are now ready to check if a form is available.
    	if UserMessagingPlatform.consent_information.get_is_consent_form_available():
    		load_form()
    
    func _on_consent_info_updated_failure(form_error : FormError):
    	# Handle the error.
    	pass
    
    func load_form():
    	pass
    ```

=== "C#"

    ```csharp
    //...
    private void OnConsentInfoUpdatedSuccess()
    {
        // The consent information state was updated.
        // You are now ready to check if a form is available.
        if (UserMessagingPlatform.ConsentInformation.GetIsConsentFormAvailable())
            LoadForm();
    }
    
    private void OnConsentInfoUpdatedFailure(FormError formError)
    {
        // Handle the error.
    }
    
    private void LoadForm()
    {
    }
    ```

Para carregar o formulário, use a função estática `load_consent_form()` na classe `UserMessagingPlatform`.

=== "GDScript"

    ```gdscript
    var _consent_form : ConsentForm
    
    func load_form():
    	UserMessagingPlatform.load_consent_form(_on_consent_form_load_success, _on_consent_form_load_failure)
    
    func _on_consent_form_load_success(consent_form : ConsentForm):
    	_consent_form = consent_form
    
    func _on_consent_form_load_failure(form_error : FormError):
    	# Handle the error.
    	pass
    ```

=== "C#"

    ```csharp
    private ConsentForm _consentForm;
    
    private void LoadForm()
    {
        UserMessagingPlatform.LoadConsentForm(OnConsentFormLoadSuccess, OnConsentFormLoadFailure);
    }
    
    private void OnConsentFormLoadSuccess(ConsentForm consentForm)
    {
        _consentForm = consentForm;
    }
    
    private void OnConsentFormLoadFailure(FormError formError)
    {
        // Handle the error.
    }
    ```

## Apresentar o formulário se necessário
Depois de determinar a disponibilidade do formulário e carregá-lo, use a função `show()` na instância `ConsentForm` para apresentar o formulário.

Use a instância estática `consent_information` da classe `UserMessagingPlatform` para verificar o status do consentimento e atualizar sua função `load_form()`:

=== "GDScript"

    ```gdscript
    var _consent_form : ConsentForm
    
    func load_form():
    	UserMessagingPlatform.load_consent_form(_on_consent_form_load_success, _on_consent_form_load_failure)
    
    func _on_consent_form_load_success(consent_form : ConsentForm):
    	_consent_form = consent_form
    	if UserMessagingPlatform.consent_information.get_consent_status() == UserMessagingPlatform.consent_information.ConsentStatus.REQUIRED:
    		consent_form.show(_on_consent_form_dismissed)
    
    func _on_consent_form_load_failure(form_error : FormError):
    	# Handle the error.
    	pass
    
    func _on_consent_form_dismissed(form_error : FormError):
    	if UserMessagingPlatform.consent_information.get_consent_status() == UserMessagingPlatform.consent_information.ConsentStatus.OBTAINED:
    		# App can start requesting ads.
    		pass
    	# Handle dismissal by reloading form
    	load_form()
    ```

=== "C#"

    ```csharp
    private ConsentForm _consentForm;
    
    private void LoadForm()
    {
        UserMessagingPlatform.LoadConsentForm(OnConsentFormLoadSuccess, OnConsentFormLoadFailure);
    }
    
    private void OnConsentFormLoadSuccess(ConsentForm consentForm)
    {
        _consentForm = consentForm;
        if (UserMessagingPlatform.ConsentInformation.GetConsentStatus() == ConsentStatus.Values.Required)
            consentForm.Show(OnConsentFormDismissed);
    }
    
    private void OnConsentFormLoadFailure(FormError formError)
    {
        // Handle the error.
    }
    
    private void OnConsentFormDismissed(FormError formError)
    {
        if (UserMessagingPlatform.ConsentInformation.GetConsentStatus() == ConsentStatus.Values.Obtained)
        {
            // App can start requesting ads.
        }
        // Handle dismissal by reloading form
        LoadForm();
    }
    ```

Se você precisar executar qualquer ação após o usuário fazer uma escolha ou fechar o formulário, coloque essa lógica no manipulador de conclusão ou callback do seu formulário.

## Testes

### Forçar uma geografia

O SDK do UMP fornece uma maneira de testar o comportamento do seu aplicativo como se o dispositivo estivesse localizado no EEE ou no Reino Unido usando a propriedade `debug_geography` em `ConsentDebugSettings`.

Você deve fornecer o ID com hash do seu dispositivo de teste nas configurações de depuração do seu aplicativo para usar a funcionalidade de depuração. Se você chamar `UserMessagingPlatform.consent_information.update()` sem definir este valor, seu aplicativo registrará o hash do ID necessário quando executado.

=== "GDScript"

    ```gdscript
    extends Node
    
    func _ready():
    	var request := ConsentRequestParameters.new()
    	var consent_debug_settings := ConsentDebugSettings.new()
    	consent_debug_settings.debug_geography = DebugGeography.Values.EEA
    	consent_debug_settings.test_device_hashed_ids.append("test_device_hashed_id")
    	request.consent_debug_settings = consent_debug_settings
    	
    	UserMessagingPlatform.consent_information.update(request, _on_consent_info_updated_success, _on_consent_info_updated_failure)
    
    func _on_consent_info_updated_success():
    	# The consent information state was updated.
    	# You are now ready to check if a form is available.
    	pass
    
    func _on_consent_info_updated_failure(form_error : FormError):
    	# Handle the error.
    	pass
    ```

=== "C#"

    ```csharp
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Ump.Api;
    using PoingStudios.AdMob.Ump.Core;
    
    public partial class UmpExample : Node
    {
        public override void _Ready()
        {
            var request = new ConsentRequestParameters();
            var consentDebugSettings = new ConsentDebugSettings();
            consentDebugSettings.DebugGeography = DebugGeography.Eea;
            consentDebugSettings.TestDeviceHashedIds.Add("test_device_hashed_id");
            request.ConsentDebugSettings = consentDebugSettings;
            
            UserMessagingPlatform.ConsentInformation.Update(request, OnConsentInfoUpdatedSuccess, OnConsentInfoUpdatedFailure);
        }
    
        private void OnConsentInfoUpdatedSuccess()
        {
            // The consent information state was updated.
            // You are now ready to check if a form is available.
        }
    
        private void OnConsentInfoUpdatedFailure(FormError formError)
        {
            // Handle the error.
        }
    }
    ```

Com o enum `DebugGeography.Values`, você tem a opção de forçar a geografia para uma destas opções:

| DebugGeography | Description                                            |
|----------------|--------------------------------------------------------|
| DISABLED       | Debug geography disabled.                              |
| EEA            | Geography appears as in EEA for debug devices.         |
| NOT_EEA        | Geography appears as not in the EEA for debug devices. |

Observe que as configurações de depuração funcionam apenas em dispositivos de teste. Os emuladores não precisam ser adicionados à sua lista de IDs de dispositivos, pois já possuem os testes ativados por padrão.


### Redefinir o estado de consentimento

Ao testar seu aplicativo com o SDK do UMP, você pode achar útil redefinir o estado do SDK para poder simular a experiência de primeira instalação de um usuário. O SDK fornece a função `reset()` para fazer isso.

=== "GDScript"

    ```gdscript
    UserMessagingPlatform.consent_information.reset()
    ```

=== "C#"

    ```csharp
    UserMessagingPlatform.ConsentInformation.Reset();
    ```

Você também deve chamar `reset()` se decidir remover completamente o SDK do UMP do seu projeto.

!!! warning
    Esta função destina-se a ser usada apenas para fins de teste. Você não deve chamar `reset()` no código de produção.
