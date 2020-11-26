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

                  <div class="panel col-md-12" style="margin-bottom:20px">        
                      {if $envio_creado_codigo_envio =='#'}
                <form id="form_buscar_precios" name="form_buscar_precios">
                  {/if}  
                <div class="form-group">
                {if {$estado_autenticacion_genei|escape:'htmlall':'UTF-8'} == "1" && {$direccion_predeterminada_genei|escape:'htmlall':'UTF-8'} != ''}    
                    <div class="" style="margin-bottom: 10px">                    
				<div class="panel-heading">
                                    <img width="60" src="{$url_logo|escape:'htmlall':'UTF-8'}">
					<i class="icon-cart"></i>
                                        {if $envio_creado_codigo_envio !='0'}
                                        {l  mod='genei' s='Genei order information'}
                                        {else}   
					{l  mod='genei' s='Create Genei shipment from this PrestaShop order'}
                                        {/if}                                        
                                </div></div>   
         
         {if {$nueva_version_disponible_genei|escape:'htmlall':'UTF-8'} eq "1"}
            <a target="_blank" href="https://www.genei.es/recursos/servicios_externos/prestashop/genei.zip" onclick="javascript:mostrar_advertencia_cache();">{l s='New version available:' mod='genei'} {$ultima_version_disponible_genei|escape:'htmlall':'UTF-8'}</a>    
         {/if}
             {if $envio_creado_codigo_envio !='#'}
            
                                <div class="col-md-12" style="margin-top:20px">                                     
        <div class="col-md-4">
            <label class="form-control">{l  mod='genei' s='Order code: '}
            {$envio_creado_codigo_envio|escape:'htmlall':'UTF-8'}
            </label>
        </div>    
        <div class="col-md-4">
            <label class="form-control">{l mod='genei' s='Creation date / hour: '}
            {$envio_creado_fecha_hora_creacion|escape:'htmlall':'UTF-8'}
            </label>
        </div> 
        <div class="col-md-4">
            <label class="form-control">{l mod='genei' s='Agency: '}
            {$envio_creado_nombre_agencia|escape:'htmlall':'UTF-8'}
            </label>
        </div>     
        </div>
        <div class="col-md-12" style="margin-top:20px">
        <div class="col-md-4">
            <label class="form-control">{l mod='genei' s='Last status: '}
            {$envio_creado_nombre_estado|escape:'htmlall':'UTF-8'}
            </label>
        </div>         
        <div class="col-md-4">
            <label class="form-control">{l mod='genei' s='Tracking nº: '}
            {$envio_creado_seguimiento|escape:'htmlall':'UTF-8'}
            </label>
        </div>             
        <div class="col-md-4">  
         {if $envio_creado_web_seguimiento !=''}    
            <label class="form-control">{l mod='genei' s='Url tracking: '}
                <a href="{$envio_creado_web_seguimiento|escape:'htmlall':'UTF-8'}" target="_blank">{$envio_creado_web_seguimiento|escape:'htmlall':'UTF-8'}</a>
            </label>
         {/if}
        </div>                 
        </div>
         <div class="col-md-12" style="margin-top:20px;margin-bottom:20px">
             <div class="col-md-3">            
            <button type="button" class="form-control" id="boton_actualizar_estado" title="{l mod='genei' s='Update status '}" onclick="actualizar_estado_envio('{$envio_creado_codigo_envio|escape:'htmlall':'UTF-8'}')">{l mod='genei' s='Update status '}</button>
        </div>   
        <div class="col-md-3">
            <a href="{$envio_creado_url_etiquetas|escape:'htmlall':'UTF-8'}" target="_blank"><button type="button" class="form-control" id="boton_imprimir_etiquetas" title="{l mod='genei' s='Print labels'}">{l mod='genei' s='Print labels' mod='genei'}</button></a>
        </div>
        <div class="col-md-3">
            <a href="{$envio_creado_url_etiquetas_zebra|escape:'htmlall':'UTF-8'}" target="_blank"><button type="button" class="form-control" id="boton_imprimir_etiquetas_zebra" title="{l mod='genei' s='Print zebra labels'}">{l mod='genei' s='Print zebra labels' mod='genei'}</button></a>
        </div>
        {if $envio_creado_url_proforma!=''}
        <div class="col-md-3">
            <a href="{$envio_creado_url_proforma|escape:'htmlall':'UTF-8'}" target="_blank"><button type="button" class="form-control" id="boton_obtener_url_proforma" title="{l mod='genei' s='Proforma'}">{l mod='genei' s='Proforma' mod='genei'}</button></a>
        </div>
        {/if}
         </div>
       {else}
                                
                                <div class="col-md-12" style="margin-top:20px">
        <div class="col-md-6">
            <label for="direccion_predeterminada_genei">{l mod='genei' s='From address:'}</label>
            <select name="direccion_predeterminada_genei" id="direccion_predeterminada_genei" class="chosen-select">
               {html_options options=$direcciones_genei selected=$direccion_predeterminada_genei} 
            </select>
        </div>            
            <div class="col-md-6">
            <label for="direccion_destino_genei">{l mod='genei' s='To address:'}</label>
            <input type="text" disabled="disabled" class="form-control" id="direccion_destino_genei" name="direccion_destino_genei" value="{$direccion_destino_genei|escape:'htmlall':'UTF-8'}"/>
               
            
        </div>  
                                </div>
    <div id="div_dropshipping" class="col-md-12" style="margin-top:20px">
        <div class="col-md-4">
            
        </div>
        <div class="col-md-6">
            <div class="col-md-12">
                <div class="col-md-2">
                    <label class="form-control" for="dropshipping_pag_pedido_genei">{l mod='genei' s='Dropshipping'}</label>
                    <input type="checkbox" class="form-control" id="dropshipping_pag_pedido_genei" value="0" name="dropshipping_pag_pedido_genei" onclick="click_dropshipping()"/>                    
                </div>
                <div class="col-md-10" id="div_direccion_predeterminada_dropshipping_genei"> 
                    <label for="direccion_predeterminada_dropshipping_genei">{l mod='genei' s='Dropshipping from address (Real from address):'}</label>
                    <select id="direccion_predeterminada_dropshipping_genei" name="direccion_predeterminada_dropshipping_genei" class="select1 chosen-select">
                       {html_options options=$direcciones_genei selected=$direccion_predeterminada_dropshipping_genei} 
                    </select>
                </div>                
                <div class="col-md-4"></div>    
            </div>
        </div>
       
    </div>
             
         
         <div id="drag_drop_warehouse" class="panel col-md-12" style="margin-top:20px">
            <div id="contenedor-principal" class="container-fluid">
                <section id="buscador">
                    <div id="buscador-cabecera">
                        <div class="titulo">
                            <h2>Tu envío</h2>
                        </div>
                    </div>
                    <div id="buscador-cuerpo">
                        <div id="contenedor-bultos">
                            <div class="bultos-cabecera">
                                <p>Bultos</p>
                                <div id="contenedor-codigo-promocional" class="form-group" style="display: none;">
                                    <input type="text" class="form-control promo-form-code" placeholder="Código promocional" id="cod_promo" name="cod_promo">
                                </div>
                            </div>
                            <div class="bultos-cuerpo">
                                <div class="bulto" data-numero-bulto="1">
                                    <div class="cabecera-bulto">
                                        <p>Bulto <span class="numero-bulto">1</span> <span class="predefinido-bulto">Usar predefinido</span><span class="borrar-bulto" style="display: none;">x</span></p>
                                    </div>
                                    <div class="cuerpo-bulto">
                                        
                                    </div>
                                </div>
                            </div>
                            <div class="bultos-pie">
                                
                            </div>
                        </div>
                    </div>
                </section>
                
                <section id="aside-buscador" style="display: none;">
                    <div id="aside-buscador-cabecera">
                        <div class="titulo">
                            <h2>Tus direcciones</h2>
                            <span id="cerrar-aside">x</span>
                        </div>
                    </div>
                    <div id="aside-buscador-cuerpo">
                        <div class="cabecera">
                            <p>Dirección de origen</p>
                        </div>
                        <div class="filtro_referencias">

                        </div>
                        <div class="cuerpo">
                            <div id="contenedor">

                            </div>
                        </div>
                    </div>
                </section>
            </div>
            
            <div id="informacion-soporte" style="display: none">                
            </div>           
            <div class="modal fade" id="modal_multireferencia_sin_caja" name="modal_listado_bultos" tabindex="-1" role="dialog" aria-labelledby="modal_multireferencia_sin_caja" aria-hidden="true">
                <div class="modal-dialog" style="max-width: 390px;">                
                    <div class="modal-content">
                        <div class="modal-header">                                
                            <h5 class="modal-title" id="myModalLabel">Aviso</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <i class="ion-close-round"></i>
                            </button>
                        </div>                        
                        <div class="modal-body" style="max-height: 500px; overflow-y: auto;">
                            <div class="row">
                                <div class="col-12">
                                    <p class="subtitulo-modal">Estás soltando varios artículos en un bulto sin caja</p>
                                    <p>Selecciona una caja para agrupar los artículos en un mismo bulto o crea un bulto por cada artículo</p>
                                    <div class="form-group">
                                        <select id="cajas-modal" class="form-control">

                                        </select>
                                    </div>
                                    <p class="centrar">o</p>
                                    <div class="boton-bulto-por-articulo">
                                        <p>Crear un bulto por artículo</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer"> 

                        </div>
                    </div>

                </div>
            </div>

            <div class="modal fade" id="modal_quitar_caja" name="modal_quitar_caja" tabindex="-1" role="dialog" aria-labelledby="modal_quitar_caja" aria-hidden="true">
                <div class="modal-dialog" style="max-width: 390px;">                
                    <div class="modal-content">
                        <div class="modal-header">                                
                            <h5 class="modal-title" id="myModalLabel">Aviso</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <i class="ion-close-round"></i>
                            </button>
                        </div>                        
                        <div class="modal-body" style="max-height: 500px; overflow-y: auto;">
                            <div class="row">
                                <div class="col-12">
                                    <p class="subtitulo-modal">Estás tratando de quitarle la caja a un bulto con más de un artículo dentro</p>
                                    <p>Esto ocasionará que se genere un nuevo bulto con cada uno de los artículos contenidos.</p>
                                    <div class="boton-quitar-caja">
                                        <p>Crear un bulto por artículo</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer"> 

                        </div>
                    </div>

                </div>
            </div>

            <div class="modal fade" id="modal_cantidad_insuficiente" name="modal_cantidad_insuficiente" tabindex="-1" role="dialog" aria-labelledby="modal_cantidad_insuficiente" aria-hidden="true">
                <div class="modal-dialog" style="max-width: 390px;">                
                    <div class="modal-content">
                        <div class="modal-header">                                
                            <h5 class="modal-title" id="myModalLabel">Aviso</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <i class="ion-close-round"></i>
                            </button>
                        </div>                        
                        <div class="modal-body" style="max-height: 500px; overflow-y: auto;">
                            <div class="row">
                                <div class="col-12">
                                    <p class="subtitulo-modal">¡Cantidad insuficiente en almacén!</p>
                                    <p>No dispones de las unidades suficientes para realizar el envío. Por favor, revisa tus cantidades disponibles y reponlas en tu área de inventario</p>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer"> 
                            <button type="button" class="btn btn-default" data-dismiss="modal" aria-label="Close">Entendido</button> 
                        </div>
                    </div>

                </div>
            </div>

            <div class="modal fade" id="modal_grupo_sin_caja" name="modal_grupo_sin_caja" tabindex="-1" role="dialog" aria-labelledby="modal_grupo_sin_caja" aria-hidden="true">
                <div class="modal-dialog" style="max-width: 390px;">                
                    <div class="modal-content">
                        <div class="modal-header">                                
                            <h5 class="modal-title" id="myModalLabel">Aviso</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <i class="ion-close-round"></i>
                            </button>
                        </div>                        
                        <div class="modal-body" style="max-height: 500px; overflow-y: auto;">
                            <div class="row">
                                <div class="col-12">
                                    <p class="subtitulo-modal">No se puede arrastrar un grupo sin caja asociada dentro de un bulto</p>
                                    <p>Los grupos sin caja están pensados apra que cada una de sus referencias generen un bulto independiente con las dimensiones y peso de cada referencia.</p>
                                    <p>Puedes arrastrar el grupo al área de "Nuevo bulto" para generar un bulto por referencia, o bien asignarle una caja en tu área de inventario.</p>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer"> 
                            <button type="button" class="btn btn-default" data-dismiss="modal" aria-label="Close">Entendido</button> 
                        </div>
                    </div>

                </div>
            </div>
             <p id="cajas_usuario" style="display:none;"></p>
        </div>         
         {$contador_bultos=1}
         {$max_bultos=$array_pesos|@count|escape:'htmlall':'UTF-8'}
         <script type="text/javascript">
             var array_precios = [];
             var max_bultos={$max_bultos|escape:'htmlall':'UTF-8'};
             if(max_bultos<30)
               $('#boton_aniadir_bulto').show();
           else
               $('#boton_aniadir_bulto').hide();
            if(max_bultos<2)
               $('#boton_eliminar_bulto').hide();
           else
               $('#boton_eliminar_bulto').show();
         </script>   
         <input type="hidden" id="text_max_bultos" name="text_max_bultos">
         <div id="div_bultos">
         {foreach key=key item=item from=$array_pesos}             
             <div id="bulto_{$key|escape:'htmlall':'UTF-8'}" class="col-md-12" style="margin-top:20px">
                <div id="pesos_y_medidas_bulto_{$key|escape:'htmlall':'UTF-8'}" class="col-md-6">
                    <div class="col-md-12">
                        <div class="col-md-2">
                            <label class="form-control">{l mod='genei' s ='Package'} {$key|escape:'htmlall':'UTF-8'}</label>            
                        </div>
                        <div class="col-md-2">
                            <label class="form-control" for="peso_{$key|escape:'htmlall':'UTF-8'}">{l mod='genei' s ='Weight'} kg.</label>
                            <input type="number" step="0.10" max="500.00" class="form-control peso_bulto pesos_medidas" name="peso_{$key|escape:'htmlall':'UTF-8'}" value="{$item|string_format:"%d"|escape:'htmlall':'UTF-8'}"/>
                        </div>
                        <div class="col-md-2">
                            <label class="form-control" for="largo_{$key|escape:'htmlall':'UTF-8'}">{l mod='genei' s ='Long'} cm.</label>
                            <input type="number" step="1" max="500.00" min="1.00" class="form-control pesos_medidas" name="largo_{$key|escape:'htmlall':'UTF-8'}" value="{$array_largos[$key]|string_format:"%d"|escape:'htmlall':'UTF-8'}"/>
                        </div>
                        <div class="col-md-2">
                            <label class="form-control" for="ancho_{$key|escape:'htmlall':'UTF-8'}">{l mod='genei' s ='Width'} cm.</label>
                            <input type="number" step="1" max="500.00" min="1.00" class="form-control pesos_medidas" name="ancho_{$key|escape:'htmlall':'UTF-8'}" value="{$array_anchos[$key]|string_format:"%d"|escape:'htmlall':'UTF-8'}"/>
                        </div>
                        <div class="col-md-2">
                            <label class="form-control" for="alto_{$key|escape:'htmlall':'UTF-8'}">{l mod='genei' s ='Height'} cm.</label>
                            <input type="number" step="1" max="500.00" min="1.00" class="form-control pesos_medidas" name="alto_{$key|escape:'htmlall':'UTF-8'}" value="{$array_altos[$key]|string_format:"%d"|escape:'htmlall':'UTF-8'}"/>
                        </div>
                            <div class="col-md-2"></div>                            
                    </div>                    
                </div>                   
                {if $zona_iva_exenta}
                <div id="contenido_y_valores_bulto_{$key|escape:'htmlall':'UTF-8'}" class="col-md-6">            
                    <div class="col-md-12">  
                        <div class="col-md-4">
                        <label class="form-control" for="contenido_envio">{l mod='genei' s ='Shipment content'}</label>
                        <input type="text" class="form-control" name="contenido_{$key|escape:'htmlall':'UTF-8'}" value="{$array_contenidos[$key|escape:'htmlall':'UTF-8']}"/>
                        </div>
                        <div class="col-md-4">
                        <label class="form-control" for="valor_envio_{$key|escape:'htmlall':'UTF-8'}">{l mod='genei' s ='Shipment value'} €.</label>
                            <input type="number" step="1" max="20000.00" min="1.00" class="form-control" name="valor_{$key|escape:'htmlall':'UTF-8'}" value="{$array_valores[$key]|string_format:"%d"|escape:'htmlall':'UTF-8'}"/>
                        </div>
                        <div class="col-md-4">
                        <label class="form-control" for="taric_envio_{$key|escape:'htmlall':'UTF-8'}">{l mod='genei' s ='TARIC code'}.</label>
                            <input type="text" class="form-control" name="taric_{$key|escape:'htmlall':'UTF-8'}" value=""/>
                        </div>
                        <input type="hidden" class="form-control" name="dni_contenido_{$key|escape:'htmlall':'UTF-8'}" value="{$array_dni_contenidos[$key|escape:'htmlall':'UTF-8']}"/>
                    </div>
                </div> 
               {/if}         
             </div>
         {/foreach}
         </div>        
         
         
         
         
         <div class="col-md-1 botones_aniadir_quitar_bultos" style="margin-top:20px">
          <button type="button" class="form-control" id="boton_aniadir_bulto" title="Añadir bulto" onclick="aniadir_bulto(max_bultos+1)" >+</button>&nbsp;
         </div>
         <div class="col-md-1  botones_aniadir_quitar_bultos" style="margin-top:20px">
          <button type="button" class="form-control" id="boton_eliminar_bulto" style="display:none" title="Eliminar bulto" onclick="eliminar_bulto(max_bultos)">-</button>
         </div>
         </div>
         
            
         
         
        <div class="panel col-md-12" style="margin-top:20px">
          <div class="col-md-2">
            <label class="form-control" for="contacto_salida">{l mod='genei' s ='From Contact'}</label>
            <input type="text" class="form-control" id="contacto_salida" name="contacto_salida" value=""/>
          </div>
          <div class="col-md-2">
            <label class="form-control" for="contacto_llegada">{l mod='genei' s ='To Contact'}</label>
            <input type="text" class="form-control" id="contacto_llegada" name="contacto_llegada" value=""/>
          </div>
          <div class="col-md-2">
            <label class="form-control" for="observaciones_salida">{l mod='genei' s ='From Observations'}</label>
            <input type="text" class="form-control" id="observaciones_salida" name="observaciones_salida" value="{$observaciones_recogida_defecto_genei|escape:'htmlall':'UTF-8'}"/>
          </div>
          <div class="col-md-2">
            <label class="form-control" for="observaciones_llegada">{l mod='genei' s ='To Observations'}</label>
            <input type="text" class="form-control" id="observaciones_llegada" name="observaciones_llegada" value="{$observaciones_entrega_defecto_genei|escape:'htmlall':'UTF-8'}"/>
          </div>
          <div class="col-md-2">
            <label class="form-control" for="codigo_mercancia">{l mod='genei' s ='Merchandise code (only needed for Correos)'}</label>            
            <select id="codigo_mercancia_genei" name="codigo_mercancia" class="select1 chosen-select">
                       {html_options options=$codigos_mercancia_genei selected=$codigo_mercancia_genei} 
                    </select>
          </div>
          <div class="col-md-2">            
          </div>
         </div>          
          
            </div>   
        {if $telefono_llegada_vacio_genei =='1'}
        <div class="col-md-12 alert alert-warning">
            <strong>{l mod='genei' s ='Warning! Your client not have a valid phone number. Shipments incidents are possible'}</strong>
        </div>
        {/if}
        {if $array_boxes_count > 0 && $atributos_defecto_genei_default != 1}
            <div class="col-md-12" style="margin-top:10px">        
                <strong>{l mod='genei' s ='This order was calculated with a Genei carrier and using a optimal packing based in:'} {$array_boxes_count|escape:'htmlall':'UTF-8'} {l mod='genei' s ='box(es), with sizes:'}</strong>
            </div>        
           <div class="col-md-12" style="margin-top:10px">
                {foreach name=outer item=boxes from=$array_boxes}                
                <hr />                
                {l mod='genei' s ='Box'} {$smarty.foreach.outer.iteration|escape:'htmlall':'UTF-8'}:
                <br/>
                    {foreach name=box key=key item=item from=$boxes}                    
                        {if $smarty.foreach.box.iteration == 1} 
                            {l mod='genei' s =$key}: {$item|escape:'htmlall':'UTF-8'} kg.<br />
                        {else}
                             {l mod='genei' s =$key}: {$item|escape:'htmlall':'UTF-8'} cm.<br />
                        {/if}
                    {/foreach}
                {/foreach}
           {/if}       
        </div>
            <div class="col-md-12" style="margin-top:10px;margin-bottom:10px">        
            <button class="btn btn-lg btn-success" id="boton_buscar_precios">{l mod='genei' s ='Search prices on Genei'}</button>
        </div>
         {if $envio_creado_codigo_envio =='#'} 



               

             
        </form>        
             {/if}
        <div id="div_precios" style="display:none" class="table-responsive topmargin20"></div>                        
        <input type="hidden" id="agencia_escogida_crear_envio" name="agencia_escogida_crear_envio" value="">
        <label id="label_switch_iva_parent" class="switch_iva" style="display:none;"><input type="checkbox" id="switch_iva" class="switch_iva-input" checked=""><span class="switch_iva-label" id="label_switch_iva" data-on="{l mod='genei' s='Without TAX'}" data-off="{l mod='genei' s='With TAX'}"></span><span class="switch_iva-handle"></span></label>
        <table id="tabla_precios" style="display:none" class="table table-striped topmargin20"><thead><tr><th></th><th style="cursor: pointer;">{l mod='genei' s='Agency'}</th><th style="cursor: pointer;">{l mod='genei' s='Pickup'}</th><th style="cursor: pointer;">{l mod='genei' s='Delivery'}</th><th style="cursor: pointer;">{l mod='genei' s='Cod'}</th><th>{l mod='genei' s='Label'}</th><th  style="cursor: pointer;">{l mod='genei' s='Service time days'}</th><th id="tabla_precios_campo_precio" style="cursor: pointer;">{l mod='genei' s='Amount'} €</th><th>{l mod='genei' s='Action'}</th></tr></thead><tbody id="tabla_precios_contenido"></tbody></table>
        
	{/if}
        {else}
            <div class="col-md-12" style="margin-bottom:20px">{l mod='genei' s ='Not logged in Genei'}</div>            
         {/if}
                </div>   
       {if {$estado_autenticacion_genei|escape:'htmlall':'UTF-8'} == "1" && {$direccion_predeterminada_genei|escape:'htmlall':'UTF-8'} != ''}
                 <!-- MODAL ESTABLECER_FECHA
    ====================== -->  
            <script>
                
     var id_agencia_madre;
     var porcentaje_reembolso;
     var porcentaje_seguro;
     var maximo_seguro;
     var minimo_reembolso;
     var maximo_reembolso;
     var importe;
     var importe_dto_promo;
     var permite_reembolsos;
     var servicio_recogida;
     var servicio_entrega;
     var iva;
     
                
                $(function() {
                    $("#fecha_recogida").datepicker({
                        beforeShowDay: $.datepicker.noWeekends,
                        minDate: 0
                    });
                });           
           
                                       
           </script>      
           
             <div class="modal fade bgcolor" id="modal_resumen_envio" name="modal_resumen_envio" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog" style="width:50%">                
            <div class="modal-content">
                <div class="modal-header">                                
                    <h4 class="modal-title" id="myModalLabel">{l mod='genei' s ='Shipment creation'}</h4>
                </div>                        
                <div class="modal-body">
                    <div id="div_activar_oficina_destino_correos_express" style="display:none;">
                        <input type="checkbox" id="activar_oficina_destino_correos_express" value="1" name="activar_oficina_destino_correos_express" onclick="click_activar_oficina_destino_correos_express()"/>
                        <label for="activar_oficina_destino_correos_express">{l mod='genei' s='Deliver to Office'}</label>
                    </div>
                    <div class="card mb-3" id="div_oficinas_destino" style="display:none;">
                                    <div class="card-body" id="div_map_oficinas_destino">
                                        <input type="hidden" id="oficinas_correos" name="oficinas_correos" value="1">
                                        <div class="infocard-imp">
                                            <i class="ion-alert-circled"></i>
                                            <p>{l mod='genei' s ='Choose a delivery point'}</p>
                                        </div>
                                        <div id="map_oficinas_destino" style="width:auto;height:300px;">
                                        </div>
                                    </div>
                                    <div id="div_select_oficinas_destino" class="form-group col-12">                                       
                                        <select id="select_oficinas_destino" name="select_oficinas_destino">                                            
                                        </select>
                                    </div>
                                </div>
                    <div class="row mb-5">
                        <div class="col-12 col-md-3" class="form-group" style="margin-bottom:20px;"> 
                            <input style="float:left;margin-right: 8px" type="checkbox" id="seguro_pag_pedido_genei" value="0" name="seguro_pag_pedido_genei" onclick="click_seguro()"/>                            
                            <label style="float:left;margin-right: 8px" for="seguro_pag_pedido_genei">{l mod='genei' s='Indemnification'}</label>
                            <input style="float:left;width:90px" type="number" class="form-control" step="0.5" id="cantidad_seguro_pag_pedido_genei" min="0" max="2999" style="width: 6em;" name="cantidad_seguro_pag_pedido_genei" value="0" disabled/>&nbsp;
                        </div>                        
                        <div class="col-12 col-md-3" class="form-group"> 
                            <input style="float:left;margin-right: 8px" type="checkbox" id="reembolso_pag_pedido_genei" value="0" name="reembolso_pag_pedido_genei" onclick="click_reembolso()"/>
                            <label style="float:left;margin-right: 8px" for="reembolso_pag_pedido_genei">{l mod='genei' s='Cod'}</label>                            
                            <input style="float:left;width:90px" type="number" class="form-control" step="0.5" id="cantidad_reembolso_pag_pedido_genei" min="0" max="2999" style="width: 6em;" name="cantidad_reembolso_pag_pedido_genei" value="0" disabled/>&nbsp;
                        </div>                        
                        <div class="col-12 col-md-3" class="form-control"> 
                            <input style="float:left;margin-right: 8px" type="checkbox" id="recoger_tienda_pag_pedido_genei" value="0" name="recoger_tienda_pag_pedido_genei" onclick="click_recoger_tienda()"/>
                            <label style="float:left;margin-right: 8px" for="recoger_tienda_pag_pedido_genei">{l mod='genei' s='No Pick-up'}</label>                            
                        </div>    
                        <div class="col-12 col-md-3" class="form-control" id="div_entregar_oficina_chrono_pag_pedido_genei" style="display:none;"> 
                            <input style="float:left;margin-right: 8px" type="checkbox" id="entregar_oficina_chrono_pag_pedido_genei" value="0" name="entregar_oficina_chrono_pag_pedido_genei" onclick="click_entregar_oficina_chrono()"/>
                            <label style="float:left;margin-right: 8px" for="entregar_oficina_chrono_pag_pedido_genei">{l mod='genei' s='Deliver to Office'}</label>
                        </div>    
                    </div>            
                    <div class="col-md-12" style="display:none;" id="capa_mercancias_correos">
           <div class="col-md-8">
            <label for="tipo_mercancia_correos_genei" class="text-left">{l s='Correos goods type:' mod='genei'}</label>
            <select class="form-control" name="tipo_mercancia_correos_genei" id="tipo_mercancia_correos_genei">
                {html_options options=$array_mercancias_correos}
            </select>
        </div>  
       <div class="col-md-4" style="margin-bottom:20px">
            <label for="valor_mercancia_correos_genei" class="text-left">{l s='Correos goods value:' mod='genei'}</label>
            <input type="number" step="1" max="20000" min="0" class="form-control" name="valor_mercancia_correos_genei" id="valor_mercancia_correos_genei" value="1" style="width:90px;">
       </div> 
        </div> 
        <div class="col-md-12">
           <div class="col-md-6" style="margin-bottom:20px">      
               <label for="fecha_recogida" class="text-left">{l mod='genei' s ='Select date and pick-up interval'}</label>
               
          <input name="fecha_recogida" id="fecha_recogida" value="" placeholder="{l mod='genei' s ='click/tap to select'}" id="fecha_recogida" onchange='javascript:pon_horas(id_agencia_crear_envio,id_usuario_crear_envio,codigos_origen_crear_envio,codigos_destino_crear_envio,id_pais_salida_crear_envio,id_pais_llegada_crear_envio);' type="text">
          </div>          
          <div id="capa_horas" name="capa_horas" class="col-md-3">
            <div class="col-md-12">
                <div class="col-md-6">              
                    <label for="id_d_intervalo" class="text-left">{l mod='genei' s ='From:'}</label>
                    <select name="id_d_intervalo" id="id_d_intervalo" placeholder="{l mod='genei' s ='From hour'}" style="margin-left:5px;margin-right:5px;" onchange="cambiar_desde()"></select>                
                </div>
                <div class="col-md-6">              
                    <label for="id_d_intervalo" class="text-left">{l mod='genei' s ='To:'}</label>                      
                    <select name="id_h_intervalo" id="id_h_intervalo" placeholder="{l mod='genei' s ='To Hour'}" style="margin-left:5px" onchange="cambiar_hasta()"></select>                                  
                </div>
            </div>  
          </div>
          <div class="col-md-3">
            <label class="form-control" for="codigo_promocional_pag_pedido_genei">{l mod='genei' s='Promo code'}</label>
            <input type="text" class="form-control" id="codigo_promocional_pag_pedido_genei" name="codigo_promocional_pag_pedido_genei" width="70px"/><a href="javascript:check_cod_promo();"><button id="boton_cerrar_fin_envio" type="button" class="form-control btn btn-default">{l mod='genei' s ='Check'}</button></a>
            <input type="hidden" class="form-control" id="descuento_codigo_descuento" value="0"/>            
            
            <div id="span_codigo_valido" class="col-md-12" style="display:none;">
                <span style="background-color:#40c744b5">{l mod='genei' s='Valid promo code'}</span>  
            </div>
            <div id="span_codigo_invalido" class="col-md-12" style="display:none;">
                <span style="background-color:#ff0023ba">{l mod='genei' s='Invalid promo code'}</span>
            </div>
          </div>
        </div>                
                  <div class="col-md-12" style="margin-bottom:20px;">
            <section id="seccion_resumen_precio" style="border: 1px solid green;padding: 10px;">
                <div class="row">
                    <div class="col-12 col-md-2">
                        <p class="resumen_titulo">{l mod='genei' s='Base amount'}:</p>
                        <p class="resumen_cuerpo"><span id="resumen_importe_base"></span> €</p>
                    </div>
                    <div class="col-12 col-md-2">
                        <p class="resumen_titulo">{l mod='genei' s='Indemnification comission'}:</p>
                        <p class="resumen_cuerpo"><span id="resumen_comision_seguro"></span> €</p>
                    </div>
                    <div class="col-12 col-md-3">
                        <p class="resumen_titulo">{l mod='genei' s='COD comission'}:</p>
                        <p class="resumen_cuerpo"><span id="resumen_comision_reembolso"></span> €</p>
                    </div>
                    <div class="col-12 col-md-2">
                        <p class="resumen_titulo">{l mod='genei' s='Discount'}:</p>
                        <p class="resumen_cuerpo"><span id="resumen_descuento"></span> €</p>
                    </div>
                    <div class="col-12 col-md-2">
                        <p class="resumen_titulo">{l mod='genei' s='Picking'}:</p>
                        <p class="resumen_cuerpo"><span id="resumen_picking"></span> €</p>
                    </div>    
                    <div class="col-12 col-md-2">                        
                    </div>    
                </div>
                <div class="row">
                    <div class="col-12 col-md-3">
                        <p class="resumen_titulo">{l mod='genei' s='Base total'}:</p>
                        <p class="resumen_cuerpo"><span id="resumen_total_importe_base"></span> €</p>
                    </div>
                    <div class="col-12 col-md-3">
                        <p class="resumen_titulo">{l mod='genei' s='VAT amount'}:</p>
                        <p class="resumen_cuerpo"><span id="resumen_iva"></span> €</p>
                    </div>
                        <div class="col-12 col-md-3">
                        <p class="resumen_titulo"></p>
                        <p class="resumen_cuerpo"></p>
                    </div>
                    <div id="importe_total_caja" class="col-12 col-md-3">
                        <p class="resumen_titulo"><strong>{l mod='genei' s='Total Amount'}:</strong></p>
                        <p class="resumen_cuerpo"><strong><span id="resumen_total_importe"></span> €</strong></p>
                    </div>
                </div>       
            </section>
            </div>
            <div class="col-md-12">
            <button type="button" class="btn btn-lg btn-success" style="display:none" id="boton_crear_envio" name="boton_crear_envio" onclick="crear_envio();">{l mod='genei' s ='Create shipment'}</button>
          </div>                        
          <div class="col-md-12">
            <div class="form-group" style="display:none" id="div_observaciones_almacen" >
                <label for="observaciones_almacen">{l mod='genei' s='Warehouse notes'}</label>
                <textarea id="observaciones_almacen" name="observaciones_almacen" maxlength="200"></textarea>
            </div>
              
          </div>                        
            </div>                                    
                <div class="modal-footer"> 
                    <div id="div_espera" class="pull-left"></div>
                    <a href="#"><button id="boton_cerrar_fin_envio" style="margin-top:10px" type="button" class="btn btn-default" data-dismiss="modal">{l mod='genei' s ='Close'}</button></a>
                </div>
            </div>

        </div>
    </div>
    <!-- MODAL ESTABLECER_FECHA end -->  
