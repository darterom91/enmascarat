<?php
/**
 * 2016 Genei Gestión Logística
 *
 * GENEI S.L.
 *
 * NOTICE OF LICENSE
 *
 *  @author    Carlos Tornadijo Genei S.L.
 *  @copyright 2016 Genei S.L.
 *  @license   Commercial
 *  @version 2.0.0
 */

class GeneiController extends ModuleAdminController
{

    public $html;

    public function __construct()
    {
        $this->table = 'genei';
        $this->className = 'Genei';
        parent::__construct();
        
        
        if (Tools::getValue('action') == 'login_genei') {
            $this->loginGenei();
        }
        if (Tools::getValue('action') == 'logout_genei') {
            $this->logoutGenei();
        }
        if (Tools::getValue('action') == 'guardar_configuracion_genei') {
            $this->saveGeneiConfiguration();
        }
        if (Tools::getValue('action') == 'registro_genei') {
            die(Module::getInstanceByName('genei')->geneiSignUp(Tools::getValue('datos_json_registro_genei')));
        }
        if (Tools::getValue('action') == 'terminos_condiciones_genei') {
            die(Module::getInstanceByName('genei')->
                            showTermsGenei(Tools::getValue('datos_json_terminos_condiciones_genei')));
        }
        if (Tools::getValue('action') == 'obtener_lista_paises_genei') {
            die(Module::getInstanceByName('genei')->
                            getGeneiCountryList(Tools::getValue('datos_json_lista_paises_genei')));
        }
        if (Tools::getValue('action') == 'obtener_lista_provincias_genei') {
            die(Module::getInstanceByName('genei')->
                            getGeneiProvincesList(Tools::getValue('datos_json_lista_provincias_genei')));
        }
        
        if (Tools::getValue('action') == 'instalar_transportista_genei') {
            die(Module::getInstanceByName('genei')->
                            installGeneiCarrier(Tools::getValue('datos_json_instalar_transportista_genei')));
        }
        if (Tools::getValue('action') == 'desinstalar_transportista_genei') {
            die(Module::getInstanceByName('genei')->
                uninstallGeneiCarrier(Tools::getValue('datos_json_desinstalar_transportista_genei')));
        }
        if (Tools::getValue('action') == 'obtener_datos_pedido') {
            die(Module::getInstanceByName('genei')->
                getOrderData(Tools::getValue('datos_json_obtener_datos_pedido_genei'), true));
        }
        if (Tools::getValue('action') == 'buscar_precios_genei') {
            die(Module::getInstanceByName('genei')->
                searchGeneiPrices(Tools::getValue('datos_json_obtener_datos_buscar_precios_genei'), true));
        }
        if (Tools::getValue('action') == 'obtener_horas_recogida') {
            die(Module::getInstanceByName('genei')->
                getPickupHours(Tools::getValue('datos_json_obtener_horas_recogida_genei'), true));
        }
        
        if (Tools::getValue('action') == 'getUserRefs') {
            die(Module::getInstanceByName('genei')->
                getUserRefs(Tools::getValue('tipo'), Tools::getValue('cantidades'), Tools::getValue('grupos')));
        }
        
        
        
        if (Tools::getValue('action') == 'get_lista_oficina') {
            $datosArrayGetlistaOficinasDestino =
                Tools::jsonDecode(Tools::getValue('datos_json_get_lista_oficina'), true);
            die(Module::getInstanceByName('genei')->
                getListaOficinasDestino($datosArrayGetlistaOficinasDestino));
        }
        if (Tools::getValue('action') == 'obtener_datos_oficina') {
            die(Module::getInstanceByName('genei')->
                getCorreosOficinaData(Tools::getValue('datos_json_obtener_datos_oficina'), true));
        }
        if (Tools::getValue('action') == 'crear_envio') {
            die(Module::getInstanceByName('genei')->
                createShip(Tools::getValue('datos_json_crear_envio'), true));
        }
        if (Tools::getValue('action') == 'actualizar_estado_pedido') {
            die(Module::getInstanceByName('genei')->
                updateOrderStatus(Tools::getValue('datos_json_actualizar_estado_pedido_genei'), true));
        }
        if (Tools::getValue('action') == 'obtener_variaciones_precio_transportista') {
            die(Module::getInstanceByName('genei')->getCarrierVariationPriceJson(
                Tools::getValue('datos_json_obtener_variaciones_precio_transportista'),
                true
            ));
        }
        if (Tools::getValue('action') == 'comprobar_codigo_promocional') {
            die(Module::getInstanceByName('genei')->
                checkPromoCode(Tools::getValue('datos_json_promo_code'), true));
        }
        if (Tools::getValue('action') == 'obtener_valor_codigo_promocional') {
            die(Module::getInstanceByName('genei')->
                checkValuePromoCode(Tools::getValue('datos_json_promo_code'), true));
        }
        
        if (Tools::getValue('action') == 'obtener_maxima_cantidad_seguro') {
            die(Module::getInstanceByName('genei')->
                checkPromoCode(Tools::getValue('datos_json_promo_code'), true));
        }
    }

