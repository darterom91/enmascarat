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

<div class="bootstrap">
            <div class="modal fade" id="modal_registrar" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header regHeader">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                            <h2 class="modal-title text-center" id="myModalLabel" style="color:#FFF;">{l mod='genei' s ='Register on Genei.es'}</h2>
                        </div>
                        <div class="modal-body" style="height:390px">
                            <form class="formuRegistro" id="frm_acceso" method="POST" accept-charset="utf-8">
                                <div class="col-xs-12 col-md-12">
                                    <div id="tipo_cliente">                                            
                                        <input id="tipo_registro_particular" name="tipo_registro" checked="" type="radio" class="bold text-center" value="particular">
                                        <label for="tipo_registro_particular">{l mod='genei' s ='Individual'}</label>                                            
                                        <input id="tipo_registro_autonomo" name="tipo_registro" checked="" type="radio" class="bold text-center" value="autonomo">
                                        <label for="tipo_registro_autonomo">{l mod='genei' s ='Independent'}</label>                                            
                                        <input id="tipo_registro_empresa" name="tipo_registro" checked="" type="radio" class="bold text-center" value="empresa">
                                        <label for="tipo_registro_empresa">{l mod='genei' s ='Professional'}</label>
                                    </div>
                                    <div class="col-xs-12 col-md-6 formu" style="margin-top: 5px">
                                        <div>
                                            <label for="email_registro" class="text-left">{l mod='genei' s ='Email'}</label>
                                            <input id="email_registro" name="email_registro" class="form-control" type="text" placeholder="{l mod='genei' s ='Email'}" value="{$PS_SHOP_EMAIL|escape:'htmlall':'UTF-8'}">
                                        </div>
                                        <div>
                                            <label for="nombre_registro" class="text-left">{l mod='genei' s ='Name / Enterprise name'}</label>
                                            <input id="nombre_registro" name="nombre_registro" class="form-control" type="text" placeholder="{l mod='genei' s ='Name / Enterprise name'}" value="{$PS_SHOP_NAME|escape:'htmlall':'UTF-8'}">
                                        </div>
                                        <div id="div_nif_cif_registro">
                                            <label for="nif_cif_registro" class="text-left">{l mod='genei' s ='NIF/CIF/NIE'}</label>
                                            <input id="nif_cif_registro" name="nif_cif_registro" class="form-control" type="text" placeholder="{l mod='genei' s ='NIF/CIF/NIE'}" VALUE="{$PS_SHOP_DETAILS|escape:'htmlall':'UTF-8'}">
                                        </div>        
                                        <div>
                                            <label for="direccion_registro" class="text-left">{l mod='genei' s ='Address'}</label>
                                            <input id="direccion_registro" name="direccion_registro" class="form-control" type="text" placeholder="{l mod='genei' s ='Address'}" value="{$PS_SHOP_ADDR1|escape:'htmlall':'UTF-8'}.{$PS_SHOP_ADDR2|escape:'htmlall':'UTF-8'}">
                                        </div>                                        
                                        <div>                                            
                                            <label for="codigo_postal_registro" class="text-left">{l mod='genei' s ='Postal code'}</label>                                        
                                            <input id="codigo_postal_registro" name="codigo_postal_registro" class="form-control" type="text" placeholder="{l mod='genei' s ='Postal code'}" value="{$PS_SHOP_CODE|escape:'htmlall':'UTF-8'}">
                                        </div>                                        
                                        <div>                                            
                                            <label for="direccion_registro_adicional" class="text-left">{l mod='genei' s ='Address complement'}</label>                                        
                                            <input id="direccion_registro_adicional" name="direccion_registro_adicional" class="form-control" type="text" placeholder="{l mod='genei' s ='Address complement'}">
                                        </div>                                         
                                    <div id="capa_informacion_registro" class="col-md-12" style="margin-top:20px;color:red;display:none;"></div>        
                                    </div>                                    
                                    <div class="col-xs-12 col-md-6 formu">
                                        <div style="margin-top: 5px"> 
                                            <label for="pwd_registro" class="text-left">{l mod='genei' s ='Password'}</label>
                                            <input id="pwd_registro" name="pwd_registro" class="form-control" type="password" placeholder="{l mod='genei' s ='Password'}">
                                        </div>
                                        <div>
                                            <label for="telefono_registro" class="text-left">{l mod='genei' s ='Phone number'}</label>
                                            <input id="telefono_registro" name="telefono_registro" class="form-control" type="text" placeholder="{l mod='genei' s ='Phone number'}" value="{$PS_SHOP_PHONE|escape:'htmlall':'UTF-8'}">
                                        </div>
                                        <div>
                                            <label for="id_pais_registro" class="text-left block">{l mod='genei' s ='Country'}</label>
                                            <select name="id_pais_registro" class="form-control" id="id_pais_registro">                                                    
                                                {html_options options=$country_list_genei selected=$id_pais_selectionado}   
                                            </select>
                                        </div> 
                                        <div>
                                            <label for="poblacion_registro" class="text-left">{l mod='genei' s ='City'}</label>
                                            <input id="poblacion_registro" name="poblacion_registro" class="form-control" type="text" placeholder="{l mod='genei' s ='City'}" value="{$PS_SHOP_CITY|escape:'htmlall':'UTF-8'}">
                                        </div>
                                        <div style="margin-top:20px">
                                                <label for="condiciones_registro" class="text-left">
                                                <input id="condiciones_registro" name="condiciones_registro" type="checkbox">
                                                <a href="javascript:ver_mensaje_terminos_y_condiciones();">{l mod='genei' s ='I Accept Terms of service'}</a>
                                            </label>
                                         </div>   
                                            <div class=" col-md-12" style="margin-top:20px">
                                                <button id="boton_enviar_registro_genei" type="button" class="btn btn-lg btn-success" onclick="enviar_registro_genei()">
                                                    <a href="#">{l mod='genei' s ='Register'}</a>
                                                </button>  
                                            </div>                                            
                                    </div>
                                </div>
                                       
                                            
                                                                          
                                </form>                                                        
                        </div><!-- fin modal-body -->


                    </div><!-- fin modal-content --> 
                </div><!-- fin modal-dialog --> 
            </div><!-- fin modal fade --> 
    </div>