<!-- MODAL FECHA_INVALIDA_RECOGIDA
    ====================== -->
    <div class="modal fade bgcolor" id="modal_fecha_invalida_recogida" style="display:none;" name="modal_fecha_invalida_recogida" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog" style="width:70%">                
            <div class="modal-content">
                <div class="modal-header">                                
                    <h4 class="modal-title" id="myModalLabel">{l mod='genei' s ='Invalid pick-up date'}</h4>
                </div>                        
                <div class="modal-body" style="width:70%;max-width:80%;">
                    {l mod='genei' s ='There is no hours available for pick-up in selected date'}
                </div>
                <div class="modal-footer">
                    <a href="#"><button id="boton_cerrar_fin_envio" type="button" class="btn btn-default" data-dismiss="modal">{l mod='genei' s ='Close'}</button></a>
                </div>
            </div>
        </div>
    </div>
    <!-- MODAL MODAL FECHA_INVALIDA_RECOGIDA end -->  
 <!-- MODAL ESPERA
    ====================== -->
    <div class="modal fade bgcolor" id="modal_espera_creacion_envio" name="modal_espera_creacion_envio" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog" style="width:70%">                
            <div class="modal-content">
                <div class="modal-header">                                
                    <h4 class="modal-title" id="myModalLabel">{l mod='genei' s ='Creating shipment'}</h4>
                </div>                        
                <div class="modal-body" style="width:70%;max-width:80%;">

                </div>
                <div class="modal-footer">                                                        
                </div>
            </div>

        </div>
    </div>
    <!-- MODAL ESPERA end -->  
    
    <!-- MODAL ERROR CREACION ENVIO
       ====================== -->
    <div style="display: none;" class="modal fade bgcolor in" id="modal_error_creacion_envio" name="modal_error_creacion_envio" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog" style="width:70%">                
            <div class="modal-content">
                <div class="modal-header">                                
                    <h4 class="modal-title" id="myModalLabel">Error en la creación del envío</h4>
                </div>                        
                <div class="modal-body" style="max-height:500px;overflow-y: scroll;">

                    
                </div>
                <div class="modal-footer"> 
                    <a href="javascript:location.reload();"><button id="boton_cerrar_fin_envio" type="button" class="btn btn-default" data-dismiss="modal">{l mod='genei' s ='Close'}</button></a>
                </div>
            </div>

        </div>
    </div> 
    <!-- MODAL ENVIO CREADO end -->  
     <!-- MODAL ADVERTENCIA CACHE
    ====================== -->
    <div class="modal fade bgcolor" id="modal_advertencia_cache" name="modal_advertencia_cache" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog" style="width:70%">                
            <div class="modal-content">
                <div class="modal-header">                                
                    <h4 class="modal-title" id="myModalLabel">{l mod='genei' s ='Empty Prestashop Cache'}</h4>
                </div>                        
                <div class="modal-body" style="width:70%;max-width:80%;">
                    <h3>{l mod='genei' s = 'Remember clean PrestaShop cache under Advanced parameters -> Performance before installing new version.'}</h3>
                </div>
                <div class="modal-footer">                                                        
                    
                    <a href="#"><button id="boton_cerrar_ventana_advertencia_cache" type="button" class="btn btn-default" data-dismiss="modal">{l mod='genei' s ='Close'}</button></a>
                
                </div>
            </div>

        </div>
    </div>
    <!-- MODAL ADVERTENCIA CACHE end -->          
	<script type="text/javascript">
           var direccion_tiene_almacen = []; 
           var json_referencias_cantidades=null;
           
            Number.prototype.toFixed2 = function (precision) {
    var num = Number(this);
    return (+(Math.round(+(num + 'e' + precision)) + 'e' + -precision)).toFixed(precision);
}
    function inicializar_mapa(lat, lng, texto, div_mapa) {   
    if (isNaN(lat) || isNaN(lng))
        return;
    var myLatLng = { lat: lat, lng: lng };
    var map = new google.maps.Map(document.getElementById(div_mapa), {
        center: new google.maps.LatLng(myLatLng),
        zoom: 15
    });
    var contentString = '{l mod='genei' s ='Office'}';
    var infowindow = new google.maps.InfoWindow({
        content: contentString
    });
    var marker = new google.maps.Marker({
        position: myLatLng,
        map: map,
        title: texto
    });
    marker.addListener('click', function () {
        infowindow.open(map, marker);
    });
}