    public function saveGeneiConfiguration()
    {
        $datos_array = Tools::jsonDecode(Tools::getValue('datos_json_guardar_configuracion_genei'), true);
        foreach ($datos_array['array_variation_price_amount_genei'] as $key => $value) {
            if ($value == null) {
                unset($datos_array['array_variation_price_amount_genei'][$key]);
                unset($datos_array['array_variation_amount_free_genei'][$key]);
                unset($datos_array['array_variation_type_genei'][$key]);
            } else {
                Module::getInstanceByName('genei')->
                    setCarrierVariationPrice(
                        $key,
                        $datos_array['array_variation_price_amount_genei'][$key],
                        $datos_array['array_variation_amount_free_genei'][$key],
                        $datos_array['array_variation_type_genei'][$key]
                    );
            }
        }
        $datos_array['servicio'] = 'prestashop';
        if (Module::getInstanceByName('genei')->authenticatedUser($datos_array)) {
            Module::getInstanceByName('genei')->
                configurationUpdateValue('usuario_servicio_genei', $datos_array['usuario_servicio']);
            Module::getInstanceByName('genei')->
                configurationUpdateValue('password_servicio_genei', $datos_array['password_servicio']);
            Module::getInstanceByName('genei')->configurationUpdateValue('estado_autenticacion_genei', 1);
            Module::getInstanceByName('genei')->configurationUpdateValue(
                'estados_automaticos_pedidos_genei',
                $datos_array['estados_automaticos_pedidos_genei']
            );
            Module::getInstanceByName('genei')->configurationUpdateValue(
                'direccion_predeterminada_genei',
                $datos_array['direccion_predeterminada_genei']
            );
            $array_direcciones_genei =
            Tools::jsonDecode(Module::getInstanceByName('genei')->getAddressesList(), true);
            foreach ($array_direcciones_genei as $direccion) {
                if (array_key_exists('codigo', $direccion) &&
                    $direccion['codigo'] ==
                    Module::getInstanceByName('genei')->configurationGet('direccion_predeterminada_genei')) {
                    $array_direccion_seleccionada = $direccion;
                } else {
                    continue;
                }
            }
            $array_direccion_seleccionada_completa =
                Module::getInstanceByName('genei')->
                obtainAddressDataId($array_direccion_seleccionada['id_direccion']);
            Module::getInstanceByName('genei')->configurationUpdateValue(
                'direccion_predeterminada_genei_json',
                $array_direccion_seleccionada_completa
            );

            if (!array_key_exists('estado_recogida_tramitada_genei_default', $datos_array)
                || $datos_array['estado_recogida_tramitada_genei_default'] == null
                || $datos_array['estado_recogida_tramitada_genei_default'] == '') {
                $datos_array['estado_recogida_tramitada_genei_default'] = 0;
            }
            $estado_recogida_tramitada_genei = $datos_array['estado_recogida_tramitada_genei_default'];
            Module::getInstanceByName('genei')->
                configurationUpdateValue('estado_recogida_tramitada_genei', $estado_recogida_tramitada_genei);
            if (!array_key_exists('estado_envio_transito_genei_default', $datos_array)
                || $datos_array['estado_envio_transito_genei_default'] == null
                || $datos_array['estado_envio_transito_genei_default'] == '') {
                $datos_array['estado_envio_transito_genei_default'] = 0;
            }
            $estado_envio_transito_genei = $datos_array['estado_envio_transito_genei_default'];
            Module::getInstanceByName('genei')->
                configurationUpdateValue('estado_envio_transito_genei', $estado_envio_transito_genei);
            if (!array_key_exists('estado_envio_incidencia_genei_default', $datos_array)
                || $datos_array['estado_envio_incidencia_genei_default'] == null
                || $datos_array['estado_envio_incidencia_genei_default'] == '') {
                $datos_array['estado_envio_incidencia_genei_default'] = 0;
            }
            $estado_envio_incidencia_genei = $datos_array['estado_envio_incidencia_genei_default'];
            Module::getInstanceByName('genei')->
                configurationUpdateValue('estado_envio_incidencia_genei', $estado_envio_incidencia_genei);
            if (!array_key_exists('estado_envio_entregado_genei_default', $datos_array)
                || $datos_array['estado_envio_entregado_genei_default'] == null
                || $datos_array['estado_envio_entregado_genei_default'] == '') {
                $datos_array['estado_envio_entregado_genei_default'] = 0;
            }
            $estado_envio_entregado_genei = $datos_array['estado_envio_entregado_genei_default'];
            Module::getInstanceByName('genei')->
                configurationUpdateValue('estado_envio_entregado_genei', $estado_envio_entregado_genei);
            if (!array_key_exists('atributos_defecto_genei_default', $datos_array)
                || $datos_array['atributos_defecto_genei_default'] == null
                || $datos_array['atributos_defecto_genei_default'] == '') {
                $datos_array['atributos_defecto_genei_default'] = 0;
            }
            $atributos_defecto_genei_default = $datos_array['atributos_defecto_genei_default'];
            Module::getInstanceByName('genei')->configurationUpdateValue(
                'atributos_defecto_genei_default',
                $atributos_defecto_genei_default
            );
            if (!array_key_exists('metodo_pago_contrareembolso_defecto_genei_default', $datos_array)
                || $datos_array['metodo_pago_contrareembolso_defecto_genei_default'] == null
                || $datos_array['metodo_pago_contrareembolso_defecto_genei_default'] == '') {
                $datos_array['metodo_pago_contrareembolso_defecto_genei_default'] = 0;
            }
            $metodo_pago_contrareembolso_defecto_genei_default =
                $datos_array['metodo_pago_contrareembolso_defecto_genei_default'];
            Module::getInstanceByName('genei')->configurationUpdateValue(
                'metodo_pago_contrareembolso_defecto_genei_default',
                $metodo_pago_contrareembolso_defecto_genei_default
            );
            if (!array_key_exists('peso_defecto_genei', $datos_array)
                || $datos_array['peso_defecto_genei'] == null
                || $datos_array['peso_defecto_genei'] == '') {
                $datos_array['peso_defecto_genei'] = 1;
            }
            $peso_defecto_genei = $datos_array['peso_defecto_genei'];
            Module::getInstanceByName('genei')->
                configurationUpdateValue('peso_defecto_genei', $peso_defecto_genei);
            if (!array_key_exists('largo_defecto_genei', $datos_array)
                || $datos_array['largo_defecto_genei'] == null
                || $datos_array['largo_defecto_genei'] == '') {
                $datos_array['largo_defecto_genei'] = 1;
            }
            $largo_defecto_genei = $datos_array['largo_defecto_genei'];
            Module::getInstanceByName('genei')->
                configurationUpdateValue('largo_defecto_genei', $largo_defecto_genei);
            if (!array_key_exists('ancho_defecto_genei', $datos_array)
                || $datos_array['ancho_defecto_genei'] == null
                || $datos_array['ancho_defecto_genei'] == '') {
                $datos_array['ancho_defecto_genei'] = 1;
            }
            $ancho_defecto_genei = $datos_array['ancho_defecto_genei'];
            Module::getInstanceByName('genei')->
                configurationUpdateValue('ancho_defecto_genei', $ancho_defecto_genei);
            if (!array_key_exists('alto_defecto_genei', $datos_array)
                || $datos_array['alto_defecto_genei'] == null
                || $datos_array['alto_defecto_genei'] == '') {
                $datos_array['alto_defecto_genei'] = 1;
            }
            $alto_defecto_genei = $datos_array['alto_defecto_genei'];
            Module::getInstanceByName('genei')->
                configurationUpdateValue('alto_defecto_genei', $alto_defecto_genei);
            if (!array_key_exists('num_bultos_defecto_genei', $datos_array)
                || $datos_array['num_bultos_defecto_genei'] == null
                || $datos_array['num_bultos_defecto_genei'] == '') {
                $datos_array['num_bultos_defecto_genei'] = 1;
            }
            $num_bultos_defecto_genei = $datos_array['num_bultos_defecto_genei'];
            Module::getInstanceByName('genei')->
                configurationUpdateValue('num_bultos_defecto_genei', $num_bultos_defecto_genei);
            if (array_key_exists('google_api_key', $datos_array)) {
                Module::getInstanceByName('genei')->configurationUpdateValue(
                    'google_api_key',
                    $datos_array['google_api_key']
                );
            }
            Module::getInstanceByName('genei')->dropAddressesListBD();
            Module::getInstanceByName('genei')->dropAddressesDataIdBD();
            Module::getInstanceByName('genei')->createTableAddressDataID();
            Module::getInstanceByName('genei')->createTableAddress();
            die(Tools::jsonEncode(array('error' => 'Login correcto', 'resultado' => 1,
                'array_direcciones_formateado' =>
                Module::getInstanceByName('genei')->prepareGeneiAddressList())));
        } else {
            die(Tools::jsonEncode(array('error' => 'Login incorrecto', 'resultado' => 0)));
        }
    }

