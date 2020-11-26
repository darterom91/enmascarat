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

<div class="col-md-3">
                <label for="atributos_defecto_genei_default" class="text-left">{l s='Items default attributes: ' mod='genei'}</label>
               <select class="form-control" name="atributos_defecto_genei_default" id="atributos_defecto_genei_default">
                    {html_options options=$atributos_defecto_genei selected=$atributos_defecto_genei_default}
               </select>
         </div>
<div class="col-md-5">                        
            <div class="col-md-12" id="">
                <div class="col-md-2" id="atributos_defecto_genei">
                <label for="peso_defecto_genei" class="text-left">{l s='Weight kg: ' mod='genei'}</label>    
                <input type="number" min="1" max="300" class="form-control" name="peso_defecto_genei" id="peso_defecto_genei" value="{$peso_defecto_genei|escape:'htmlall':'UTF-8'}"/>
                </div>   
                <div class="col-md-2">
                <label for="largo_defecto_genei" class="text-left">{l s='Long cm: ' mod='genei'}</label>    
                <input type="number" min="1" max="500" class="form-control" name="largo_defecto_genei" id="largo_defecto_genei" value="{$largo_defecto_genei|escape:'htmlall':'UTF-8'}"/>
                </div>
                <div class="col-md-2">
                <label for="ancho_defecto_genei" class="text-left">{l s='Width cm: ' mod='genei'}</label>    
                <input type="number" min="1" max="500" class="form-control" name="ancho_defecto_genei" id="ancho_defecto_genei" value="{$ancho_defecto_genei|escape:'htmlall':'UTF-8'}"/>
                </div>
                <div class="col-md-2">
                <label for="alto_defecto_genei" class="text-left">{l s='Height cm: ' mod='genei'}</label>    
                <input type="number" min="1" max="500" class="form-control" name="alto_defecto_genei" id="alto_defecto_genei" value="{$alto_defecto_genei|escape:'htmlall':'UTF-8'}"/>
                </div>
                <div class="col-md-2">
                <label for="num_bultos_defecto_genei" class="text-left">{l s='Items:' mod='genei'}</label>    
                <input type="number" min="1" max="10" class="form-control" name="num_bultos_defecto_genei" id="num_bultos_defecto_genei" value="{$num_bultos_defecto_genei|escape:'htmlall':'UTF-8'}"/>
                </div>                
            </div>        
    </div>