function popular_mapa(id_agencia, codigo_postal,select,div) {
    $('#'+select).empty();
    var cp_arr = codigo_postal.split(':');
    var cp = cp_arr[0];
    var poblacion = cp_arr[1];
    datos = {
        'id_agencia': id_agencia,
        'codigo_postal_oficina': cp,
        'poblacion': poblacion
    };
    $.ajax({        
    type: "POST",
    url: "{$geneiajaxcontrollerlink|escape:'htmlall':'UTF-8'}&action=get_lista_oficina",        
    data: {
        datos_json_get_lista_oficina:JSON.stringify(datos),
    }
    })
    .done(function(data, textStatus, jqXHR){           
            salida = $.parseJSON(data);            
            valor_inicial=[];
            var contador = 0;
            $.each(salida,function (i, val) {                
                if(contador == 0) {
                          valor_inicial.nombre_oficina = val.nombre_oficina;
                          valor_inicial.latitud = val.latitud;
                          valor_inicial.longitud = val.longitud;
                          valor_inicial.direccion = val.direccion;                          
                        }

                    $('#'+select).append($('<option>', {                            
                        value: val.id_oficina,
                        text: val.nombre_oficina + ', ' + val.direccion,
                        latitud: val.latitud,
                        longitud: val.longitud
                    }));
            contador++;    
            });            
            inicializar_mapa(parseFloat(valor_inicial.latitud), parseFloat(valor_inicial.longitud), valor_inicial.direccion, div);
            
            
            })
        .fail(function(jqXHR, textStatus, errorThrown){
    });
}
        function click_activar_oficina_destino_correos_express() 
        {       
            if($('#activar_oficina_destino_correos_express').attr('checked')=="checked") {
                permite_reembolsos = 0;
        }
    }
   
                function click_dropshipping()
                {
                    if($("#dropshipping_pag_pedido_genei").attr('checked')=="checked") {
                        $("#div_direccion_predeterminada_dropshipping_genei").show();
                        $("#dropshipping_pag_pedido_genei").val(1);
                    }
                    else {                        
                        $("#div_direccion_predeterminada_dropshipping_genei").hide();
                        $("#dropshipping_pag_pedido_genei").val(0);
                    }
                }
                function click_seguro() {                
                    if($("#seguro_pag_pedido_genei").attr('checked')=="checked") {                        
                      $("#cantidad_seguro_pag_pedido_genei").prop('disabled',false);
                      $("#seguro_pag_pedido_genei").val(1);
                  }                        
                    else {
                        $("#cantidad_seguro_pag_pedido_genei").val(0);
                      $("#cantidad_seguro_pag_pedido_genei").prop('disabled',true);                      
                      $("#seguro_pag_pedido_genei").val(0);
                  }
                  actualizar_precio_envio();
                }
                function click_recoger_tienda() {                
                    if($("#recoger_tienda_pag_pedido_genei").attr('checked')=="checked") {                                
                      $("#recoger_tienda_pag_pedido_genei").val(1);                
                  }                        
                    else {
                       $("#recoger_tienda_pag_pedido_genei").val(0);                       
                  }
                }
                function click_reembolso()
                {
                    if($("#reembolso_pag_pedido_genei").attr('checked')=="checked") {                        
                        $("#cantidad_reembolso_pag_pedido_genei").prop('disabled',false);
                        $("#reembolso_pag_pedido_genei").val(1);
                    }          
                    else {
                        $("#cantidad_reembolso_pag_pedido_genei").val(0);
                        $("#cantidad_reembolso_pag_pedido_genei").prop('disabled',true);
                        $("#reembolso_pag_pedido_genei").val(0);                        
                    }
                    actualizar_precio_envio();
                }
                
                
                function click_promo_code(cod_promo) {  
                    $("#valor_cod_promo").val(0);
                    if(cod_promo.length == 0)
                    {
                        $("#span_codigo_invalido").hide();   
                        $("#span_codigo_valido").hide();   
                        return;
                    }
                        
                    datos = {         
                    'codigo_promocional_pag_pedido_genei': cod_promo
                    }
                    $.ajax({        
                        type: "POST",
                        url: "{$geneiajaxcontrollerlink|escape:'htmlall':'UTF-8'}&action=comprobar_codigo_promocional",        
                        data: {
                            datos_json_promo_code:JSON.stringify(datos),
                        }     
                    })
                    .done(function(data, textStatus, jqXHR){
                       data_objeto= $.parseJSON(data);       
                       if(data_objeto != true)
                       {
                         $("#span_codigo_invalido").show();   
                         $("#span_codigo_valido").hide();
                         $("#codigo_promocional_pag_pedido_genei").val('');
                         $("#descuento_codigo_descuento").val(0);
                         actualizar_precio_envio();
                        
                          }
                       else
                       {
                        $("#span_codigo_invalido").hide();   
                        $("#span_codigo_valido").show();
                        obtener_valor_codigo_promo(cod_promo);
                      
                        }
                        
                    })
                    .fail(function(jqXHR, textStatus, errorThrown){                        
                    });                    
                }
                
                function obtener_valor_codigo_promo(cod_promo) {                        
                    datos = {         
                    'codigo_promocional_pag_pedido_genei': cod_promo
                    }
                    $.ajax({        
                        type: "POST",
                        url: "{$geneiajaxcontrollerlink|escape:'htmlall':'UTF-8'}&action=obtener_valor_codigo_promocional",
                        data: {
                            datos_json_promo_code:JSON.stringify(datos),
                        }     
                    })
                    .done(function(data, textStatus, jqXHR){
                       data_objeto= $.parseJSON(data);       
                       if(isNaN(data_objeto) || !(parseFloat(data_objeto) >0))
                          {
                        $("#span_codigo_invalido").show();   
                        $("#span_codigo_valido").hide();
                        $("#descuento_codigo_descuento").val(0);
                        actualizar_precio_envio();
                          }
                       else
                       {                           
                        $("#descuento_codigo_descuento").val(parseFloat(data_objeto));
                        actualizar_precio_envio();
                        }                        
                    })
                    .fail(function(jqXHR, textStatus, errorThrown){                        
                    });                    
                }
                function eliminar_bulto(num_bulto)
                {
                   ocultar_tabla_precios();
                   var div_bultos = document.getElementById("div_bultos");
                   div_bultos.removeChild(document.getElementById("bulto_"+num_bulto));
                   max_bultos--;
                   $('#text_max_bultos').val(max_bultos);
                   if(max_bultos<2)
                       $('#boton_eliminar_bulto').hide();
                }
    
                function aniadir_bulto(num_bulto,peso_bulto=1.00,alto_bulto=1.00,ancho_bulto=1.00,largo_bulto=1.00)
                {            
                                    
                    ocultar_tabla_precios();
                    var div_bultos = document.getElementById("div_bultos");
                    var div_bulto = document.createElement("div");
                    div_bulto.className='col-md-12';
                    div_bulto.style='margin-top:20px';
                    div_bulto.id='bulto_'+num_bulto;
                    div_bulto.innerHTML =   '<div id="pesos_y_medidas_bulto_'+num_bulto+'" class="col-md-6">'+
                                                '<div class="col-md-12">'+
                                                    '<div class="col-md-2">'+
                                                        '<label class="form-control">{l mod='genei' s ='Package'} '+num_bulto+'</label>'+
                                                    '</div>'+
                                                    '<div class="col-md-2">'+
                                                        '<label class="form-control" for="peso_'+num_bulto+'">{l mod='genei' s ='Weight'} kg.&nbsp;</label>'+
                                                        '<input type="number" step="0.1" class="form-control pesos_medidas" name="peso_'+num_bulto+'" min="1" max="500.00" value="'+peso_bulto+'"/>'+
                                                    '</div>'+
                                                    '<div class="col-md-2">'+
                                                        '<label class="form-control" for="largo_'+num_bulto+'">{l mod='genei' s ='Long'} cm.&nbsp;</label>'+
                                                        '<input type="number" step="1" class="form-control pesos_medidas" name="largo_'+num_bulto+'" min="1" max="500.00" value="'+largo_bulto+'"/>'+
                                                    '</div>'+
                                                    '<div class="col-md-2">'+
                                                        '<label class="form-control" for="ancho_'+num_bulto+'">{l mod='genei' s ='Width'} cm.&nbsp;</label>'+
                                                        '<input type="number" step="1" class="form-control pesos_medidas" name="ancho_'+num_bulto+'" min="1" max="500.00" value="'+ancho_bulto+'"/>'+
                                                    '</div>'+
                                                    '<div class="col-md-2">'+
                                                        '<label class="form-control" for="alto_'+num_bulto+'">{l mod='genei' s ='Height'} cm.&nbsp;</label>'+
                                                        '<input type="number" step="1" class="form-control pesos_medidas" name="alto_'+num_bulto+'" min="1" max="500.00" value="'+alto_bulto+'"/>'+
                                                    '</div>'+
                                                '</div>'+
                                            '</div>'+
                                            '<div id="contenido_y_valores_bulto_'+num_bulto+'" class="col-md-6">'+
                                                '<div class="col-md-12">'+                                                
                                                    '<div class="col-md-4">'+
                                                        '<label class="form-control" for="contenido_'+num_bulto+'">{l mod='genei' s ='Shipment content'}</label>'+
                                                        '<input type="text" class="form-control" name="contenido_'+num_bulto+'" value="{l mod='genei' s ='Content not specified'}"/>'+
                                                    '</div>'+
                                                    '<div class="col-md-4">'+
                                                        '<label class="form-control" for="valor_'+num_bulto+'">{l mod='genei' s ='Shipment value'} €.</label>'+
                                                        '<input type="number" step="0.5" class="form-control" name="valor_'+num_bulto+'" min="1.00" max="20000.00" value="1.00"/>'+
                                                    '</div>'+ 
                                                    '<div class="col-md-4">'+
                                                        '<label class="form-control" for="taric_'+num_bulto+'">{l mod='genei' s ='TARIC code'}.</label>'+
                                                        '<input type="text" class="form-control" name="taric_'+num_bulto+'" value=""/>'+
                                                    '</div>'+
                                                    '<input type="hidden" class="form-control" name="dni_contenido_'+num_bulto+'" value=""/>'+
                                                '</div>'+
                                            '</div>';
                                    
                    max_bultos++;
                    $('#text_max_bultos').val(max_bultos);
                    div_bultos.appendChild(div_bulto);  
                    if(max_bultos>1)
                       $('#boton_eliminar_bulto').show();     
}
function inicializar_ventana_resumen_creacion_envio() {
    
    $('#entregar_oficina_chrono_pag_pedido_genei').attr('checked',false);    
    $('#fecha_recogida').val('');
    $('#id_d_intervalo').val('');
    $('#id_h_intervalo').val('');
    $("#boton_crear_envio").hide();
    $("#seguro_pag_pedido_genei").attr('checked',false);
    $("#cantidad_seguro_pag_pedido_genei").val(0);
    $("#reembolso_pag_pedido_genei").attr('checked',false);
    $("#reembolso_seguro_pag_pedido_genei").val(0);
    $("#recoger_tienda_pag_pedido_genei").attr('checked',false);
    $("#id_d_intervalo").show();
    $("#id_h_intervalo").show();
    if(servicio_recogida !=1) {
        $("#recoger_tienda_pag_pedido_genei").val(1);
        $("#recoger_tienda_pag_pedido_genei").attr('checked',true);
     }
    
}
function preparar_crear_envio(id_agencia)
{    
    $("#activar_oficina_destino_correos_express").on('click', function () {
        if ($('#activar_oficina_destino_correos_express').prop('checked')) {  
            popular_mapa(id_agencia,"{$codigo_postal_destino_genei|escape:'htmlall':'UTF-8'}","select_oficinas_destino", "map_oficinas_destino");
            $("#div_oficinas_destino").show();
        } else {
           $("#div_oficinas_destino").hide();
           $("#select_oficinas_destino").val('');
        }
    });
    
     id_agencia_madre = $('#tragencia_'+id_agencia).data('id_agencia_madre');     
     if(id_agencia_madre == 1) {
        $('#div_activar_oficina_destino_correos_express').show();        
     } else {
        $('#div_activar_oficina_destino_correos_express').hide();             
     }
     iva_exento = $('#tragencia_'+id_agencia).data('iva_exento');
     iva = $('#tragencia_'+id_agencia).data('iva');
     maximo_seguro = $('#tragencia_'+id_agencia).data('maximo_seguro');     
     maximo_reembolso = $('#tragencia_'+id_agencia).data('maximo_reembolso');
     importe = $('#tragencia_'+id_agencia).data('importe');     
     importe_dto_promo = $('#tragencia_'+id_agencia).data('importe_dto_promo');
     if(iva_exento == 1) {         
         if(importe_dto_promo > 0) {
            importe_base = importe_dto_promo;            
        } else {
            importe_base = importe;            
        }
    } else {
        if(importe_dto_promo > 0) {
            importe_base = importe_dto_promo / (1+(iva/100));            
        } else {
            importe_base = importe / (1+(iva/100));            
        }    
    }
     
     permite_reembolsos = $('#tragencia_'+id_agencia).data('permite_reembolsos');
     maximo_seguro = $('#tragencia_'+id_agencia).data('maximo_seguro');
     if(!(maximo_seguro > 0)) {
        permite_seguro = 0;
     } else {
        permite_seguro = 1;
     }
     
     if(permite_reembolsos !=1) {
         $('#reembolso_pag_pedido_genei').attr('disabled',true);
         $('#reembolso_pag_pedido_genei').attr('title','{l mod='genei' s ='This carrier not allows COD'}');         
     } else {
         $('#reembolso_pag_pedido_genei').attr('disabled',false);
         $('#reembolso_pag_pedido_genei').attr('title','{l mod='genei' s =''}');         
     }
     if(permite_seguro !=1) {
         $('#seguro_pag_pedido_genei').attr('disabled',true);
         $('#seguro_pag_pedido_genei').attr('title','{l mod='genei' s ='This carrier not allows Indemnification'}');
     } else {
         
         $('#seguro_pag_pedido_genei').attr('disabled',false);
         $('#seguro_pag_pedido_genei').attr('title','{l mod='genei' s =''}');
         
     }
     servicio_recogida = $('#tragencia_'+id_agencia).data('servicio_recogida');
     permite_entregar_delegacion = $('#tragencia_'+id_agencia).data('permite_entregar_delegacion');
     if(servicio_recogida !=1) {
         $('#recoger_tienda_pag_pedido_genei').attr('disabled',true);
         $('#recoger_tienda_pag_pedido_genei').attr('checked',true);
         $("#recoger_tienda_pag_pedido_genei").val(1);
         $('#recoger_tienda_pag_pedido_genei').attr('title','{l mod='genei' s ='This carrier not allows pick-up'}');         
     } else {
         $('#recoger_tienda_pag_pedido_genei').attr('disabled',false);
         $('#recoger_tienda_pag_pedido_genei').attr('checked',false);
         $("#recoger_tienda_pag_pedido_genei").val(0);
         $('#recoger_tienda_pag_pedido_genei').attr('title','{l mod='genei' s =''}');         
         if(permite_entregar_delegacion !=1) {
         $('#recoger_tienda_pag_pedido_genei').attr('disabled',true);
         $('#recoger_tienda_pag_pedido_genei').attr('checked',false);
         $('#recoger_tienda_pag_pedido_genei').attr('title','{l mod='genei' s ='This carrier requires pick-up'}');         
     } else {
         $('#recoger_tienda_pag_pedido_genei').attr('disabled',false);
         $('#recoger_tienda_pag_pedido_genei').attr('checked',false);
         $('#recoger_tienda_pag_pedido_genei').attr('title','{l mod='genei' s =''}');         
     }
     }    
     if($("#recoger_tienda_pag_pedido_genei").attr('checked')=="checked") {                                
        $("#recoger_tienda_pag_pedido_genei").val(1);        
    }else {
        $("#recoger_tienda_pag_pedido_genei").val(0);        
    }
    
     servicio_entrega = $('#tragencia_'+id_agencia).data('servicio_entrega');
     porcentaje_reembolso = $('#tragencia_'+id_agencia).data('porcentaje_reembolso');
     porcentaje_seguro = $('#tragencia_'+id_agencia).data('porcentaje_seguro');     
     
    
     id_agencia_crear_envio=id_agencia;
     minimo_reembolso = parseFloat($('#tragencia_'+id_agencia).data('minimo_reembolso') / (1 + (iva / 100)));     
    switch(id_pais_llegada_crear_envio){
                 case 1:
                    var countrycode = 'ES';
                    break;
                case 8:
                    var countrycode = 'BE';
                    break;
                case 9:
                    var countrycode = 'LU';
                    break;
                default:
                    var countrycode = 'FR';
                    break;
    }            
    if(servicio_entrega !=1 || (id_agencia_madre == 1 && servicio_entrega ==1))    
    {        
        $('#modal_establecer_fecha .modal-body').css( { 'min-height': '410px' } );
        inicializar_ventana_resumen_creacion_envio();        
    }    
     $('#div_espera').html();
     $("#boton_crear_envio").hide();     
     $('#modal_resumen_envio').modal('show');  
     actualizar_precio_envio();
     fecha_hoy = moment().format('DD/MM/YYYY');    
     agencia_mapa_destino = $('#tragencia_'+id_agencia).data('agencia_mapa_destino');
     if(agencia_mapa_destino == 1 && id_agencia_madre!=1) {
         popular_mapa(id_agencia,"{$codigo_postal_destino_genei|escape:'htmlall':'UTF-8'}","select_oficinas_destino", "map_oficinas_destino");         
         $('#div_oficinas_destino').show();     
     } else {
        $('#div_oficinas_destino').hide();
        $("#select_oficinas_destino").val('');
        }
}