    public function loginGenei()
    {
        $datos_array = Tools::jsonDecode(Tools::getValue('datos_json_registro_genei'), true);
        $datos_array['servicio'] = 'prestashop';
        if (Module::getInstanceByName('genei')->authenticatedUser($datos_array)) {
            Module::getInstanceByName('genei')->
                configurationUpdateValue('usuario_servicio_genei', $datos_array['usuario_servicio']);
            Module::getInstanceByName('genei')->
                configurationUpdateValue('password_servicio_genei', $datos_array['password_servicio']);
            Module::getInstanceByName('genei')->
                configurationUpdateValue('estado_autenticacion_genei', 1);
            die(
                Tools::jsonEncode(
                    array(
                        'error' => 'Login correcto', 'resultado' => 1,
                        'array_direcciones_formateado' =>
                        Module::getInstanceByName('genei')->prepareGeneiAddressList()
                    )
                )
            );
        } else {
            Module::getInstanceByName('genei')->configurationUpdateValue('estado_autenticacion_genei', 0);
            die(Tools::jsonEncode(array('error' => 'Login incorrecto', 'resultado' => 0)));
        }
    }

    public function logoutGenei()
    {
        Module::getInstanceByName('genei')->configurationUpdateValue('usuario_servicio_genei', '');
        Module::getInstanceByName('genei')->configurationUpdateValue('password_servicio_genei', '');
        Module::getInstanceByName('genei')->configurationUpdateValue('estado_autenticacion_genei', 0);
        Module::getInstanceByName('genei')->configurationUpdateValue('agencias_genei', null);
        Module::getInstanceByName('genei')->configurationUpdateValue('direcciones_genei', null);
        Module::getInstanceByName('genei')->configurationUpdateValue('estado_autenticacion_genei', 0);
        Module::getInstanceByName('genei')->configurationUpdateValue('usuario_servicio_genei', null);
        Module::getInstanceByName('genei')->configurationUpdateValue('password_servicio_genei', null);
        Module::getInstanceByName('genei')->
            configurationUpdateValue('observaciones_recogida_defecto_genei', null);
        Module::getInstanceByName('genei')->configurationUpdateValue('observaciones_entrega_defecto_genei', null);
        die(Tools::jsonEncode(array('error' => 'Ha sido desconectado', 'resultado' => 0)));
    }

    public function initContent()
    {
        $this->postProcess();
        $this->context->controller->addJS(_MODULE_DIR_ . 'genei/js/script.js');
        $this->context->controller->addCSS(_MODULE_DIR_ . 'genei/css/style.css');
        $this->show_toolbar = true;
        $this->display = 'view';
        $this->meta_title = $this->l('Login in Genei');
        parent::initContent();
    }

    public function initToolBarTitle()
    {
        $this->toolbar_title = $this->l('Login');
    }

    public function initToolBar()
    {
        return true;
    }

    public function display()
    {
        parent::display();
    }

    public function renderView()
    {
        //   echo $this->createTemplate('geneilogin.tpl')->fetch();

        die();
    }

    public function postProcess()
    {

        if (Tools::getValue('product_id') && Tools::getValue('product_name')) {
            $product = new Product(Tools::getValue('product_id'));
            $product->name = Tools::getValue('product_name');
            if ($product->update()) {
                $this->_html .= $this->l('Product updated!!');
            }
        }
    }
}
