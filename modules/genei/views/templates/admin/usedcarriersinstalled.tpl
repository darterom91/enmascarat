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

<div class="col-md-4">
           
            <label for="transportistas_utilizados_genei" class="text-left">{l mod='genei' s='Installed Genei carriers:'}</label>
           <select class="form-control" name="transportistas_utilizados_genei" id="transportistas_utilizados_genei">
                  {html_options options=$agencias_genei_utilizadas}
            </select>                                    
        </div> 
 <div class="col-md-2" style="margin-top:25px">                  
                <button type="button" class="btn btn-md btn-success" title="{l mod='genei' s='Uninstall selected carrier'}" id="boton_eliminar_transportista_genei" onclick="desinstalar_transportista()">{l mod='genei' s='Uninstall selected carrier'}</button>                
<div id="div_carrier_installed_genei" class="alert alert-success" style="display:none">
			<button type="button" class="close" data-dismiss="alert">×</button>
                       {l mod='genei' s ='Carrier uninstalled.'} {l mod='genei' s ='Please wait...'}
	</div> 
 </div>  
       