function actualizar_precio_envio()
{
    if (iva_exento == 1) {
        iva = 0;
    }    
    if (isNaN(porcentaje_reembolso)) {
        porcentaje_reembolso = 0;
    }    
    if (isNaN(porcentaje_seguro)) {
        porcentaje_seguro = 0;
    }
    var cantidad_reembolso = parseFloat($('#cantidad_reembolso_pag_pedido_genei').val());
    if (isNaN(cantidad_reembolso)) {
        cantidad_reembolso = 0;
    }
    var comision_reembolso = (cantidad_reembolso / (1 + (21 / 100))) * (porcentaje_reembolso / 100);

    
    if (comision_reembolso > 0 && comision_reembolso < minimo_reembolso) {
        comision_reembolso = minimo_reembolso;
    }
    var porcentaje_descuento_codigo_descuento = parseFloat($('#descuento_codigo_descuento').val());
    var descuento_codigo_descuento = (porcentaje_descuento_codigo_descuento/100) * importe_base;
    var cantidad_seguro = parseFloat($('#cantidad_seguro_pag_pedido_genei').val());
    var comision_seguro = (cantidad_seguro / (1 + (iva / 100))) * (porcentaje_seguro / 100);            
    var picking_base_aplicar = 0;
    var suplemento_picking_total = parseFloat($('#tragencia_'+id_agencia_crear_envio).data('suplemento_picking_total'));
    var suplemento_picking_total_con_iva = parseFloat($('#tragencia_'+id_agencia_crear_envio).data('suplemento_picking_total_con_iva'));
     if(iva_exento) {
        picking_base_aplicar = suplemento_picking_total;       
    } else {
        picking_base_aplicar = suplemento_picking_total_con_iva / (1+(iva / 100));
    }
    
    
    $('#resumen_picking').html(picking_base_aplicar.toFixed2(2));
    var importe_base_total = importe_base - descuento_codigo_descuento + comision_reembolso + comision_seguro + picking_base_aplicar;
    var importe_iva = importe_base_total * (iva / 100);    
    var importe_total = importe_base_total * (1 + (iva / 100));        
    
        
    $('#resumen_descuento').html(descuento_codigo_descuento.toFixed2(2));
    $('#resumen_comision_reembolso').html(comision_reembolso.toFixed2(2));    
    $('#resumen_comision_seguro').html(comision_seguro.toFixed2(2));
    $('#resumen_iva').html(importe_iva.toFixed2(2));    
    $('#resumen_importe_base').html(importe_base.toFixed2(2));
    $('#resumen_total_importe_base').html(importe_base_total.toFixed2(2));
    $('#resumen_total_importe').html(importe_total.toFixed2(2));

} 

function crear_envio()
{
    crear_envio_integrado(id_agencia_crear_envio,$("#recoger_tienda_pag_pedido_genei").val(),$('#fecha_recogida').val(),$('#id_d_intervalo').val(),$('#id_h_intervalo').val(),$('#reembolso_pag_pedido_genei').val(),$('#cantidad_reembolso_pag_pedido_genei').val(),$('#seguro_pag_pedido_genei').val(),$('#cantidad_seguro_pag_pedido_genei').val(),$('#codigo_promocional_pag_pedido_genei').val(),json_referencias_cantidades);
}

function crear_envio_integrado(id_agencia,recoger_tienda,fecha_recogida,hora_recogida_desde,hora_recogida_hasta,reembolso,cantidad_reembolso,seguro,cantidad_seguro,cod_promo,jrefc)
{
    var envio_desde_almacen = $('#tragencia_'+id_agencia).data('envio_desde_almacen');
    if(typeof($("#valor_mercancia_correos_genei").val())== 'undefined')
        $("#valor_mercancia_correos_genei").val(0);
    if(typeof($("#tipo_mercancia_correos_genei").val())== 'undefined')
        $("#tipo_mercancia_correos_genei").val('');
    $("#boton_crear_envio").html('<img src="https://www.genei.es/img/ajax-loader.svg";">');
    $("#boton_crear_envio").attr('disabled',true);
    $("#agencia_escogida_crear_envio").val(id_agencia);
   $('#div_precios').hide();
    var formJqObj = $("#form_buscar_precios");
    var formDataObj = { };
    formDataObj["id_order"] = '{$id_order|escape:'htmlall':'UTF-8'}';
    formDataObj["id_agencia"] = id_agencia.toString();    
    (function(){
        formJqObj.find(":input").not("[type='submit']").not("[type='reset']").each(function(){
            var thisInput = $(this);
            formDataObj[thisInput.attr("name")] = thisInput.val();            
        });
    })();
    
    formDataObj["agencia_escogida_crear_envio"] = $("#agencia_escogida_crear_envio").val();
    if(jrefc !== null) {
    formDataObj["stock_api"] = jrefc;
    }
    formDataObj["fecha_recogida"] = fecha_recogida;
    formDataObj["hora_recogida_desde"] = hora_recogida_desde;
    formDataObj["hora_recogida_hasta"] = hora_recogida_hasta;
    formDataObj["contrareembolso"] = reembolso;
    formDataObj["cantidad_reembolso"] = cantidad_reembolso;
    formDataObj["seguro"] = seguro;
    formDataObj["cantidad_seguro"] = cantidad_seguro;
    var suplemento_picking_total = parseFloat($('#tragencia_'+id_agencia).data('suplemento_picking_total'));
    var suplemento_picking_total_con_iva = parseFloat($('#tragencia_'+id_agencia).data('suplemento_picking_total_con_iva'));    
    formDataObj["suplemento_picking_total"] = suplemento_picking_total;
    formDataObj["suplemento_picking_total_con_iva"] = suplemento_picking_total_con_iva;
    formDataObj["envio_desde_almacen"] = envio_desde_almacen;
    
   
    
    formDataObj["cod_promo"] = cod_promo;    
    formDataObj["recoger_tienda_pag_pedido_genei"] = recoger_tienda;
    formDataObj["tipo_mercancia_correos_genei"] = $("#tipo_mercancia_correos_genei").val();
    formDataObj["valor_mercancia_correos_genei"] = $("#valor_mercancia_correos_genei").val();
    if($("#select_oficinas_destino").length > 0 && $("#select_oficinas_destino").val()!='') {
        formDataObj["select_oficinas_destino"] = $("#select_oficinas_destino").val();
    }
    if($("#activar_oficina_destino_correos_express").prop('checked')) {
        formDataObj["activar_oficina_destino_correos_express"] = 1;
    } else {
        formDataObj["activar_oficina_destino_correos_express"] = '';
    }   
    
    $.ajax({        
          type: "POST",
        url: "{$geneiajaxcontrollerlink|escape:'htmlall':'UTF-8'}&action=crear_envio",
        data: {
         datos_json_crear_envio:JSON.stringify(formDataObj),      
     }
    })
    .done(function(data, textStatus, jqXHR){       
       data_objeto= $.parseJSON(data);       
       if(data_objeto == null)
          {
             location.reload();       
          }
       else
       {
        if(data_objeto.resultado==0)
        {
            $('#modal_error_creacion_envio .modal-body').html(data_objeto.resultado_text);
            $('#modal_error_creacion_envio').modal('show');
        }
       else
       { 
           location.reload();          
       }
        }
    })
    .fail(function(jqXHR, textStatus, errorThrown){        
    });   
}
function lanzar_buscar_precios()
   {       
    $("#boton_buscar_precios").attr('disabled',true);
    $('#boton_buscar_precios').html('<img src="https://www.genei.es/img/ajax-loader.svg";">');     
    $("#label_switch_iva_parent").show();
    $('#div_precios').hide();    
    $('#tabla_precios_contenido').empty();
    url_lanzar_buscar_precios = "{$geneiajaxcontrollerlink|escape:'htmlall':'UTF-8'}&action=buscar_precios_genei";
    var formJqObj = $("#form_buscar_precios");
    var formDataObj = { };
    formDataObj["id_order"] = '{$id_order|escape:'htmlall':'UTF-8'}';    
    (function(){
        formJqObj.find(":input").not("[type='submit']").not("[type='reset']").each(function(){
            var thisInput = $(this);
            formDataObj[thisInput.attr("name")] = thisInput.val();
        });
    })();    
    $.ajax({
        type: "POST",
        url: url_lanzar_buscar_precios,
        data: {
         datos_json_obtener_datos_buscar_precios_genei:JSON.stringify(formDataObj),
     }
    })
    .done(function(data, textStatus, jqXHR){
        var importe_mostrar_sin_iva;
        var importe_mostrar_con_iva;
        $('#boton_buscar_precios').html('{l mod='genei' s ='Search prices on Genei'}');
        $("#boton_buscar_precios").attr('disabled',false);        
        
        array_precios_json = $.parseJSON(data);
       

        //array_precios_json = $.parseJSON(data);
        $(array_precios_json).each(function(i,val){        
        $.each(val,function(k,v){            
            if(v.iva_exento != 1) {
                if(v.importe_dto_promo > 0) {
                    importe_mostrar_sin_iva = v.importe_dto_promo / (1+(v.iva/100));
                    importe_mostrar_con_iva = v.importe_dto_promo;
                } else {
                    importe_mostrar_sin_iva = v.importe / (1+(v.iva/100));
                    importe_mostrar_con_iva = v.importe;
                }
            } else {
                if(v.importe_dto_promo > 0) {
                    importe_mostrar_sin_iva = v.importe_dto_promo;
                    importe_mostrar_con_iva = v.importe_dto_promo; 
                } else {
                    importe_mostrar_sin_iva = v.importe;
                    importe_mostrar_con_iva = v.importe; 
                }
            }
            if(v.permite_reembolsos != 1)
            {
                imagen_reembolso = '';
            } else {
                imagen_reembolso = '<div style="float:left;width:100%;"><i style="display:inline;" class="material-icons">euro_symbol</i><p style="display:inline;" class="textoiconos">&nbsp;{l mod='genei' s ='Allow COD'}</p></div>';
            }
            
            if(v.servicio_recogida != 1)
            {
                imagen_recogida = '<div style="float:left;width:100%;"><i style="display:inline;" class="material-icons">location_on</i><p style="display:inline;" class="textoiconos">&nbsp;{l mod='genei' s ='No Pickup'}</p></div>';
            } else {
                imagen_recogida = '<div style="float:left;width:100%;"><i style="display:inline;" class="material-icons">location_city</i><p style="display:inline;" class="textoiconos">&nbsp;{l mod='genei' s ='Allow Pickup'}</p></div>';
            }
            
            if(v.servicio_entrega != 1)
            {
                imagen_entrega = '<div style="float:left;width:100%;"><i style="display:inline;" class="material-icons">location_on</i><p style="display:inline;" class="textoiconos">&nbsp;{l mod='genei' s ='No Delivery'}</p></div>';
            } else {
                imagen_entrega = '<div style="float:left;width:100%;"><i style="display:inline;" class="material-icons">location_city</i><p style="display:inline;" class="textoiconos">&nbsp;{l mod='genei' s ='Allow Delivery'}</p></div>';
            }
            
            if(v.requiere_impresora != 1)
            {
                imagen_requiere_impresora = '';
            } else {
                imagen_requiere_impresora = '<div style="float:left;width:100%;"><i style="display:inline;" class="material-icons">local_printshop</i><p style="display:inline;" class="textoiconos">&nbsp;{l mod='genei' s ='Requires label'}</p></div>';
            }            
            $('#tabla_precios_contenido').append('<tr style="{ cursor: default; }.highlight { background: yellow; }" id="tragencia_'+v.id_agencia+'" data-iva="'+v.iva+'" data-porcentaje_reembolso="'+v.porcentaje_reembolso+'" data-porcentaje_seguro="'+v.porcentaje_seguro+'" data-permite_reembolsos="'+v.permite_reembolsos+'" data-servicio_recogida="'+v.servicio_recogida+'" data-servicio_entrega="'+v.servicio_entrega+'" data-id_agencia_madre="'+v.id_agencia_madre+'" data-maximo_seguro="'+v.maximo_seguro+'" data-minimo_reembolso="'+v.minimo_reembolso+'" data-suplemento_picking_total="'+v.suplemento_picking_total+'" data-suplemento_picking_total_con_iva="'+v.suplemento_picking_total_con_iva+'" data-envio_desde_almacen="'+v.envio_desde_almacen+'" data-permite_entregar_delegacion="'+v.permite_entregar_delegacion+'" data-maximo_reembolso="'+v.maximo_reembolso+'" data-agencia_mapa_destino="'+v.agencia_mapa_destino+'" data-id_agencia_madre="'+v.id_agencia_madre+'" data-importe="'+v.importe+'" data-importe_dto_promo="'+v.importe_dto_promo+'" data-iva_exento="'+'" data-permite_reembolsos="'+v.permite_reembolsos+'" data-servicio_recogida="'+v.iva_exento+'"><td><img src="https://www.genei.es/'+v.imagen_agencia+'" height="80"></td><td>'+v.nombre_agencia+'</td><td>'+imagen_recogida+'</td><td>'+imagen_entrega+'</td><td>'+imagen_reembolso+'</td><td>'+imagen_requiere_impresora+'</td><td>'+v.servicio+'</td><td><span class="lista_importes_sin_iva">'+importe_mostrar_sin_iva.toFixed2(2)+'</span><span class="lista_importes_con_iva" style="display:none">'+importe_mostrar_con_iva.toFixed2(2)+'</span></td><td><a href="javascript:preparar_crear_envio('+v.id_agencia+');"><button type="button">{l mod='genei' s='Create shipment'}</button></a></td></tr>');

        });        
        });        
        $('#div_precios').show();
        $('#tabla_precios_campo_precio').click();
    })
    .fail(function(jqXHR, textStatus, errorThrown){
        $('#boton_buscar_precios').html('{l mod='genei' s ='Search prices on Genei'}');        
    });    
 }
 







 function establecer_bultos_almacen() { 
 console.log('actualizo bultos almacen'); 
 bultos_almacen = obtener_peso_medidas_bultos();
 max_bultos = 0;
 $('#text_max_bultos').val(max_bultos);
 document.getElementById("div_bultos").innerHTML = '';        
 
    
    bultos_almacen.forEach(function(i,val) {
        aniadir_bulto(val,i.peso,i.alto,i.ancho,i.largo);
    });
    $('.pesos_medidas').prop('readonly', true);
    $('.botones_aniadir_quitar_bultos').hide();
    
    json_referencias_cantidades = construir_datos_bultos_inventario();
    contador_elementos_form = 1;
  }
 
 function lanzar_obtener_datos_pedido(almacen=0)
   {    
     var formJqObj = $("#form_buscar_precios");
    var formDataObj = { };
    formDataObj["id_order"]='{$id_order|escape:'htmlall':'UTF-8'}';
    (function(){
        formJqObj.find(":input").not("[type='submit']").not("[type='reset']").each(function(){
            var thisInput = $(this);
            formDataObj[thisInput.attr("name")] = thisInput.val();
        });
    })();
    
    if(almacen !='1') {    
       bultos_almacen = null;
       json_referencias_cantidades = null;
    }
    
    $.ajax({
        type: "POST",
        url: "{$geneiajaxcontrollerlink|escape:'htmlall':'UTF-8'}&action=obtener_datos_pedido",
        data: {
         datos_json_obtener_datos_pedido_genei:JSON.stringify(formDataObj),
     }
    })
    .done(function(data, textStatus, jqXHR){        
        array_datos_pedido_json = $.parseJSON(data);    
        
        $(array_datos_pedido_json).each(function(i,val){                
        codigos_origen_crear_envio = val.codigos_origen;
        id_usuario_crear_envio = val.id_usuario;
        codigos_destino_crear_envio = val.codigos_destino;
        id_pais_salida_crear_envio = val.id_pais_salida;
        id_pais_llegada_crear_envio = val.id_pais_llegada;
        select_oficinas_destino = val.select_oficinas_destino;
        lanzar_buscar_precios();
          
        });      
    })
    .fail(function(jqXHR, textStatus, errorThrown){        
    });    
 }
 
