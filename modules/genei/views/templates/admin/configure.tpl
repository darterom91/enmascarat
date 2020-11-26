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

{if $errors|@count > 0}
    <div class="error">
        <ul>
            {foreach from=$errors item=error}
                <li>{$error|escape:'htmlall':'UTF-8'}</li>
            {/foreach}
        </ul>
    </div>
{/if}
<div class="bootstrap">
    <div class="col-md-12">
        {if {$datos_guardados_genei|escape:'htmlall':'UTF-8'} == "1"}
<div class="alert alert-success">
			<button type="button" class="close" data-dismiss="alert">×</button>
                       {l mod='genei' s ='Configuration saved.'}
	</div> 
{/if}

        <div class="col-md-3">
            <legend class="panel">
                <img src="{$path|escape:'htmlall':'UTF-8'}logo.png" alt="" title="" />{l s='' mod='genei'}
            </legend>           
        </div>
    </div>
            <div class="h4 col-md-12 text-right">
                <div class="col-md-10"></div>
                <div class="col-md-2">? <a href="{$base_url_genei|escape:'htmlall':'UTF-8'}{$_MODULE_DIR_|escape:'htmlall':'UTF-8'}genei/docs/{l s='prestashopgeneidoc_EN.pdf' mod='genei'}" target="_blank">{l s='Module Help' mod='genei'}</a></div>
            </div>
    <div class="col-md-12">
        <div id="div_resultado_ko_login_genei" class="alert alert-danger" style="display:none">
            <button type="button" class="close" data-dismiss="alert">×</button>Error:
            <br>
            {l s='User or password wrong' mod='genei'}
        </div>
        <div id="div_resultado_ok_logout_genei" class="alert alert-danger" style="display:none">
            <button type="button" class="close" data-dismiss="alert">×</button>Error:
            <br>
            {l s='Logged off' mod='genei'}
        </div>                    
        <div id="div_resultado_ok_login_genei" class="alert alert-success" style="display:none">
            <button type="button" class="close" data-dismiss="alert">×</button>
            {l s='Login correct!' mod='genei'}
	</div>  
        <form action="{$request_uri|escape:'htmlall':'UTF-8'|replace:'&amp;':'&'}" method="post" id="form_configuration_genei" class="std panel">
            <fieldset>
                <div class="col-md-12">                             
                    {include file="$pathgeneilogin"}
                    {include file="$pathaccountinfo"}
                    {include file="$pathgeneidefaultaddresses"}                    
                </div>                       
                <div class="col-md-12" style="margin-top:21px">        
                    {if {$estado_autenticacion_genei|escape:'htmlall':'UTF-8'} eq "1" && {$direccion_predeterminada_genei|escape:'htmlall':'UTF-8'}!=NULL}
                    {include file="$pathgeneiusedcarriersnotinstalled"}
                    {include file="$pathgeneiusedcarriersinstalled"}        
                    {/if}
                </div>
                {if {$PS_DISABLE_OVERRIDES|escape:'htmlall':'UTF-8'} > 0 || {$PS_DISABLE_NON_NATIVE_MODULE|escape:'htmlall':'UTF-8'} > 0}
                <div class="col-md-12" style="margin-top:10px">
                    <a href="{$performancelink_genei|escape:'htmlall':'UTF-8'}" target="_blank">
                    {l mod='genei' s='To use Genei carriers you must set to "NO" Disable non native modules and disable all overrides under Advanced paramaters -> perfomance.'}
                    </a>
                </div> 
                {/if}
                {if {$override_error_genei|escape:'htmlall':'UTF-8'} != "0"}
                <div class="col-md-12" style="margin-top:10px">                    
                    {l mod='genei' s='Override files are not installed, for your security, custom carriers will not show price. Please contact us through PrestaShop Addons'}
                </div> 
                {/if}
                <div class="col-md-12" style="margin-top:19px">        
                    {if {$estado_autenticacion_genei|escape:'htmlall':'UTF-8'} eq "1" && {$direccion_predeterminada_genei|escape:'htmlall':'UTF-8'}!=NULL}
                    {include file="$pathpricevariation"}                   
                    {/if}
                </div>  
                {if {$estado_autenticacion_genei|escape:'htmlall':'UTF-8'} eq "1" && {$direccion_predeterminada_genei|escape:'htmlall':'UTF-8'}!=NULL} 
                    <div class="col-md-12" style="margin-top:20px;border-top:rgb(211, 216, 219) solid 1px;padding-top: 10px"">
                        {include file="$pathgeneidefaultpaymentmethod"}
                        {include file="$pathgeneidefaultatributes"} 
                    </div>
                {/if}
                {if {$estado_autenticacion_genei|escape:'htmlall':'UTF-8'} eq "1" && {$direccion_predeterminada_genei|escape:'htmlall':'UTF-8'}!=NULL}
                    {include file="$pathgeneistatusesrelations"}   
                {/if}
                {if {$estado_autenticacion_genei|escape:'htmlall':'UTF-8'} eq "1" && {$direccion_predeterminada_genei|escape:'htmlall':'UTF-8'}!=NULL}
                    {include file="$pathgeneigoogleapikey"}   
                {/if}
                <div class="col-md-12">
                    {if {$estado_autenticacion_genei|escape:'htmlall':'UTF-8'} eq "1" && {$direccion_predeterminada_genei|escape:'htmlall':'UTF-8'}!=NULL}
                        {include file="$pathgeneinewreversionavailable"}  
                    {/if}
                    <div class="pull-right col-md-6" style="margin-top:20px">                         
                        <button type="button" id="boton_guardar_configuracion_genei" title="{l s='Save' mod='genei'}" class="btn btn-default pull-right" onclick="guardar_configuracion_genei()" style="margin-top:10px" /><i class="process-icon-save"></i>{l s='Save' mod='genei'}</button>
                        
                    </div>
                </div>
            </fieldset>
            <ps-switch name="switch" label="Switch" yes="Yes" no="No" active="true"></ps-switch>            
            <input type="hidden" name="datos_guardados_genei" value="0" id="datos_guardados_genei">
        </form>
    </div>
      {include file="$pathgeneimodalalert"}  
   {include file="$pathgeneimodalregister"}
   {include file="$pathgeneimodalregisterok"}
   {include file="$pathgeneimodaltermsandconditions"}       
</div>            
{include file="$pathgeneiscripts"}
