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
            <strong>{l s='Google maps API Key:' mod='genei'}</strong>
        </div>
        <div class="col-md-8">            
        </div>            
    </div>
    <div class="col-md-12" style="margin-top:20px">        
        <div class="col-md-4">  
            <input type="text" class="form-control" name="google_api_key" id="google_api_key" value="{$google_api_key|escape:'htmlall':'UTF-8'}" placeholder="{l s='Write here your Google maps API Key' mod='genei'}"/>
        </div>
        <div class="col-md-8">
            {l s='Maps will be shown to your customers in order to choose a delivery point for the carriers that propose this service. You need to indicate a correct Google maps API key to display them correctly. To know how to get a Google maps API key for your shop, please click on the following link: ' mod='genei'}<a href="https://developers.google.com/maps/documentation/geocoding/get-api-key" target="_blank"><p style="font-weight:bold">{l s='How to get a Google maps API Key' mod='genei'}</p></a>     
        </div>
    </div>    
    </div>
        
        
        