function ocultar_tabla_precios()
{
    $("#tabla_precios").hide();    
}
function actualizar_estado_envio(codigo_envio)
{    
    
    $("#boton_actualizar_estado").html('{l mod='genei' s ='Updating....'}');
    $("#boton_actualizar_estado").prop('disabled', true);
     datos = {         
        'id_order': '{$id_order|escape:'htmlall':'UTF-8'}'  
    }
    $.ajax({
        type: "POST",
        url: "{$geneiajaxcontrollerlink|escape:'htmlall':'UTF-8'}&action=actualizar_estado_pedido",
        data: {
         datos_json_actualizar_estado_pedido_genei:JSON.stringify(datos),
     }
    })
    .done(function(data, textStatus, jqXHR){        
            location.reload();              
          
    })
    .fail(function(jqXHR, textStatus, errorThrown){        
    });        
}


function mostrar_ocultar_bultos_almacen(){    
    if(direccion_tiene_almacen[$("#direccion_predeterminada_genei").val()]=='1') {        
         $('.pesos_medidas').prop('readonly', true);
         $('.botones_aniadir_quitar_bultos').hide();
        $("#div_dropshipping").hide();        
        $("#drag_drop_warehouse").show();        
        $('.bultos-cuerpo').html('');        
        cargar_js_drag_drop_warehouse();
        //pinta_bulto_inventario();
    } else {
        json_referencias_cantidades=null;
        $('.pesos_medidas').prop('readonly', false);
        $('.botones_aniadir_quitar_bultos').show();
        $("#drag_drop_warehouse").hide();
        $("#div_dropshipping").show();
    }
}

$(document).ready(function()
{         
    
    
    
    const getCellValue = (tr, idx) => tr.children[idx].innerText || tr.children[idx].textContent;

const comparer = (idx, asc) => (a, b) => ((v1, v2) => 
    v1 !== '' && v2 !== '' && !isNaN(v1) && !isNaN(v2) ? v1 - v2 : v1.toString().localeCompare(v2)
    )(getCellValue(asc ? a : b, idx), getCellValue(asc ? b : a, idx));

// do the work...
document.querySelectorAll('#tabla_precios th').forEach(th => th.addEventListener('click', (() => {
  const table = th.closest('#tabla_precios');
  const tbody = table.querySelector('tbody');
  Array.from(tbody.querySelectorAll('tr'))
    .sort(comparer(Array.from(th.parentNode.children).indexOf(th), this.asc = !this.asc))
    .forEach(tr => tbody.appendChild(tr) );
    })));
    
  
    
    $("#switch_iva").on('click', function () {        
        if ($('#switch_iva').prop('checked')) {            
            $(".lista_importes_con_iva").hide();
            $(".lista_importes_sin_iva").show();
        } else {
           $(".lista_importes_sin_iva").hide();
           $(".lista_importes_con_iva").show();
           
        }
    });
    
    $(".peso_bulto").on('change', function (){
        $(this).val(parseFloat($(this).val()).toFixed2(2));
  }); 
    
    
    {foreach key=key item=item from=$direcciones_almacen_genei}
             direccion_tiene_almacen['{$key|escape:'htmlall':'UTF-8'}']='{$item|escape:'htmlall':'UTF-8'}';
            {/foreach}
     mostrar_ocultar_bultos_almacen();
        $("#direccion_predeterminada_genei").on('change', function (){
           mostrar_ocultar_bultos_almacen();
        });
    
    $("#select_oficinas_destino").on('change', function (){
       latitud=( $(this).find(":selected").attr('latitud') );  
       longitud=( $(this).find(":selected").attr('longitud') ); 
       texto = ( $(this).find(":selected").text() ); 
       
       inicializar_mapa(parseFloat(latitud), parseFloat(longitud), texto, 'map_oficinas_destino');       
    });
    
    $(".chosen-select").chosen();
    $("#div_direccion_predeterminada_dropshipping_genei").hide();
    
    if(typeof max_bultos == 'undefined')
        max_bultos=1;
    $('#text_max_bultos').val(max_bultos);
    if(max_bultos>1)
       $('#boton_eliminar_bulto').show();
$("#form_buscar_precios").submit(function(event){    
$("#tabla_precios").show();    
event.preventDefault(); 
lanzar_obtener_datos_pedido(direccion_tiene_almacen[$("#direccion_predeterminada_genei").val()]);

});


$('#cantidad_reembolso_pag_pedido_genei').on('change', function () { 
actualizar_precio_envio();
});
$('#cantidad_seguro_pag_pedido_genei').on('change', function () { 
actualizar_precio_envio();
});

    
    
});

function check_cod_promo() { 
var cod_promo = $('#codigo_promocional_pag_pedido_genei').val();
cod_promo = cod_promo.toUpperCase();
$('#codigo_promocional_pag_pedido_genei').val(cod_promo);
click_promo_code(cod_promo);
}

(function($) {     
     $.fn.fillValues = function(options) {
         var settings = $.extend({
             datas : null, 
             complete : null,
         }, options);

         this.each( function(){
            var datas = settings.datas;
            if(datas !=null) {
                $(this).empty();
                for(var key in datas){
                    $(this).append('<option value="'+key+'"+>'+datas[key]+'</option>');
                }
            }
            if($.isFunction(settings.complete)){
                settings.complete.call(this);
            }
        });

    }

}(jQuery));

function pon_horas(id_agencia_crear_envio,id_usuario_crear_envio,codigos_origen_crear_envio,codigos_destino_crear_envio,id_pais_origen_crear_envio,id_pais_destino_crear_envio)
{
    $("#boton_crear_envio").hide();
    datos = {        
        'id_agencia': id_agencia_crear_envio,
        'fecha_recogida_aux': $('#fecha_recogida').val(),
        'id_usuario': id_usuario_crear_envio,
        'codigos_origen': codigos_origen_crear_envio,
        'codigos_destino': codigos_destino_crear_envio,
        'id_pais_origen': id_pais_origen_crear_envio,
        'id_pais_destino': id_pais_destino_crear_envio,
        'id_order' : '{$id_order|escape:'htmlall':'UTF-8'}'
    };
    //llamamos a traves de ajax al controlador con los datos para que guarde la direccion.
    $('#div_espera').html('<span style="color:red;">{l mod='genei' s ='Retrieving pick-up information ....'}</span>');
    $('#div_espera').show();
     $.ajax({
        type: "POST",
        
        url: "{$geneiajaxcontrollerlink|escape:'htmlall':'UTF-8'}&action=obtener_horas_recogida",
        data: {
         datos_json_obtener_horas_recogida_genei:JSON.stringify(datos),        
     }
    })
    .done(function(data, textStatus, jqXHR){
         $('#div_espera').html('');        
        array_horas_recogida = $.parseJSON(data);   
         $(array_horas_recogida).each(function(i,val){
          horario_recogida = val.horario;
          if(horario_recogida!=false)
          {
          $(horario_recogida).each(function(j,val_horario_recogida){
            horario_recogida_inicial = val_horario_recogida.inicial;
            horario_recogida_final = val_horario_recogida.final;
          });  
         
          nuevas_fechas_y_horas = val.nuevas_fechas_y_horas; 
          $(nuevas_fechas_y_horas).each(function(k,val_nuevas_fechas_y_horas){
            fecha_hoy = val_nuevas_fechas_y_horas.fecha_hoy;
            fecha_hora_hoy = val_nuevas_fechas_y_horas.fecha_hora_hoy;
          });
         
          intervalo_recogida = val.intervalo_recogida;
              $("#id_d_intervalo").show();
              $("#id_h_intervalo").show();
              $("#boton_crear_envio").show();
        $("#id_d_intervalo").fillValues({
            datas:horario_recogida_inicial,
        });
        $("#id_h_intervalo").fillValues({
            datas:horario_recogida_final,
        });
    
        }
        else  {
            if($("#recoger_tienda_pag_pedido_genei").attr('checked')=="checked") { 
                 $("#id_d_intervalo").val('09:00');
                 $("#id_h_intervalo").val('15:00');
            } else {
              $("#boton_crear_envio").hide();
              $('#modal_fecha_invalida_recogida').modal('show');
          }
              $("#id_d_intervalo").hide();
              $("#id_h_intervalo").hide();
            
        }
      
    });    
          
    })
    .fail(function(jqXHR, textStatus, errorThrown){        
    });    
}        
 
            function cambiar_desde() {
                var valor_desde = $("#id_d_intervalo option:selected").val();
                var momento_enviado = $('#fecha_recogida').val() + ' ' + valor_desde;
                var nuevo_valor_hasta = moment(momento_enviado, 'DD/MM/YYYY HH:mm').add(intervalo_recogida, 'hour');
                $('#id_h_intervalo').val(moment(nuevo_valor_hasta).format('HH:mm'));
            }
            function cambiar_hasta() {
                var valor_hasta = $("#id_h_intervalo option:selected").val();
                var valor_desde = $("#id_d_intervalo option:selected").val();
                var momento_enviado_hasta = $('#fecha_recogida').val() + ' '+ valor_hasta;
                var momento_enviado_desde = $('#fecha_recogida').val() + ' '+ valor_desde;
                var nuevo_valor_desde = moment(momento_enviado_hasta, 'DD/MM/YYYY HH:mm').subtract(intervalo_recogida, 'hour');
                nuevo_valor_desde_formateado = moment(nuevo_valor_desde).format('YYYY-MM-DD HH:mm');
                if (nuevo_valor_desde < moment(momento_enviado_desde, 'DD/MM/YYYY HH:mm'))
                    $('#id_d_intervalo').val(moment(nuevo_valor_desde_formateado).format('HH:mm'));
            }


function guardar_configuracion_genei()
{  
    url_guardar_configuracion_genei="{$geneiajaxcontrollerlink|escape:'htmlall':'UTF-8'}&action=guardar_configuracion_genei";
    $('#boton_guardar_configuracion_genei').prop('disabled', true);       
    datos = {     
        'usuario_servicio': $('#usuario_servicio_genei').val(),
        'password_servicio': $('#password_servicio_genei').val(),
        'metodo_pago_contrareembolso_defecto_genei_default': $('#metodo_pago_contrareembolso_defecto_genei_default').val(),
        'atributos_defecto_genei_default': $('#atributos_defecto_genei_default').val(),
        'peso_defecto_genei': $('#peso_defecto_genei').val(),
        'largo_defecto_genei': $('#largo_defecto_genei').val(),
        'ancho_defecto_genei': $('#ancho_defecto_genei').val(),
        'alto_defecto_genei': $('#alto_defecto_genei').val(),
        'num_bultos_defecto_genei': $('#num_bultos_defecto_genei').val(),
        'estado_recogida_tramitada_genei_default': $('#estado_recogida_tramitada_genei_default').val(),
        'estado_envio_transito_genei_default': $('#estado_envio_transito_genei_default').val(),
        'estado_envio_incidencia_genei_default': $('#estado_envio_incidencia_genei_default').val(),
        'estado_envio_entregado_genei_default': $('#estado_envio_entregado_genei_default').val(),
        'estados_automaticos_pedidos_genei': $('#estados_automaticos_pedidos_genei').val(),        
        'variation_type_genei': $('#variation_type_genei').val(),
        'variation_price_amount_genei': $('#variation_price_amount_genei').val(),    
        'direccion_predeterminada_genei': $('#direccion_predeterminada_genei').val()        
    }        
     $.ajax({
        type: "POST",
        url: url_guardar_configuracion_genei,
        data: {
         datos_json_guardar_configuracion_genei:JSON.stringify(datos),
     }
    })
    .done(function(data, textStatus, jqXHR){
        location.reload();    
});
}








