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
<script type="text/javascript">
    array_variation_price_amount_genei=[];
    array_variation_amount_free_genei=[];
    array_variation_type_genei=[];
    function cargar_valores_variaciones(id_genei_carrier)
    {
        array_variation_price_amount_genei[id_genei_carrier] = $("#variation_price_amount_genei_"+id_genei_carrier).val();
        array_variation_amount_free_genei[id_genei_carrier] = $("#variation_amount_free_genei_"+id_genei_carrier).val();
        
        array_variation_type_genei[id_genei_carrier] = $("#variation_type_genei_"+id_genei_carrier).val();

    }  
    </script>
{foreach key=key item=nombre_agencia_genei_utilizada from=$agencias_genei_utilizadas}
 {if {$key|substr:0:4|escape:'htmlall':'UTF-8'} != "9500"}
<div class="col-md-9" style="margin-top:10px">
    <div class="col-md-3">           
            <label for="transportistas_utilizados_genei_variacion" class="text-left" style="margin-top:30px">{$nombre_agencia_genei_utilizada|escape:'htmlall':'UTF-8'}</label>                                             
        </div>
<div class="col-md-3">           
            <label for="variation_price_amount_genei_{$key|escape:'htmlall':'UTF-8'}" class="text-left">{l mod='genei' s='Carrier price variation:'}</label>
            <div class="col-md-12"><div class="col-md-4 pull-left"><input onchange="cargar_valores_variaciones({$key|escape:'htmlall':'UTF-8'})" class="form-control" name="variation_price_amount_genei_{$key|escape:'htmlall':'UTF-8'}" id="variation_price_amount_genei_{$key|escape:'htmlall':'UTF-8'}" type="number" min="-100" max="100" value="{$variation_price_amount_genei[$key]|escape:'htmlall':'UTF-8'}"></div></div>
           
        </div> 
<div class="col-md-3">
            <label for="variation_type_genei_{$key|escape:'htmlall':'UTF-8'}" class="text-left">{l mod='genei' s='Variation type of carrier price:'}</label>
           <div class="col-md-12"><div class="col-md-10 pull-left"><select class="form-control" onchange="cargar_valores_variaciones({$key|escape:'htmlall':'UTF-8'})" name="variation_type_genei_{$key|escape:'htmlall':'UTF-8'}" id="variation_type_genei_{$key|escape:'htmlall':'UTF-8'}">
               <option value="0" {if {$variation_type_genei[$key]|escape:'htmlall':'UTF-8'} == '0'}selected{/if}>{l mod='genei' s='+- Numeric €'}</option>
               <option value="1" {if {$variation_type_genei[$key]|escape:'htmlall':'UTF-8'} == '1'}selected{/if}>{l mod='genei' s='+- Percentage % €'}</option>
                   </select></div></div>
        </div>
<div class="col-md-3">           
            <label for="variation_amount_free_genei_{$key|escape:'htmlall':'UTF-8'}" class="text-left">{l mod='genei' s='Cart amount free carrier (0 - never):'}</label>
            <div class="col-md-12"><div class="col-md-4 pull-left"><input onchange="cargar_valores_variaciones({$key|escape:'htmlall':'UTF-8'})" class="form-control" name="variation_amount_free_genei_{$key|escape:'htmlall':'UTF-8'}" id="variation_amount_free_genei_{$key|escape:'htmlall':'UTF-8'}" type="number" min="-100" value="{$variation_amount_free_genei[$key]|escape:'htmlall':'UTF-8'}"></div></div>
        </div> 
            

</div>
        <div class="col-md-3" style="margin-top:10px"></div>        
        <script>    
        cargar_valores_variaciones({$key|escape:'htmlall':'UTF-8'});
</script>
  {/if}
 {/foreach}           
