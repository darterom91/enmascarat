{* 2016 genei
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
<div class="modal modal-flex fade" id="modal_mapas_oficina" 
    tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h4>{l  mod='genei' s='Delivery points map'}</h4>                
            </div>
            <div class="modal-body" align="center">
                <div id="div_choose_delivery_point" style="margin-bottom: 10px; font-weight:bold">
                    {l  mod='genei' s='Choose one delivery point'}
                </div>
                <div class="row" id="div_checkbox_correos_express" style="display:none;margin-bottom: 10px; font-weight:bold">
                    <input type="button" name="no_bring_correos_express" id="no_bring_correos_express" value="{l  mod='genei' s='Deliver directly to my address'}">
                    <input type="button" name="bring_correos_express" id="bring_correos_express" value="{l  mod='genei' s='Do not deliver directly to my address'}">
                    
                    
                </div>
                <div id="map" style="width: 700px; height: 600px; position: relative; overflow: hidden;"></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-warning" id="modal_mapas_oficina_ok" 
                style="margin: 10px 10px 5px 0;" data-dismiss="modal">
                    {l  mod='genei' s='Confirm'}
                </button>
            </div>
        </div>
    </div>
</div>
<script src="https://maps.googleapis.com/maps/api/js?key={$googleApiKey|escape:'htmlall':'UTF-8'}&callback=initMap"
    async defer></script>
<script type="text/javascript">
    array_mondial_relay_carriers = [];
    array_ups_access_point_carriers = [];    
    array_oficinas_ups=[];    
    array_oficinas_ups_list = [];
    array_correos_oficina_carriers = [];
    array_oficinas_correos=[];
    array_oficinas_correos_list = [];
    array_correos_express_oficina_carriers = [];
    array_oficinas_correos_express=[];
    array_oficinas_correos_express_list = [];
    GoogleApiKey = "{$googleApiKey|escape:'htmlall':'UTF-8'}";    
    id_delivery_point = {$id_delivery_point|escape:'htmlall':'UTF-8'};
    {foreach from=$array_id_carrier_mondial_relay item=id_carrier_mondial_relay}
        array_mondial_relay_carriers.push({$id_carrier_mondial_relay|escape:'htmlall':'UTF-8'});
    {/foreach}
    {foreach from=$array_id_carrier_ups_access_point item=id_carrier_ups_access_point}
        array_ups_access_point_carriers.push({$id_carrier_ups_access_point|escape:'htmlall':'UTF-8'});
    {/foreach}
    {foreach from=$array_id_carrier_correos_oficina item=id_carrier_correos_oficina}
        array_correos_oficina_carriers.push({$id_carrier_correos_oficina|escape:'htmlall':'UTF-8'});
    {/foreach}
        {foreach from=$array_id_carrier_correos_express_oficina item=id_carrier_correos_express_oficina}
        array_correos_express_oficina_carriers.push({$id_carrier_correos_express_oficina|escape:'htmlall':'UTF-8'});
    {/foreach}
    {foreach from=$lista_access_points_ups item=access_point}
        array_oficinas_ups["{$access_point->location_id|escape:'htmlall':'UTF-8'}"] =
            {ldelim}"location_id":{$access_point->location_id|escape:'htmlall':'UTF-8'},
            "lat":{$access_point->lat|escape:'htmlall':'UTF-8'},
            "long":{$access_point->long|escape:'htmlall':'UTF-8'},
            "title":"{$access_point->nombre|escape:'htmlall':'UTF-8'} - {$access_point->direccion|escape:'htmlall':'UTF-8'}"{rdelim};
        array_oficinas_ups_list.push("{$access_point->location_id|escape:'htmlall':'UTF-8'}");
    {/foreach}
    {foreach from=$lista_oficinas_destino_correos item=oficina_correos}
        array_oficinas_correos["{$oficina_correos->id_oficina|escape:'htmlall':'UTF-8'}"] =
            {ldelim}
            "location_id":{$oficina_correos->id_oficina|escape:'htmlall':'UTF-8'},
            "lat":{$oficina_correos->latitud|escape:'htmlall':'UTF-8'},
            "long":{$oficina_correos->longitud|escape:'htmlall':'UTF-8'},
            "title":"{$oficina_correos->direccion|escape:'htmlall':'UTF-8'}"{rdelim};
        array_oficinas_correos_list.push("{$oficina_correos->id_oficina|escape:'htmlall':'UTF-8'}");
    {/foreach}
    {foreach from=$lista_oficinas_destino_correos_express item=oficina_correos_express}
        array_oficinas_correos_express["{$oficina_correos_express->id_oficina|escape:'htmlall':'UTF-8'}"] =
            {ldelim}
            "location_id":{$oficina_correos_express->id_oficina|escape:'htmlall':'UTF-8'},
            "lat":{$oficina_correos_express->latitud|escape:'htmlall':'UTF-8'},
            "long":{$oficina_correos_express->longitud|escape:'htmlall':'UTF-8'},
            "title":"{$oficina_correos_express->direccion|escape:'htmlall':'UTF-8'}"{rdelim};
        array_oficinas_correos_express_list.push("{$oficina_correos_express->id_oficina|escape:'htmlall':'UTF-8'}");
    {/foreach}
</script>
<script type="text/javascript" src="{$pathfrontoficinadestino|escape:'htmlall':'UTF-8'}"></script> 