function cargar_js_drag_drop_warehouse () {
    obtener_cajas_usuario();

    let id_usuario = '{$id_usuario|escape:'htmlall':'UTF-8'}';
    
    //Funciones click
    $(document).on('click', '.borrar-bulto-inventario', borrar_bulto_inventario);
    $(document).on('click', '.aniadir-bulto-inventario', { tipo: 'bulto-inventario'}, desplegar_aside);
    $(document).on('click', '.editar-bulto-inventario', { tipo: 'bulto-inventario'}, desplegar_aside);
    $(document).on('click', '.aniadir-bulto-inventario-drop', generar_nuevo_bulto_inventario);
    $(document).on('click', '#cerrar-aside', cerrar_aside);
    $(document).on('click', '.grupo-inventario-fila .icono-desplegar', mostrar_info_grupo_referencias);
    $(document).on('click', '.resta', restar);
    $(document).on('click', '.suma', sumar);
    $(document).on('click', '.caja-bulto-inventario', almacenar_valor_previo);
    $(document).on('click', '#muestra-referencias', mostrar_referencias);
    $(document).on('click', '#muestra-grupos', mostrar_grupos);

    //Funciones change
    $(document).on('change', '.caja-bulto-inventario', quitar_caja_bulto_inventario);

    //Funciones keyup
    $(document).on('keyup', '#filtro_referencias', function (e) {
        if ($('#filtro_referencias').val() == '') {
            //Carga todas las referencias del usuario cuando éste borra la búsqueda
            $('#listado-referencias-inventario').remove();
            cargar_referencias_usuario();
        }
    });
   
    //Funciones focus
    $(document).on('focus', '#filtro_referencias', function (e) {
        //Funcion de autocompletar para el filtrado de referencias
        if (!$(this).data("autocomplete")) { //If the autocomplete wasn't called yet
            $("#filtro_referencias").autocomplete({
                delay: 0,
                autoFocus: true,
                minLength: 4,
               
                source: function (request, response) { //MUESTRA LAS OPCIONES DEL AUTOCOMPLETE                     
                    $.ajax({
                        url: "{$geneiajaxcontrollerlink|escape:'htmlall':'UTF-8'}&action=getUserRefs",
                        dataType: 'json',
                        type: 'POST',
                        data: {
                            'id_usuario': id_usuario,
                            'tipo': 1,
                            'cantidades': 'si',
                            'autocompletar': $("#filtro_referencias").val()
                        },
                        success: function (data) {
                            //Muestra los resultados en el menú de elementos draggables
                            $('#listado-referencias-inventario').remove();
                            cargar_referencias_usuario('', 1, data);
                        }
                    });
                },
                selectFirst: true
            });
        }
    });

}

function borrar_bulto_inventario() {
    let numero_bultos_inventario = obtener_numero_bultos_inventario();
    let referencias_bulto = $(this).parents('.bulto-inventario').find('.bulto-inventario-dragado');

    if (numero_bultos_inventario > 1) {
        if (referencias_bulto.length > 0) {
            referencias_bulto.each(function () {
                let elemento = $(this);
                devolver_referencia_aside(elemento);
            });
        }

        $(this).parents('.bulto-inventario').remove();
        renumerar_bultos_inventario();

        if (numero_bultos_inventario == 2) {
            $('.borrar-bulto-inventario').hide();
        }


    }

    return false;
}

function obtener_numero_bultos_inventario() {
    let numero_bultos = 0;

    numero_bultos = $('.bulto-inventario').length;

    return numero_bultos;
}



