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

<div style="margin-top:20px">            
    <div class="col-md-12" style="margin-top:20px;border-top:rgb(211, 216, 219) solid 1px;padding-top: 10px">
        <div class="col-md-3">
            <strong>{l s='Statuses relations between Genei and PrestaShop:' mod='genei'}</strong>
        </div>
        <div class="col-md-8">            
        </div>            
    </div>
    <div class="col-md-12" style="margin-top:20px">        
        <div class="col-md-2">
            <label for="estado_recogida_tramitada_genei_default" class="text-left">{l s='Cursed Pickup Genei:' mod='genei'}</label>
            <select class="form-control" name="estado_recogida_tramitada_genei_default" id="estado_recogida_tramitada_genei_default">
                {html_options options=$estado_recogida_tramitada_genei selected=$estado_recogida_tramitada_genei_default}
            </select>
        </div>              
        <div class="col-md-2">
            <label for="estado_envio_transito_genei_default" class="text-left">{l s='Shipment in transit Genei:' mod='genei'}</label>
            <select class="form-control" name="estado_envio_transito_genei_default" id="estado_envio_transito_genei_default">
                {html_options options=$estado_envio_transito_genei selected=$estado_envio_transito_genei_default}
            </select>
        </div>
        <div class="col-md-2">
            <label for="estado_envio_incidencia_genei_default" class="text-left">{l s='Shipment with incidence Genei:' mod='genei'}</label>
            <select class="form-control" name="estado_envio_incidencia_genei_default" id="estado_envio_incidencia_genei_default">
                {html_options options=$estado_envio_incidencia_genei selected=$estado_envio_incidencia_genei_default}
            </select>
        </div> 
        <div class="col-md-2">
            <label for="estado_envio_entregado_genei_default" class="text-left">{l s='Shipment delivered Genei:' mod='genei'}</label>
            <select class="form-control" name="estado_envio_entregado_genei_default" id="estado_envio_entregado_genei_default">
                {html_options options=$estado_envio_entregado_genei selected=$estado_envio_entregado_genei_default}
            </select>
        </div>  
        <div class="col-md-2">
            <label for="estados_automaticos_pedidos_genei" class="text-left">{l s='Automatic state change:' mod='genei'}</label>
            <span class="switch prestashop-switch fixed-width-md">                        
                <input type="radio" name="estados_automaticos_pedidos_genei" id="estados_automaticos_pedidos_genei_yes" value="1" {if {$estados_automaticos_pedidos_genei|escape:'htmlall':'UTF-8'} == 1} checked ="checked" {/if}/>    	
                <label for="estados_automaticos_pedidos_genei_yes" class="pull-left">{l s='Yes' mod='genei'}</label>	
                <input type="radio" name="estados_automaticos_pedidos_genei" id="estados_automaticos_pedidos_genei_no" value="0" {if {$estados_automaticos_pedidos_genei|escape:'htmlall':'UTF-8'} != 1} checked ="checked" {/if} />
                <label for="estados_automaticos_pedidos_genei_no" class="pull-right">{l s='No' mod='genei'}</label>                
                <a class="slide-button btn"></a>
            </span>
	</div>    
        <div class="col-md-2"></div>      
          
    </div>    
    </div>
        
        
        