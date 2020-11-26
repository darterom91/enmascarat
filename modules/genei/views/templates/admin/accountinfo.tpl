{**
* 2016 genei
*
* Genei Gestión Logística
*
* NOTICE OF LICENSE
*
*  @author    Genei info@genei.es
*  @copyright 2016 Genei
*  @license   Non-commercial
*  @version 2.0.0
*}

<div class="col-md-1" style="margin-top:25px"> 
    {if {$estado_autenticacion_genei|escape:'htmlall':'UTF-8'} eq "1" && {$direccion_predeterminada_genei|escape:'htmlall':'UTF-8'}!=NULL}
        {if {$usuario_a_credito_genei|escape:'htmlall':'UTF-8'} eq "1"}
            <div class="h4">{l s ='Account credit:' mod='genei'} {$saldo_credito_disponible_genei|escape:'htmlall':'UTF-8'} €</div>
       {elseif {$usuario_a_credito_genei|escape:'htmlall':'UTF-8'} eq "0"}
            <div class="h4">{l s ='Account balance:' mod='genei'} {$saldo_credito_disponible_genei|escape:'htmlall':'UTF-8'} €</div>    
       {/if}
   {/if}
</div>