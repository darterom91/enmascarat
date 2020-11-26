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

<div id="capa_direccion_predeterminada_genei">
    <div class="col-md-3">        
        <label for="direccion_predeterminada_genei"  class="text-left">{l s='Default from address: ' mod='genei'}</label>
        <select name="direccion_predeterminada_genei" id="direccion_predeterminada_genei">
            <option selected disabled hidden>{l s='Choose an address:' mod='genei'}</option>
            {html_options options=$direcciones_genei selected=$direccion_predeterminada_genei} 
        </select>
    </div>    
</div>
<div id="capa_errores_direcciones" style="display:none"><strong>{l s='At least one FROM address is required. Please log-in into genei.es and add a address for your account' mod='genei'}</strong></div>
        