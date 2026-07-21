# Solucionar problemas de leilão

O leilão (bidding) permite que as fontes de anúncios compitam em tempo real pelo seu inventário de anúncios. Esta página fornece etapas de solução de problemas para problemas comuns de leilão.

## Problemas comuns de leilão

### Anúncios não carregam

Se os anúncios não estiverem carregando com o leilão:

1. **Verifique a versão do adaptador**: Certifique-se de usar a versão mais recente do adaptador de leilão
2. **Verifique a inicialização**: Verifique se o SDK e os adaptadores de leilão estão inicializados corretamente
3. **Verifique a configuração do bloco de anúncios**: Verifique se o seu bloco de anúncios está configurado para leilão na interface do AdMob

### Baixa taxa de preenchimento

Se você estiver experimentando uma baixa taxa de preenchimento com o leilão:

1. **Verifique o status da fonte de anúncios**: Verifique se a fonte de anúncios está ativa e configurada corretamente
2. **Revise os preços mínimos (floor pricing)**: Verifique se os seus preços mínimos são muito altos
3. **Cobertura geográfica**: Algumas fontes de anúncios têm cobertura geográfica limitada

### Problemas de latência

Se o leilão estiver causando latência:

1. **Verifique as condições da rede**: Condições de rede ruins podem aumentar a latência do leilão
2. **Monitore a latência do adaptador**: Use o status de inicialização para verificar a latência do adaptador
3. **Otimize as configurações de tempo limite (timeout)**: Ajuste as configurações de tempo limite, se disponível

## Ferramentas de depuração

### Inspetor de anúncios (Ad Inspector)

Use o Inspetor de anúncios para depurar problemas de leilão:

1. Habilite o Inspetor de anúncios no seu aplicativo
2. Inicie o Inspetor de anúncios quando um anúncio for carregado
3. Verifique o status do leilão e as informações de resposta

### Logs

Habilite o registro de logs para ver informações detalhadas do leilão:

=== "GDScript"

    ```gdscript
    # Habilitar logs de depuração
    MobileAds.set_debug(true)
    ```

=== "C#"

    ```csharp
    // Habilitar logs de depuração
    MobileAds.SetDebug(true);
    ```

## Assistência adicional

Se você continuar a ter problemas, entre em contato com o [suporte do SDK dos anúncios do Google para dispositivos móveis](https://support.google.com/admob/contact/contact_us_gma_sdk).
