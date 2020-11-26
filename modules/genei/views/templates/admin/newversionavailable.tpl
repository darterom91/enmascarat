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

<div class="pull-left col-md-6" style="margin-top:20px"> 
    {if {$nueva_version_disponible_genei|escape:'htmlall':'UTF-8'} eq "1"}
        <a target="_blank" href="https://www.genei.es/recursos/servicios_externos/prestashop/genei.zip" onclick="javascript:mostrar_advertencia_cache();">{l s='New version available:' mod='genei'} {$ultima_version_disponible_genei|escape:'htmlall':'UTF-8'}</a>    
    {/if}
      </div>