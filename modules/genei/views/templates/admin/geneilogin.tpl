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

<div class="col-md-2">
    <label for="usuario_servicio_genei"  class="text-left">{l s='PrestaShop Genei User' mod='genei'}</label>
    <input type="text" min="1" max="80" name="usuario_servicio_genei" id="usuario_servicio_genei" placeholder="{l s='Please enter user' mod='genei'}" value="{$usuario_servicio_genei|escape:'htmlall':'UTF-8'}" {if {$estado_autenticacion_genei|escape:'htmlall':'UTF-8'} == "1"} disabled {/if} />
</div>                        
<div class="col-md-2">
    <label for="password_servicio_genei"  class="text-left">{l s='PrestaShop Genei Password' mod='genei'}</label>         
    <input type="password" min="1" max="80" name="password_servicio_genei" id="password_servicio_genei" placeholder="{l s='Please enter password' mod='genei'}" value="{$password_servicio_genei|escape:'htmlall':'UTF-8'}" {if {$estado_autenticacion_genei|escape:'htmlall':'UTF-8'} == "1"} disabled {/if}/>
</div>                
<div class="col-md-2" style="margin-top:24px">                 
    <button id="boton_login_genei" type="button" class="btn btn-md btn-success" title="{l s='Login' mod='genei'}" onclick="login_genei()">{l s='Login' mod='genei'}</button>  
    <button type="button" class="btn btn-md btn-success" id="boton_registrarse_genei" title="{l s='Register' mod='genei'}" onclick="abrir_registro()">{l mod='genei' s='Register'}</button>
    <button type="button" class="btn btn-md btn-success" id="boton_logout_genei" title="{l s='Logout' mod='genei'}" onclick="logout_genei()">{l mod='genei' s='Logout'}</button>                      
</div>