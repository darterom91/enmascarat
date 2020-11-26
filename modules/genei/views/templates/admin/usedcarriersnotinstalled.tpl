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
    <label for="transportistas_no_utilizados_genei" class="text-left">{l mod='genei' s='Not installed Genei carriers:'}</label>
        <select class="form-control" name="transportistas_no_utilizados_genei" id="transportistas_no_utilizados_genei">
            {html_options options=$agencias_genei_no_utilizadas}
        </select>
    </div> 
<div class="col-md-2" style="margin-top:25px">                  
    <button type="button" class="btn btn-md btn-success" title="{l mod='genei' s='Install selected carrier'}" id="boton_aniadir_transportista_genei" onclick="instalar_transportista()">{l mod='genei' s='Install selected carrier'}</button>                
<div id="div_carrier_uninstalled_genei" class="alert alert-success" style="display:none">
			<button type="button" class="close" data-dismiss="alert">×</button>
                       {l mod='genei' s ='Carrier installed.'} {l mod='genei' s ='Please wait...'}
	</div>    
</div>                  