function pinta_bulto_inventario() {
    let html = '';
    let numero_bulto = $('.bulto-inventario').length + 1;

    html += '<div class="bulto-inventario" data-numero-bulto="' + numero_bulto + '">';
    html += '<div class="cabecera-bulto">';
    html += '<p>Bulto <span class="numero-bulto">' + numero_bulto + '</span><span class="editar-bulto-inventario">Editar</span><span class="borrar-bulto-inventario" style="display: none;">x</span></p>';
    html += '</div>';
    html += '<div class="cuerpo-bulto">';
    html += '<div class="form-group">';
    html += '<select class="caja-bulto-inventario form-control">';
    html += '<option value="-1">Sin caja</option>';
    html += pinta_options_cajas_usuario();
    html += '</select>';
    html += '<div class="contenedor-medidas-peso-bulto">';
    html += '<div class="medidas-bulto">';
    html += '<p><img class="icono-medidas-peso" src="{$module_dir_url|escape:'htmlall':'UTF-8'}/views/img/drag_drop_warehouse/icono-medida.svg"><span class="span-ancho">0</span> x <span class="span-largo">0</span> x <span class="span-alto">0</span> cm</p>';
    html += '</div>';
    html += '<div class="peso-bulto">';
    html += '<p><img class="icono-medidas-peso" src="{$module_dir_url|escape:'htmlall':'UTF-8'}/views/img/drag_drop_warehouse/icono-peso.svg"><span class="span-peso">0</span> Kg</p>';
    html += '</div>';
    html += '</div>';
    html += '</div>';
    html += '</div>';
    html += '<div class="pie-bulto">';
    html += '<div class="aniadir-bulto-inventario">';
    html += '<p><span>+</span> Añadir referencias</p>';
    html += '</div>';
    html += '<div class="area-dropable">';
    html += '<p class="arrastra-aqui">Arrastra aquí tus artículos</p>';
    html += '</div>';
    html += '</div>';
    html += '</div>';

    html += '<div class="nuevo-bulto-dropable">';
    html += '<p>Arrastra aquí tus artículos para crear un nuevo bulto</p>';
    html += '<div class="linea-horizontal">';
    html += '<span>o</span>';
    html += '</div>';
    html += '<div class="aniadir-bulto-inventario-drop">';
    html += '<p><span>+</span> Nuevo bulto</p>';
    html += '</div>';
    html += '</div>';

    $('.bultos-cuerpo').append(html);

    $('.bulto-inventario').last().find('.area-dropable').droppable({
        accept: '.referencia-inventario-fila, .bulto-inventario-dragado, .grupo-inventario-fila',
        hoverClass: "area-dropable-hover",
        drop: function (event, ui) {
            let elemento = ui.draggable;

            if (elemento.hasClass('referencia-inventario-fila')) {
                let cantidad = elemento.find('.referencia-cantidad').val();
                let nombre = elemento.find('.columna-nombre p').text();
                let referencia = elemento.find('.columna-referencia p').text();
                let id_referencia = elemento.data('id-referencia');
                let peso = elemento.data('peso');
                let ancho = elemento.data('ancho');
                let largo = elemento.data('largo');
                let alto = elemento.data('alto');
                let cantidad_inicial = parseInt(elemento.find('.numero-restante').text());
                let caja_drop = $(this).parents('.bulto-inventario').find('.caja-bulto-inventario').val();
                let bulto_inventario = $(this).parents('.bulto-inventario');
                let elemento_drop = $(this);
                let referencias_drop = elemento_drop.find('.bulto-inventario-dragado');

                if ((cantidad > 1 && caja_drop == -1) || (caja_drop == -1 && referencias_drop.length == 1)) {
                    cargar_modal_aviso(elemento, elemento_drop, true, false);
                    return;
                } else {
                    elemento.find('.numero-restante').text(cantidad_inicial - 1);

                    elemento_drop.find('.arrastra-aqui').hide();

                    for (let i = 0; i < cantidad; i++) {
                        $(this).append(html_referencia_dragada(nombre, referencia, cantidad, id_referencia, peso, ancho, largo, alto));
                    }

                    $('.icono-cantidad').hide();
                    elemento_drop.css('display', 'block');

                    elemento.find('.referencia-cantidad').val(1);
                    recalcular_medidas_peso_bulto(bulto_inventario);
                }
            } else if (elemento.hasClass('bulto-inventario-dragado')) {
                let replica = elemento.clone();
                let bulto_drag = elemento.parents('.bulto-inventario');
                let caja_drop = $(this).parents('.bulto-inventario').find('.caja-bulto-inventario').val();
                let elemento_drop = $(this);
                let referencias_drop = elemento_drop.find('.bulto-inventario-dragado');
                let bulto_drop = elemento_drop.parents('.bulto-inventario');

                if (caja_drop == -1 && referencias_drop.length == 1) {
                    cargar_modal_aviso(elemento, elemento_drop, true, true);
                    return;
                } else {
                    $(this).append(replica);
                    $(this).find('.arrastra-aqui').hide();
                    $(this).css('display', 'block');
                    elemento.remove();
                    $('.helper').remove();
                }

                if (bulto_drag.find('.bulto-inventario-dragado').length < 1) {
                    $('.icono-cantidad').hide();
                    bulto_drag.find('.area-dropable').css('display', 'flex');
                    bulto_drag.find('.arrastra-aqui').show();
                }

                recalcular_medidas_peso_bulto(bulto_drag);
                recalcular_medidas_peso_bulto(bulto_drop);
            } else if (elemento.hasClass('grupo-inventario-fila')) {
                let caja = elemento.data('caja');
                let referencias = elemento.data('info-referencias').replace(/\'/g, '"');
                let referencias_json = $.parseJSON(referencias);
                let elemento_drop = $(this);

                if (caja == -1 && usar_grupo_sin_caja(referencias_json)) {
                    $('#modal_grupo_sin_caja').modal('show');
                } else {
                    elemento_drop.parents('.bulto-inventario').find('.caja-bulto-inventario').val(caja);
                    elemento_drop.find('.bulto-inventario-dragado').remove();

                    referencias_json.forEach(function (referencia) {
                        let id_referencia = referencia.id;
                        let nombre = referencia.nombre;
                        let cantidad = referencia.cantidad;
                        let referencia_cliente = referencia.referencia;
                        let peso = referencia.peso;
                        let ancho = referencia.ancho;
                        let largo = referencia.largo;
                        let alto = referencia.alto;
                        let cantidad_inicial = $('[data-id-referencia="' + id_referencia + '"]').find('.numero-restante').text();

                        $('[data-id-referencia="' + id_referencia + '"]').find('.numero-restante').text(cantidad_inicial - cantidad);

                        for (let i = 0; i < cantidad; i++) {
                            elemento_drop.append(html_referencia_dragada(nombre, referencia_cliente, cantidad, id_referencia, peso, ancho, largo, alto));
                        }
                    });

                    $('.icono-cantidad').hide();
                    elemento_drop.css('display', 'block');
                    elemento_drop.find('.arrastra-aqui').hide();
                    recalcular_medidas_peso_bulto(elemento_drop.parents('.bulto-inventario'));
                }
            }

            $(".area-dropable .bulto-inventario-dragado").draggable({
                revert: 'invalid',
                containment: "document",
                cursorAt: { left: 10},
                helper: function () {
                    let elemento = $(this);
                    let cantidad = elemento.find('.referencia-cantidad').val();
                    let nombre = elemento.find('.columna-nombre p').text();
                    let referencia = elemento.find('.columna-referencia p').text();
                    let peso = elemento.data('peso');
                    let ancho = elemento.data('ancho');
                    let largo = elemento.data('largo');
                    let alto = elemento.data('alto');
                    let html = html_referencia_dragada_helper(nombre, referencia, cantidad, peso, ancho, largo, alto);

                    return html;
                },
                scroll: true,
                start: function (event, ui) {
                    let elemento = $(this);

                    elemento.addClass('referencia-seleccionada');
                }
            });

            $('.referencia-seleccionada').removeClass('referencia-seleccionada');
        }
    });

    $('.nuevo-bulto-dropable').droppable({
        accept: '.referencia-inventario-fila, .bulto-inventario-dragado, .grupo-inventario-fila',
        hoverClass: "area-dropable-hover",
        drop: function (event, ui) {
            let elemento = ui.draggable;

            if (elemento.hasClass('referencia-inventario-fila')) {
                let cantidad = elemento.find('.referencia-cantidad').val();
                let nombre = elemento.find('.columna-nombre p').text();
                let referencia = elemento.find('.columna-referencia p').text();
                let id_referencia = elemento.data('id-referencia');
                let peso = elemento.data('peso');
                let ancho = elemento.data('ancho');
                let largo = elemento.data('largo');
                let alto = elemento.data('alto');
                let cantidad_inicial = parseInt(elemento.find('.numero-restante').text());
                let elemento_drop = $(this);

                if (cantidad > 1) {
                    cargar_modal_aviso(elemento, elemento_drop, false, false);
                    return;
                } else {
                    generar_nuevo_bulto_inventario();

                    for (let i = 0; i < cantidad; i++) {
                        $('.bulto-inventario').last().find('.area-dropable').append(html_referencia_dragada(nombre, referencia, cantidad, id_referencia, peso, ancho, largo, alto));
                        elemento.find('.numero-restante').text(cantidad_inicial - 1);
                    }

                    $('.bulto-inventario').last().find('.arrastra-aqui').hide();
                    $('.icono-cantidad').hide();
                    $('.bulto-inventario').last().find('.area-dropable').css('display', 'block');
                    recalcular_medidas_peso_bulto($('.bulto-inventario').last());

                    elemento.find('.referencia-cantidad').val(1);
                }
            } else if (elemento.hasClass('bulto-inventario-dragado')) {
                let replica = elemento.clone();
                let padre = elemento.parents('.bulto-inventario');

                generar_nuevo_bulto_inventario();
                $('.bulto-inventario').last().find('.area-dropable').append(replica);
                $('.bulto-inventario').last().find('.arrastra-aqui').hide();
                $('.icono-cantidad').hide();
                $('.bulto-inventario').last().find('.area-dropable').css('display', 'block');
                elemento.remove();
                $('.helper').remove();

                if (padre.find('.bulto-inventario-dragado').length < 2) {
                    padre.find('.area-dropable').css('display', 'flex');
                    padre.find('.arrastra-aqui').show();
                }

                recalcular_medidas_peso_bulto(padre);
                recalcular_medidas_peso_bulto($('.bulto-inventario').last());
            } else if (elemento.hasClass('grupo-inventario-fila')) {
                let caja = elemento.data('caja');
                let referencias = elemento.data('info-referencias').replace(/\'/g, '"');
                let referencias_json = $.parseJSON(referencias);
                let descontar = descontar_referencias_grupo(referencias_json);
                if (descontar) {
                    if (caja == -1) {
                        referencias_json.forEach(function (referencia) {
                            let id_referencia = referencia.id;
                            let nombre = referencia.nombre;
                            let cantidad = referencia.cantidad;
                            let referencia_cliente = referencia.referencia;
                            let peso = referencia.peso;
                            let ancho = referencia.ancho;
                            let largo = referencia.largo;
                            let alto = referencia.alto;

                            for (let i = 0; i < cantidad; i++) {
                                let cantidad_por_usar = $('#listado-referencias-inventario [data-id-referencia="' + referencia.id + '"]').find('.numero-restante').text();
                                generar_nuevo_bulto_inventario();
                                $('.bulto-inventario').last().find('.area-dropable').append(html_referencia_dragada(nombre, referencia_cliente, cantidad, id_referencia, peso, ancho, largo, alto));
                                $('.bulto-inventario').last().find('.area-dropable').css('display', 'block');
                                $('.bulto-inventario').last().find('.area-dropable').find('.arrastra-aqui').hide();
                                $('#listado-referencias-inventario [data-id-referencia="' + referencia.id + '"]').find('.numero-restante').text(cantidad_por_usar - 1);
                            }
                        });

                        $('.icono-cantidad').hide();
                    } else {
                        generar_nuevo_bulto_inventario();
                        let elemento_drop = $('.bulto-inventario').last().find('.area-dropable');

                        elemento_drop.parents('.bulto-inventario').find('.caja-bulto-inventario').val(caja);

                        referencias_json.forEach(function (referencia) {
                            let id_referencia = referencia.id;
                            let nombre = referencia.nombre;
                            let cantidad = referencia.cantidad;
                            let referencia_cliente = referencia.referencia;
                            let peso = referencia.peso;
                            let ancho = referencia.ancho;
                            let largo = referencia.largo;
                            let alto = referencia.alto;

                            for (let i = 0; i < cantidad; i++) {
                                let cantidad_por_usar = $('#listado-referencias-inventario [data-id-referencia="' + referencia.id + '"]').find('.numero-restante').text();
                                $('#listado-referencias-inventario [data-id-referencia="' + referencia.id + '"]').find('.numero-restante').text(cantidad_por_usar - 1);
                                elemento_drop.append(html_referencia_dragada(nombre, referencia_cliente, cantidad, id_referencia, peso, ancho, largo, alto));
                            }
                        });

                        $('.icono-cantidad').hide();
                        elemento_drop.css('display', 'block');
                        elemento_drop.find('.arrastra-aqui').hide();
                        recalcular_medidas_peso_bulto($('.bulto-inventario').last());
                    }
                } else {
                    $('#modal_cantidad_insuficiente').modal('show');
                }
            }

            $(".area-dropable .bulto-inventario-dragado").draggable({
                revert: 'invalid',
                containment: "document",
                cursorAt: { left: 10},
                helper: function () {
                    let elemento = $(this);
                    let cantidad = elemento.find('.referencia-cantidad').val();
                    let nombre = elemento.find('.columna-nombre p').text();
                    let referencia = elemento.find('.columna-referencia p').text();
                    let peso = elemento.data('peso');
                    let ancho = elemento.data('ancho');
                    let largo = elemento.data('largo');
                    let alto = elemento.data('alto');
                    let html = html_referencia_dragada_helper(nombre, referencia, cantidad, peso, ancho, largo, alto);

                    return html;
                },
                start: function (event, ui) {
                    let elemento = $(this);

                    elemento.addClass('referencia-seleccionada');
                },
                stop: function (event, ui) {
                    let elemento = $(this);

                    elemento.removeClass('referencia-seleccionada');
                }
            });

            $('.referencia-seleccionada').removeClass('referencia-seleccionada');
        }
    });
}

function recalcular_medidas_peso_bulto(bulto_inventario) {
    let caja = bulto_inventario.find('.caja-bulto-inventario option:selected');
    let referencias = bulto_inventario.find('.bulto-inventario-dragado');
    let peso = 0;
    let alto = 0;
    let ancho = 0;
    let largo = 0;

    if (caja.val() == -1) {
        alto = referencias.first().data('alto');
        ancho = referencias.first().data('ancho');
        largo = referencias.first().data('largo');
    } else if (caja.val() > 0) {
        alto = caja.data('caja-alto');
        ancho = caja.data('caja-ancho');
        largo = caja.data('caja-largo');
    }

    referencias.each(function () {
        peso += parseFloat($(this).data('peso'));
    });

    if (referencias.length > 0) {
        bulto_inventario.find('.contenedor-medidas-peso-bulto').css('display', 'flex');
        bulto_inventario.find('.span-peso').text(peso.toFixed(2));
        bulto_inventario.find('.span-alto').text(alto);
        bulto_inventario.find('.span-ancho').text(ancho);
        bulto_inventario.find('.span-largo').text(largo);
    } else {
        bulto_inventario.find('.contenedor-medidas-peso-bulto').hide();
    }
    establecer_bultos_almacen();
}

function usar_grupo_sin_caja(referencias) {
    if (referencias.length > 1) {
        return false;
    } else {
        referencias.forEach(function (referencia) {
            if (referencia.cantidad_grupo > 1) {
                return false;
            }
        });
    }

    return true;
}

function descontar_referencias_grupo(referencias) {
    let descontar = true;

    referencias.forEach(function (referencia) {
        let elemento_referencia = $('#listado-referencias-inventario [data-id-referencia="' + referencia.id + '"]');
        let cantidad_almacen = elemento_referencia.find('.numero-restante').text();
        let cantidad_grupo = referencia.cantidad;
        let cantidad_final = cantidad_almacen - cantidad_grupo;

        if (cantidad_final < 0) {
            descontar = false;
        }
    });

    return descontar;
}

function cargar_modal_aviso(elemento_drag, elemento_drop, solo_caja, clonar) {
    let cantidad = elemento_drag.find('.referencia-cantidad').val();
    let nombre = elemento_drag.find('.columna-nombre p').text();
    let referencia = elemento_drag.find('.columna-referencia p').text();
    let id_referencia = elemento_drag.data('id-referencia');
    let peso = elemento_drag.data('peso');
    let ancho = elemento_drag.data('ancho');
    let largo = elemento_drag.data('largo');
    let alto = elemento_drag.data('alto');
    let cantidad_inicial = parseInt(elemento_drag.find('.numero-restante').text());
    let bulto_drop = elemento_drop.parents('.bulto-inventario');
    let bulto_drag = elemento_drag.parents('.bulto-inventario');

    $('#cajas-modal').off();
    $('.boton-bulto-por-articulo').off();

    $('#cajas-modal').change(function () {
        let caja_elegida = $(this).val();

        $('#modal_multireferencia_sin_caja').modal('hide');

        if (elemento_drop.hasClass('area-dropable')) {
            if (elemento_drag.hasClass('bulto-inventario-dragado')) {
                elemento_drop.parents('.bulto-inventario').find('.caja-bulto-inventario').val(caja_elegida);
                $(this).val(-1);
                elemento_drop.append(elemento_drag);
                $('.helper').remove();

                if (bulto_drag.find('.bulto-inventario-dragado').length === 0) {
                    bulto_drag.find('.area-dropable').css('display', 'flex');
                    bulto_drag.find('.arrastra-aqui').show();
                }

                recalcular_medidas_peso_bulto(bulto_drop);
                recalcular_medidas_peso_bulto(bulto_drag);
            } else {
                if (cantidad_inicial >= 0) {
                    elemento_drop.parents('.bulto-inventario').find('.caja-bulto-inventario').val(caja_elegida);
                    $(this).val(-1);

                    if (clonar) {
                        elemento_drop.append(elemento_drag);

                    } else {
                        elemento_drag.find('.numero-restante').text(cantidad_inicial);
                        elemento_drop.find('.arrastra-aqui').hide();

                        for (let i = 0; i < cantidad; i++) {
                            elemento_drop.append(html_referencia_dragada(nombre, referencia, cantidad, id_referencia, peso, ancho, largo, alto));
                        }

                        $('.icono-cantidad').hide();
                        elemento_drop.css('display', 'block');

                        elemento_drag.find('.referencia-cantidad').val(1);
                        recalcular_medidas_peso_bulto(bulto_drop);
                    }
                } else {
                    $('#modal_cantidad_insuficiente').modal('show');
                }
            }
        } else if (elemento_drop.hasClass('nuevo-bulto-dropable')) {
            if (cantidad_inicial >= 0) {
                generar_nuevo_bulto_inventario();
                $('.bulto-inventario').last().find('.caja-bulto-inventario').val(caja_elegida);
                $(this).val(-1);

                elemento_drag.find('.numero-restante').text(cantidad_inicial);
                $('.bulto-inventario').last().find('.arrastra-aqui').hide();

                for (let i = 0; i < cantidad; i++) {
                    $('.bulto-inventario').last().find('.area-dropable').append(html_referencia_dragada(nombre, referencia, cantidad, id_referencia, peso, ancho, largo, alto));
                    recalcular_medidas_peso_bulto($('.bulto-inventario').last());
                }

                $('.icono-cantidad').hide();
                $('.bulto-inventario').last().find('.area-dropable').css('display', 'block');

                elemento_drag.find('.referencia-cantidad').val(1);
            } else {
                $('#modal_cantidad_insuficiente').modal('show');
            }
        }

        $(".area-dropable .bulto-inventario-dragado").draggable({
            revert: 'invalid',
            containment: "document",
            cursorAt: { left: 10},
            helper: function () {
                let elemento = $(this);
                let cantidad = elemento.find('.referencia-cantidad').val();
                let nombre = elemento.find('.columna-nombre p').text();
                let referencia = elemento.find('.columna-referencia p').text();
                let peso = elemento.data('peso');
                let ancho = elemento.data('ancho');
                let largo = elemento.data('largo');
                let alto = elemento.data('alto');
                let html = html_referencia_dragada_helper(nombre, referencia, cantidad, peso, ancho, largo, alto);

                return html;
            },
            scroll: true,
            start: function (event, ui) {
                let elemento = $(this);

                elemento.addClass('referencia-seleccionada');
            },
            stop: function (event, ui) {
                let elemento = $(this);

                elemento.removeClass('referencia-seleccionada');
            }
        });
    });

    $('.boton-bulto-por-articulo').click(function () {
        $('#modal_multireferencia_sin_caja').modal('hide');

        elemento_drag.find('.numero-restante').text(cantidad_inicial);
        elemento_drag.find('.referencia-cantidad').val(1);

        for (let i = 0; i < cantidad; i++) {
            generar_nuevo_bulto_inventario();

            let bulto = $('.bulto-inventario').last();
            bulto.find('.area-dropable').append(html_referencia_dragada(nombre, referencia, cantidad, id_referencia, peso, ancho, largo, alto));
            bulto.find('.area-dropable').css('display', 'block');
            bulto.find('.arrastra-aqui').hide();
            $('.icono-cantidad').hide();
            recalcular_medidas_peso_bulto(bulto);
        }

        $(".area-dropable .bulto-inventario-dragado").draggable({
            revert: 'invalid',
            containment: "document",
            cursorAt: { left: 10},
            helper: function () {
                let elemento = $(this);
                let cantidad = elemento.find('.referencia-cantidad').val();
                let nombre = elemento.find('.columna-nombre p').text();
                let referencia = elemento.find('.columna-referencia p').text();
                let peso = elemento.data('peso');
                let ancho = elemento.data('ancho');
                let largo = elemento.data('largo');
                let alto = elemento.data('alto');
                let html = html_referencia_dragada_helper(nombre, referencia, cantidad, peso, ancho, largo, alto);

                return html;
            },
            scroll: true,
            start: function (event, ui) {
                let elemento = $(this);

                elemento.addClass('referencia-seleccionada');
            },
            stop: function (event, ui) {
                let elemento = $(this);

                elemento.removeClass('referencia-seleccionada');
            }
        });
    });

    if (solo_caja) {
        $('.centrar').hide();
        $('.boton-bulto-por-articulo').hide();
    } else {
        $('.centrar').show();
        $('.boton-bulto-por-articulo').show();
    }

    $('#modal_multireferencia_sin_caja').modal('show');
}

function generar_nuevo_bulto_inventario() {
    $('.nuevo-bulto-dropable').remove();
    pinta_bulto_inventario();
    $('.nuevo-bulto-dropable').css('display', 'flex');

    $('.bulto-inventario').last().find('.aniadir-bulto-inventario').hide();
    $('.bulto-inventario').last().find('.area-dropable').css('display', 'flex');
    $('.bulto-inventario').last().find('.editar-bulto-inventario').show();
    $('.bulto-inventario').find('.borrar-bulto-inventario').show();
}

function renumerar_bultos_inventario() {
    let bultos_inventario = $('.bulto-inventario');
    let numero = 1;

    bultos_inventario.each(function () {
        $(this).attr('data-numero-bulto', numero);
        $(this).find('.numero-bulto').text(numero);
        numero++;
    });

    return false;
}

function desplegar_aside(evento) {
    switch (evento.data.tipo) {
        case 'bulto-inventario':
            $('#aside-buscador').removeClass('direcciones origen destino bultos-predefinidos');
            $('#aside-buscador-cabecera h2').html('Logística');
            $('.editar-bulto-inventario').show();

            if ($('.bultos-inventario').length < 1) {
                if ($('#aside-buscador').is(':visible')) {
                    $('#aside-buscador').toggle('slide');
                }

                $('.cuerpo #contenedor').html('');
                $('#aside-buscador-cuerpo .cabecera').html('<p id="muestra-referencias" class="seleccionado">Referencias</p><p id="muestra-grupos">Grupos</p>');
                $('#aside-buscador-cuerpo .filtro_referencias').html('<input type="text" id="filtro_referencias" class="form-control ui-autocomplete-input" placeholder="Escribe el nombre o la referencia que quieras buscar">');
                $('#aside-buscador').addClass('bultos-inventario');
                cargar_referencias_usuario();
                cargar_grupos_usuario();
                mostrar_referencias();
            }

            if ($('#aside-buscador').not(':visible')) {
                $('.aniadir-bulto-inventario').hide();
                $('#filtro_referencias').val('');
                $('.area-dropable').css('display', 'flex');
                $('.nuevo-bulto-dropable').css('display', 'flex');
            }

            $('#aside-buscador').toggle('slide');

            break;
    }
}

function cargar_referencias_usuario(id_seleccionada = '', filtro_referencias = '', resultados = '') {
    let referencias_inventario;
    let id = id_seleccionada;
    let id_usuario = '{$id_usuario|escape:'htmlall':'UTF-8'}';
   

    $.ajax({
        url: "{$geneiajaxcontrollerlink|escape:'htmlall':'UTF-8'}&action=getUserRefs",
        type: 'post',
        cache: false,
        data: {
        'tipo': 1,
        'cantidades': 'si',
        'id': id_seleccionada
              },
        success: function (respuesta) {
            if (filtro_referencias == 1) {
                referencias_inventario = resultados;
            } else {
                referencias_inventario = $.parseJSON(respuesta);
            }
            $('.cuerpo #contenedor').append('<div id="listado-referencias-inventario"></div>');
            referencias_inventario.forEach(function (referencia_inventario) {
                if (referencia_inventario.cantidad_disponible > 0) {
                    let html_referencia_inventario = generar_html_referencia_inventario(referencia_inventario);
                    $('.cuerpo #listado-referencias-inventario').append(html_referencia_inventario);
                }
            });

            $(".referencia-inventario-fila").draggable({
                revert: 'invalid',
                containment: "document",
                cursorAt: { left: 10},
                helper: function () {
                    let elemento = $(this);
                    let cantidad = elemento.find('.referencia-cantidad').val();
                    let nombre = elemento.find('.columna-nombre p').text();
                    let referencia = elemento.find('.columna-referencia p').text();
                    let peso = elemento.data('peso');
                    let ancho = elemento.data('ancho');
                    let largo = elemento.data('largo');
                    let alto = elemento.data('alto');
                    let html = html_referencia_dragada(nombre, referencia, cantidad, peso, ancho, largo, alto);

                    return html;
                },
                start: function (event, ui) {
                    let elemento = $(this);
                    let seleccionados = parseInt(elemento.find('.referencia-cantidad').val());
                    let cantidad_inicial = parseInt(elemento.find('.numero-restante').text());
                    let total = cantidad_inicial - seleccionados;

                    if (total < 0) {
                        $('#modal_cantidad_insuficiente').modal('show');
                        $('.area-dropable').droppable("disable");
                        $('.nuevo-bulto-dropable').droppable("disable");
                    } else {
                        $('.area-dropable').droppable("enable");
                        $('.nuevo-bulto-dropable').droppable("enable");
                    }

                    elemento.find('.numero-restante').text(total);
                    elemento.addClass('referencia-seleccionada');
                    $('#buscador').css('z-index', '1');
                },
                stop: function (event, ui) {
                    let elemento = $(this);
                    let cantidad_inicial = parseInt(elemento.find('.numero-restante').text());
                    let seleccionados = parseInt(elemento.find('.referencia-cantidad').val());
                    let total = cantidad_inicial + seleccionados;

                    elemento.find('.numero-restante').text(total);
                    elemento.removeClass('referencia-seleccionada');
                    $('#buscador').css('z-index', '2');
                }
            });

            $('#aside-buscador-cuerpo .cuerpo').droppable({
                accept: '.area-dropable .bulto-inventario-dragado',
                drop: function (event, ui) {
                    let elemento = ui.draggable;
                    let bulto_drag = elemento.parents('.bulto-inventario');
                    devolver_referencia_aside(elemento);
                    recalcular_medidas_peso_bulto(bulto_drag);

                    $('.referencia-seleccionada').removeClass('referencia-seleccionada');
                }
            });

        }
    });
}

function cargar_grupos_usuario() {
    let referencias_inventario;
    let grupos_inventario;
    let id_usuario = '{$id_usuario|escape:'htmlall':'UTF-8'}';

    $.ajax({
        url: "{$geneiajaxcontrollerlink|escape:'htmlall':'UTF-8'}&action=getUserRefs",
        type: 'post',
        cache: false,
        data: {
            'id_usuario': id_usuario,
             'grupos': 'si',            
              },
        success: function (respuesta) {
            grupos_inventario = $.parseJSON(respuesta);

            $('.cuerpo #contenedor').append('<div id="listado-grupos-inventario" style></div>');

            grupos_inventario.forEach(function (grupo_inventario) {
                let html_grupo_inventario = generar_html_grupo_inventario(grupo_inventario);
                $('.cuerpo #listado-grupos-inventario').append(html_grupo_inventario);
            });

            $(".grupo-inventario-fila").draggable({
                revert: 'invalid',
                containment: "document",
                cursorAt: { left: 10},
                helper: function () {
                    let elemento = $(this);
                    let nombre = elemento.data('nombre');
                    let numero_elementos = elemento.data('numero-elementos');
                    let id_grupo = elemento.data('id-grupo');
                    let html = html_grupo_dragado(nombre, numero_elementos, id_grupo);

                    return html;
                },
                start: function (event, ui) {
                    let elemento = $(this);
                    let referencias = elemento.data('info-referencias').replace(/\'/g, '"');
                    let referencias_json = $.parseJSON(referencias);
                    let descontar = descontar_referencias_grupo(referencias_json);

                    if (!descontar) {
                        $('#modal_cantidad_insuficiente').modal('show');
                        $('.area-dropable').droppable('disable');
                        $('.nuevo-bulto-dropable').droppable('disable');
                    } else {
                        $('.area-dropable').droppable('enable');
                        $('.nuevo-bulto-dropable').droppable('enable');
                    }

                    elemento.addClass('referencia-seleccionada');
                    $('#buscador').css('z-index', '1');
                },
                stop: function (event, ui) {
                    let elemento = $(this);

                    elemento.removeClass('referencia-seleccionada');
                    $('#buscador').css('z-index', '2');
                }
            });
        }
    });
}

function devolver_referencia_aside(elemento) {
    let id_referencia = elemento.data('id-referencia');
    let restantes = parseInt($('[data-id-referencia="' + id_referencia + '"]').find('.numero-restante').text());
    let padre = elemento.parents('.bulto-inventario');

    $('[data-id-referencia="' + id_referencia + '"]').find('.numero-restante').text(restantes + 1);
    elemento.remove();
    $('.helper').remove();

    if (padre.find('.area-dropable .bulto-inventario-dragado').length < 1) {
        padre.find('.arrastra-aqui').show();
        padre.find('.area-dropable').css('display', 'flex');
    }
}

function cerrar_aside() {
    $('#aside-buscador').toggle('slide');
    $('#listado-referencias-inventario').html('');
    cargar_referencias_usuario();
}

function generar_html_bulto_predefinido(bulto_predefinido) {
    let html = '';

    html += '<div class="bulto-predefinido-tarjeta" data-peso="' + bulto_predefinido.peso + '" data-alto="' + bulto_predefinido.alto + '" data-ancho="' + bulto_predefinido.ancho + '" data-largo="' + bulto_predefinido.largo + '" data-numero-bulto="0">';
    html += '<div class="cabecera-bulto-predefinido-tarjeta">';
    html += '<p>' + bulto_predefinido.nombre + '<span class="icono-desplegar">></span></p>';
    html += '<p>' + '' + '</p>';
    html += '</div>';
    html += '<div class="cuerpo-bulto-predefinido-tarjeta">';
    html += '<hr>';
    html += '<div class="columna-completa">';
    html += '<p>' + bulto_predefinido.peso + 'kg ' + bulto_predefinido.alto + ' x ' + bulto_predefinido.ancho + ' x ' + bulto_predefinido.largo + '</p>';
    html += '</div>';
    html += '</div>';
    html += '</div>';

    return html;
}

function generar_html_referencia_inventario(referencia_inventario) {
    let html = '';

    html += '<div class="referencia-inventario-fila" data-id-referencia="' + referencia_inventario.id + '" data-peso="' + referencia_inventario.peso + '" data-alto="' + referencia_inventario.alto + '" data-ancho="' + referencia_inventario.ancho + '" data-largo="' + referencia_inventario.largo + '" data-numero-bulto="0" data-cantidad="' + referencia_inventario.cantidad + '">';
    html += '<div class="columna-nombre">';
    html += '<p><img src="{$module_dir_url|escape:'htmlall':'UTF-8'}/views/img/drag_drop_warehouse/icono-dragable.svg">' + referencia_inventario.nombre + '</p>';
    html += '</div>';
    html += '<div class="columna-referencia">';
    html += '<p>' + referencia_inventario.referencia_cliente + '</p>';
    html += '</div>';
    html += '<div class="columna-en-almacen">';
    html += '<p><span class="numero-restante">' + referencia_inventario.cantidad_disponible + '</span> restantes</p>';
    html += '</div>';
    html += '<div class="columna-cantidad">';
    html += '<p>';
    html += '<span class="control-cantidad resta">-</span>';
    html += '<input type="number" class="referencia-cantidad" min="1" max="99" value="1">';
    html += '<span class="control-cantidad suma">+</span>';
    html += '</p>';
    html += '</div>';
    html += '</div>';

    return html;
}

function generar_html_grupo_inventario(grupo_inventario) {
    let html = '';
    let html_referencias = '';
    let json_referencias_grupo = new Array();
    let id_caja = -1;

    if (typeof grupo_inventario.caja !== 'undefined') {
        id_caja = grupo_inventario.caja.id;
    }

    grupo_inventario.referencias.forEach(function (referencia) {
        let objeto = {
            'id': referencia.id,
            'cantidad': referencia.cantidad_grupo,
            'nombre': referencia.nombre,
            'referencia': referencia.referencia_cliente,
            'peso': referencia.peso,
            'alto': referencia.alto,
            'largo': referencia.largo,
            'ancho': referencia.ancho
        };

        json_referencias_grupo.push(objeto);

        html_referencias += '<p>' + referencia.cantidad_grupo + ' x ' + referencia.nombre + ' | Ref: ' + referencia.referencia_cliente + '</p>';
    });

    html += '<div class="grupo-inventario-fila" data-nombre="' + grupo_inventario.nombre + '" data-numero-elementos="' + grupo_inventario.referencias.length + '" data-id-grupo="' + grupo_inventario.id + '" data-info-referencias="' + JSON.stringify(json_referencias_grupo).replace(/"/g, "'") + '" data-caja="' + id_caja + '">';
    html += '<div class="cabecera-grupo-tarjeta">';
    html += '<div class="columna-nombre">';
    html += '<p><img src="{$module_dir_url|escape:'htmlall':'UTF-8'}/views/img/drag_drop_warehouse/icono-dragable.svg">' + grupo_inventario.nombre + '</p>';
    html += '</div>';
    html += '<div class="columna-elementos">';
    html += '<p>' + grupo_inventario.referencias.length + ' referencias <span class="icono-desplegar">></span></p>';
    html += '</div>';
    html += '</div>';
    html += '<div class="cuerpo-grupo-tarjeta">';
    html += '<hr>';
    html += html_referencias;
    html += '</div>';
    html += '</div>';

    return html;
}

function mostrar_info_grupo_referencias() {
    let icono = $(this);
    let elemento = $(this).parents('.cabecera-grupo-tarjeta').next();

    if (elemento.is(':visible')) {
        elemento.slideUp();
        icono.css({ transform: 'rotate(90deg)'});
    } else {
        elemento.slideDown();
        icono.css({ transform: 'rotate(270deg)'});
    }
}

function construir_datos_bultos_inventario() {
    let bultos_inventario = $('.bulto-inventario');
    let datos_bultos_inventario = new Array();

    bultos_inventario.each(function () {
        let referencias = $(this).find('.bulto-inventario-dragado');
        let datos_referencias = { };

        referencias.each(function () {
            let id_referencia = $(this).data('id-referencia');

            if (id_referencia in datos_referencias) {
                datos_referencias[id_referencia]++;
            } else {
                datos_referencias[id_referencia] = 1;
            }
        });

        let bulto_inventario = {
            id_caja: $(this).find('.caja-bulto-inventario').val(),
            referencias: datos_referencias
        };

        datos_bultos_inventario.push(bulto_inventario);
    });

    return datos_bultos_inventario;
}

function restar() {
    let elemento = $(this).parent().find('.referencia-cantidad');
    let valor = elemento.val();

    if (valor > 1) {
        valor--;
    }

    elemento.val(valor);
}

function sumar() {
    let elemento = $(this).parent().find('.referencia-cantidad');
    let valor = elemento.val();

    if (valor < 999) {
        valor++;
    }

    elemento.val(valor);
}

function html_referencia_dragada(nombre, referencia, cantidad, id_referencia, peso, ancho, largo, alto) {
    let html = '';

    html += '<div class="bulto-inventario-dragado" data-id-referencia="' + id_referencia + '" data-peso="' + peso + '" data-ancho="' + ancho + '" data-largo="' + largo + '" data-alto="' + alto + '">';
    html += '<div class="columna-nombre">';
    html += '<p><img src="{$module_dir_url|escape:'htmlall':'UTF-8'}/views/img/drag_drop_warehouse/icono-dragable.svg">' + nombre + '</p>';
    html += '</div>';
    html += '<div class="columna-referencia">';
    html += '<p>' + referencia + '</p>';
    html += '</div>';
    if (cantidad > 1) {
        html += '<span class="icono-cantidad">' + cantidad + '</span>';
    }
    html += '</div>';

    return html;
}

function html_referencia_dragada_helper(nombre, referencia, cantidad, id_referencia, peso, ancho, largo, alto) {
    let html = '';

    html += '<div class="bulto-inventario-dragado helper" data-id-referencia="' + id_referencia + '" data-peso="' + peso + '" data-ancho="' + ancho + '" data-largo="' + largo + '" data-alto="' + alto + '">';
    html += '<div class="columna-nombre">';
    html += '<p><img src="{$module_dir_url|escape:'htmlall':'UTF-8'}/views/img/drag_drop_warehouse/icono-dragable.svg">' + nombre + '</p>';
    html += '</div>';
    html += '<div class="columna-referencia">';
    html += '<p>' + referencia + '</p>';
    html += '</div>';
    if (cantidad > 1) {
        html += '<span class="icono-cantidad">' + cantidad + '</span>';
    }
    html += '</div>';

    return html;
}

function html_grupo_dragado(nombre, numero_elementos, id_grupo) {
    let html = '';

    html += '<div class="bulto-inventario-dragado" data-id-grupo="' + id_grupo + '">';
    html += '<div class="columna-nombre">';
    html += '<p><img src="{$module_dir_url|escape:'htmlall':'UTF-8'}/views/img/drag_drop_warehouse/icono-dragable.svg">' + nombre + '</p>';
    html += '</div>';
    html += '<div class="columna-elementos">';
    html += '<p>' + numero_elementos + ' referencias</p>';
    html += '</div>';
    html += '</div>';

    return html;
}

function pinta_options_cajas_usuario() {
    let html = '';
    let cajas_json = $('#cajas_usuario').text();    
    let cajas = $.parseJSON(cajas_json);
    
    cajas.forEach(function (caja) {
        html += '<option value="' + caja.id + '" data-caja-largo="' + caja.largo + '" data-caja-ancho="' + caja.ancho + '" data-caja-alto="' + caja.alto + '">' + caja.nombre + '</option>';
    });
    return html;

}

function quitar_caja_bulto_inventario() {
    let caja_seleccionada = $(this).val();
    let bulto_inventario = $(this).parents('.bulto-inventario');
    let referencias_bulto_inventario = bulto_inventario.find('.bulto-inventario-dragado');
    let valor_previo = $(this).data('valor-previo');

    if (referencias_bulto_inventario.length > 1 && caja_seleccionada == -1) {
        $(this).val(valor_previo);
        $('#modal_quitar_caja').modal('show');

        $('.boton-quitar-caja').off();

        $('.boton-quitar-caja').click(function () {
            $('#modal_quitar_caja').modal('hide');

            referencias_bulto_inventario.each(function () {
                generar_nuevo_bulto_inventario();
                $('.bulto-inventario').last().find('.area-dropable').append($(this));
                $('.bulto-inventario').last().find('.area-dropable').css('display', 'block');
                $('.bulto-inventario').last().find('.arrastra-aqui').hide();
                recalcular_medidas_peso_bulto($('.bulto-inventario').last());
                $('.icono-cantidad').hide();
            });

            bulto_inventario.remove();
            $('.helper').remove();
            renumerar_bultos_inventario();

            $(".area-dropable .bulto-inventario-dragado").draggable({
                revert: 'invalid',
                containment: "document",
                cursorAt: { left: 10},
                helper: function () {
                    let elemento = $(this);
                    let cantidad = elemento.find('.referencia-cantidad').val();
                    let nombre = elemento.find('.columna-nombre p').text();
                    let referencia = elemento.find('.columna-referencia p').text();
                    let peso = elemento.data('peso');
                    let ancho = elemento.data('ancho');
                    let largo = elemento.data('largo');
                    let alto = elemento.data('alto');
                    let html = html_referencia_dragada_helper(nombre, referencia, cantidad, peso, ancho, largo, alto);

                    return html;
                },
                scroll: true,
                start: function (event, ui) {
                    let elemento = $(this);

                    elemento.addClass('referencia-seleccionada');
                },
                stop: function (event, ui) {
                    let elemento = $(this);

                    elemento.removeClass('referencia-seleccionada');
                }
            });
        });
    }

    recalcular_medidas_peso_bulto(bulto_inventario);
}

function almacenar_valor_previo() {
    let valor_previo = $(this).val();
    $(this).data('valor-previo', valor_previo);

    return false;
}

function mostrar_referencias() {
    $('#listado-referencias-inventario').show();
    $('#listado-grupos-inventario').hide();
    $('.filtro_referencias').css('visibility', 'visible');
    $('#aside-buscador-cuerpo .cabecera p').removeClass('seleccionado');
    $('#aside-buscador-cuerpo #muestra-referencias').addClass('seleccionado');
}

function mostrar_grupos() {
    $('#listado-referencias-inventario').hide();
    $('#listado-grupos-inventario').show();
    $('.filtro_referencias').css('visibility', 'hidden');
    $('#aside-buscador-cuerpo .cabecera p').removeClass('seleccionado');
    $('#aside-buscador-cuerpo #muestra-grupos').addClass('seleccionado');
}

function generar_bultos_referencias_cantidades_prestashop () {
    let json_referencias_cantidades = construir_datos_bultos_inventario();
    let array_bultos = obtener_peso_medidas_bultos ();
}

function obtener_peso_medidas_bultos () {
    let bultos = $('.bulto-inventario');
    let array_bultos = new Array();
    
    bultos.each(function () {
        let bulto = $(this);
        let numero_bulto = bulto.data('numero-bulto');
        let alto = bulto.find('.span-alto').text();
        let ancho = bulto.find('.span-ancho').text();
        let largo = bulto.find('.span-largo').text();
        let peso = bulto.find('.span-peso').text();
        
        array_bultos[numero_bulto] = {
            'bulto': numero_bulto,
            'peso': peso,
            'alto': alto,
            'largo': largo,
            'ancho': ancho
        };
    });
    
    return array_bultos;
}

function obtener_cajas_usuario () {
    let id_usuario = '{$id_usuario|escape:'htmlall':'UTF-8'}';
    $.ajax({
        url: "{$geneiajaxcontrollerlink|escape:'htmlall':'UTF-8'}&action=getUserRefs",        
        type: 'post',
        data: {
            'id_usuario': id_usuario,
            'tipo': 2             
              },
        cache: false,
        success: function (respuesta) {    
            
            $('#cajas_usuario').text(respuesta);
            
            pinta_bulto_inventario();
            let html = rellena_bulto_inicial_select_cajas ();
            $('.caja-bulto-inventario').first().html(html);
            $('#cajas-modal').html(html);
        }
    });
}

function rellena_bulto_inicial_select_cajas () {
    let cajas_string_json = $('#cajas_usuario').text();
    let cajas = $.parseJSON(cajas_string_json);
    let html = '';
    
    cajas.forEach(function (caja) {
        html += '<option value="-1">Selecciona una caja</option>';
        html += '<option value="' + caja.id + '">' + caja.nombre + '</option>';
    });
    
    return html;
}




 </script>
 {/if}
 
 