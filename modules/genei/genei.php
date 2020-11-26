<?php
/**
 * 2018 Genei Gestión Logística
 *
 * GENEI S.L.
 *
 *
 * NOTICE OF LICENSE
 *
 *  @author    Carlos Tornadijo Genei S.L.
 *  @copyright 2016 Genei S.L.
 *  @license   Commercial
 *  @version 3.1.7
 */

class Genei extends Module
{

    const SERVICIO = 'prestashop';
    const ARRAY_UPS = array(5,10,23,24,25,26,27,30,41,43,56,77,88,113,114,120,124,125,133,134);
    public function __construct()
    {
        $this->name = 'genei';
        $this->tab = 'shipping_logistics';
        $this->author = 'Genei S.L.';
        $this->version = '3.1.7';
        $this->cn = 317;
        $this->module_key = '485bedae8e31b1e48fbd2d3b65469326';
        $this->ps_versions_compliancy['min'] = '1.6.0.1';
        $this->ps_versions_compliancy['max'] = '1.7.9.9';
        parent::__construct();
        $this->errors = array();
        $this->displayName = $this->l('Genei Logistic Management');
        $this->description = $this->l('Your shipments at the best price.');
        $this->bootstrap = true;
    }

    
    
    public function checkInstallationValues()
    {
        if (file_exists(_PS_ROOT_DIR_ . DIRECTORY_SEPARATOR . 'cache/class_index.php')) {
            unlink(_PS_ROOT_DIR_ . DIRECTORY_SEPARATOR . 'cache/class_index.php');
        }
        // Check module name validation
        if (!Validate::isModuleName($this->name)) {
            die(Tools::displayError());
        }
        // Check PS version compliancy
        if (version_compare(_PS_VERSION_, $this->ps_versions_compliancy['min']) < 0 ||
            version_compare(_PS_VERSION_, $this->ps_versions_compliancy['max']) >= 0) {
            $this->_errors[] =
                $this->l('Incompatible PrestaShop version. Please contact us through PrestaShop Addons help you');
            return false;
        }
        try {
            $this->installOverrides();
        } catch (Exception $e) {
            //Do nothing
        }
        return true;
    }

    public function registerHooks()
    {
        if ($this->registerHook('displayAdminOrder')
            && $this->registerHook('actionCarrierUpdate')
            && $this->registerHook('actionCarrierProcess')
            && $this->registerHook('displayAfterCarrier')) {
            return true;
        } else {
            $this->_errors[] = $this->l('Unable to install hooks.');
            return false;
        }
    }

    public function createInitialTables()
    {
        if (!Db::getInstance()->execute(
            'CREATE TABLE IF NOT EXISTS `' . _DB_PREFIX_ . 'genei_carriers` (
                `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
                `id_carrier` INT( 11 ) UNSIGNED NOT NULL,
                `id_genei_carrier` INT( 11 ) UNSIGNED NOT NULL,
                `price_variation` FLOAT( 11 ) NOT NULL,
                `variation_type` TINYINT (11),
                `amount_free` FLOAT( 11 ) NOT NULL DEFAULT 0,
                PRIMARY KEY (`id`)
             ) ENGINE=' . _MYSQL_ENGINE_ . ' DEFAULT CHARSET=utf8'
        )) {
            $this->_errors[] = sprintf(Tools::displayError($this->l('Unable to create carriers table.')));
        }
        Db::getInstance()->execute(
            'ALTER TABLE `ps_genei_carriers`
            ALTER `price_variation` DROP DEFAULT;
            ALTER TABLE `ps_genei_carriers`
            CHANGE COLUMN `price_variation` `price_variation` FLOAT NOT NULL AFTER `id_genei_carrier`,
            CHANGE COLUMN `amount_free` `amount_free` FLOAT NOT NULL DEFAULT \'0\' AFTER `variation_type`;'
        );
        if (!Db::getInstance()->execute(
            'CREATE TABLE IF NOT EXISTS `' . _DB_PREFIX_ . 'genei_cart_price` (
	`id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
        `json_request` VARCHAR(150) NULL DEFAULT NULL,
	`json_response` TEXT NULL DEFAULT NULL,
	`fecha_hora` DATETIME NULL DEFAULT NULL,
	PRIMARY KEY (`id`),
	INDEX `json_request` (`json_request`)
        ) ENGINE=' . _MYSQL_ENGINE_ . ' DEFAULT CHARSET=utf8'
        )) {
            $this->_errors[] = sprintf(Tools::displayError($this->l('Unable to create Genei prices table.')));
        }
        if (!Db::getInstance()->execute(
            'CREATE TABLE IF NOT EXISTS `' . _DB_PREFIX_ . 'genei_array_boxes` (
                                `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
                                `id_cart` INT( 11 ) UNSIGNED NOT NULL DEFAULT \'0\',
                                `box_weight` INT( 11 ) UNSIGNED NOT NULL DEFAULT \'0\',
                                `box_width` INT( 11 ) UNSIGNED NOT NULL DEFAULT \'0\',
                                `box_height` INT( 11 ) UNSIGNED NOT NULL DEFAULT \'0\',
                                `box_depth` INT( 11 ) UNSIGNED NOT NULL DEFAULT \'0\',
                                PRIMARY KEY (`id`),
                                INDEX `id_cart` (`id_cart`)
                                ) ENGINE=' . _MYSQL_ENGINE_ . ' DEFAULT CHARSET=utf8'
        )) {
            $this->_errors[] = sprintf(Tools::displayError($this->l('Unable to create Genei items price table.')));
        }
        if (!Db::getInstance()->execute(
            'CREATE TABLE IF NOT EXISTS `' . _DB_PREFIX_ . 'genei_configuration` (
            `id_configuration` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
            `id_shop_group` INT(11) UNSIGNED NULL DEFAULT NULL,
            `id_shop` INT(11) UNSIGNED NULL DEFAULT NULL,
            `name` VARCHAR(254) NOT NULL,
            `value` TEXT NULL,
            `date_add` DATETIME NOT NULL,
            `date_upd` DATETIME NOT NULL,
            PRIMARY KEY (`id_configuration`),
            INDEX `name` (`name`),
            INDEX `id_shop` (`id_shop`),
            INDEX `id_shop_group` (`id_shop_group`)
            ) ENGINE=' . _MYSQL_ENGINE_ . ' DEFAULT CHARSET=utf8'
        )) {
            $this->_errors[] = sprintf(Tools::displayError($this->l('Unable to create Genei configuration table.')));
        }
        if (!Db::getInstance()->execute(
            'CREATE TABLE IF NOT EXISTS `' . _DB_PREFIX_ . 'genei_cart_delivery_point` (
                                `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
                                `id_cart` INT( 11 ) UNSIGNED NOT NULL DEFAULT \'0\',
                                `id_delivery_point` INT( 11 ) UNSIGNED NOT NULL DEFAULT \'0\',
                                PRIMARY KEY (`id`),
                                INDEX `id_cart` (`id_cart`)
                                ) ENGINE=' . _MYSQL_ENGINE_ . ' DEFAULT CHARSET=utf8'
        )) {
            $this->_errors[] = sprintf(Tools::displayError(
                $this->l('Unable to create Genei delivery points cart table.')
            ));
        }
        Db::getInstance()->execute(
            'DROP TABLE IF EXISTS `' . _DB_PREFIX_ . 'genei_addresses`'
        );
        Db::getInstance()->execute(
            'DROP TABLE IF EXISTS `' . _DB_PREFIX_ . 'genei_addressdata`'
        );
        $this->createTableAddressDataID();
        $this->createTableAddress();
        return true;
    }

    public function installTab($parent, $class_name, $tab_name)
    {
        $tab = new Tab();
        $tab->id_parent = (int) Tab::getIdFromClassName($parent);
        $tab->name = array();
        foreach (Language::getLanguages(true) as $lang) {
            $tab->name[$lang['id_lang']] = $tab_name;
        }
        $tab->class_name = $class_name;
        $tab->module = $this->name;
        $tab->active = 1;
        if ($tab->add()) {
            return true;
        } else {
            $this->_errors[] = sprintf(Tools::displayError($this->l('Unable to add Admin Tab.')));
        }
    }

    public function cleanEnvironment()
    {
        $this->configurationUpdateValue('estado_autenticacion_genei', 0);
        Tools::clearSmartyCache();
        Tools::clearXMLCache();
        Media::clearCache();
        Tools::generateIndex();
        return true;
    }

    public function install()
    {
        parent::uninstall();
        $parent_tab = (int) Tab::getIdFromClassName('AdminModules');
        return parent::install()
            && $this->checkInstallationValues()
            && $this->createInitialTables()
            && $this->installTab($parent_tab, 'Genei', 'Genei')
            && $this->registerHooks()
            && $this->cleanEnvironment();
    }

    public function uninstallTabs()
    {
        $moduleTabs = Tab::getCollectionFromModule($this->name);
        if (!empty($moduleTabs)) {
            foreach ($moduleTabs as $moduleTab) {
                $moduleTab->delete();
            }
        }
        return true;
    }

    public function uninstall()
    {


        return parent::uninstall()
            && $this->unregisterHook('displayAdminOrder')
            && $this->unregisterHook('actionCarrierUpdate')
            && $this->unregisterHook('actionCarrierProcess')
            && $this->unregisterHook('displayAfterCarrier')
            && parent::uninstallOverrides()
            && $this->uninstallTabs()
            && $this->deleteAllGeneiCarriers()
            && $this->uninstallClasses()
            && $this->deleteAllGeneiTables();
    }

    public function deleteAllGeneiTables()
    {
        Db::getInstance()->execute(
            'DROP TABLE IF EXISTS `' . _DB_PREFIX_ . 'genei_carriers`'
        );
        Db::getInstance()->execute(
            'DROP TABLE IF EXISTS `' . _DB_PREFIX_ . 'genei_cart_price`'
        );
        Db::getInstance()->execute(
            'DROP TABLE IF EXISTS `' . _DB_PREFIX_ . 'genei_cart_array_boxes`'
        );
        Db::getInstance()->execute(
            'DROP TABLE IF EXISTS `' . _DB_PREFIX_ . 'genei_configuration`'
        );
        Db::getInstance()->execute(
            'DROP TABLE IF EXISTS `' . _DB_PREFIX_ . 'genei_cart_delivery_point`'
        );
        Db::getInstance()->execute(
            'DROP TABLE IF EXISTS `' . _DB_PREFIX_ . 'genei_addresses`'
        );
        Db::getInstance()->execute(
            'DROP TABLE IF EXISTS `' . _DB_PREFIX_ . 'genei_addressdata`'
        );
        return true;
    }

    public function uninstallClasses()
    {
        if (file_exists(_PS_ROOT_DIR_ . '/cache/class_index.php')) {
            unlink(_PS_ROOT_DIR_ . '/cache/class_index.php');
        }
        if (file_exists(_PS_ROOT_DIR_ . '/override/classes/Cart.php')) {
            unlink(_PS_ROOT_DIR_ . '/override/classes/Cart.php');
        }
        if (file_exists(_PS_ROOT_DIR_ . '/override/controllers/admin/AdminCarriersController.php')) {
            unlink(_PS_ROOT_DIR_ . '/override/controllers/admin/AdminCarriersController.php');
        }
        return true;
    }

    public function enable($force_all = false)
    {
        parent::enable();
        try {
            if (parent::enable($force_all)) {
                parent::installOverrides();
            }
        } catch (Exception $e) {
            //Do nothing
        }
        return parent::enable();
    }

    public function disable($force_all = false)
    {
        try {
            parent::disable($force_all);
            parent::uninstallOverrides();
        } catch (Exception $e) {
            $this->_errors[] = sprintf(
                Tools::displayError(
                    $this->l(
                        'Unable to uninstall a override. '
                        . 'Please enable overrides under Advanced Parameters -> Performance.'
                    )
                ),
                $e->getMessage()
            );
            return false;
        }
        return parent::disable();
    }

    public function getContent()
    {
        $output = '<h2>' . $this->displayName . '</h2>';
        $this->context->smarty->assign('datos_guardados_genei', Tools::getValue('datos_guardados_genei'));
        return $output . $this->displayForm();
    }

    public function authenticatedUser($datos_array)
    {
        if ($this->configurationGet('estado_autenticacion_genei') == 1) {
            return true;
        }
        $url = 'http://www.genei.es/json_interface/autenticacion';
        if (Tools::jsonDecode($this->curlJson($datos_array, $url), true)) {
            $this->configurationUpdateValue(
                'agencias_genei_no_utilizadas',
                $this->getNotInstalledCarriersList($datos_array)
            );
            $this->configurationUpdateValue(
                'agencias_genei_utilizadas',
                $this->getInstalledCarriersList($datos_array)
            );
            $this->configurationUpdateValue(
                'direcciones_genei',
                $this->getAddressesList(0)
            );
            $this->configurationUpdateValue(
                'estado_autenticacion_genei',
                Tools::GetValue('estado_autenticacion_genei')
            );
            $this->configurationUpdateValue(
                'usuario_servicio_genei',
                $datos_array['usuario_servicio']
            );
            $this->configurationUpdateValue(
                'password_servicio_genei',
                $datos_array['password_servicio']
            );
            return true;
        } else {
            $this->dropAddressesListBD();
            $this->dropAddressesDataIdBD();
            $this->createTableAddress();
            $this->createTableAddressDataID();
            $this->configurationUpdateValue('agencias_genei_utilizadas', null);
            $this->configurationUpdateValue('agencias_genei_no_utilizadas', null);
            $this->configurationUpdateValue('direcciones_genei', null);
            $this->configurationUpdateValue('estado_autenticacion_genei', 0);
            return false;
        }
    }

    public function getAgenciesPriceList($datos_array)
    {
        $datos_array['usuario_servicio'] = $this->configurationGet('usuario_servicio_genei');
        $datos_array['password_servicio'] = $this->configurationGet('password_servicio_genei');
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $url = 'http://www.genei.es/json_interface/obtener_listado_agencias_precios';
        $json_request = md5(Tools::jsonEncode($datos_array));
        $json_response = $this->getJsonRequest($json_request);
        if (Tools::strlen($json_response) > 20) {
            return Tools::jsonDecode($json_response, true);
        }
        $json_response = $this->curlJson($datos_array, $url);
        $this->deleteOldJsonRequests();
        $this->saveJsonRequest($json_request, $json_response);
        return Tools::jsonDecode($json_response, true);
    }

    public function getCorreosOficinaData($datos_json_obtener_datos_oficina)
    {
        $datos_array = Tools::jsonDecode($datos_json_obtener_datos_oficina, true);
        $datos_array['usuario_servicio'] = $this->configurationGet('usuario_servicio_genei');
        $datos_array['password_servicio'] = $this->configurationGet('password_servicio_genei');
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $url = 'http://www.genei.es/json_interface/obtener_datos_oficina';
        return $this->curlJson($datos_array, $url);
    }
    

    private function getNotInstalledCarriersListVisibles($datos_array)
    {
        $datos_array['usuario_servicio'] = $this->configurationGet('usuario_servicio_genei');
        $datos_array['password_servicio'] = $this->configurationGet('password_servicio_genei');
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $url = 'http://www.genei.es/json_interface/obtener_lista_agencias_disponibles';
        $array_agencias = Tools::jsonDecode($this->curlJson($datos_array, $url), true);
        $url = 'http://www.genei.es/json_interface/obtener_agencias_ups_tipos';
        $array_agencias_ups_tipos = Tools::jsonDecode($this->curlJson($datos_array, $url), true);
        if (is_array($array_agencias)) {
            if (count($array_agencias) > 0) {
                foreach (array_keys($array_agencias) as $key) {
                    if (in_array($key, array_keys($this->getAllCarriersVariationPriceAmount()))) {
                        unset($array_agencias[$key]);
                    }
                }
                foreach (array_keys($array_agencias) as $key) {
                    $resultado_tipo = $this->carrierInUpsTypes($key, $array_agencias_ups_tipos);
                    if ($resultado_tipo['found']) {
                        $array_agencias[$resultado_tipo['tipo']] = $resultado_tipo['nombre_tipo'];
                    }
                }
                foreach (array_keys($array_agencias) as $key) {
                    if (in_array($key, self::ARRAY_UPS)) {
                        unset($array_agencias[$key]);
                    }
                }
            }
        }
        return Tools::jsonEncode($array_agencias);
    }

    private function getInstalledCarriersListVisibles($datos_array)
    {
        $datos_array['usuario_servicio'] = $this->configurationGet('usuario_servicio_genei');
        $datos_array['password_servicio'] = $this->configurationGet('password_servicio_genei');
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $url = 'http://www.genei.es/json_interface/obtener_lista_agencias_disponibles';
        $array_agencias = Tools::jsonDecode($this->curlJson($datos_array, $url), true);
        $url = 'http://www.genei.es/json_interface/obtener_agencias_ups_tipos';
        $array_agencias_ups_tipos = Tools::jsonDecode($this->curlJson($datos_array, $url), true);
        if (is_array($array_agencias)) {
            if (count($array_agencias) > 0) {
                foreach (array_keys($array_agencias) as $key) {
                    if (!in_array($key, array_keys($this->getAllCarriersVariationPriceAmount()))) {
                        unset($array_agencias[$key]);
                    }
                }
                foreach (array_keys($array_agencias) as $key) {
                    $resultado_tipo = $this->carrierInUpsTypes($key, $array_agencias_ups_tipos);
                    if ($resultado_tipo['found']) {
                        $array_agencias[$resultado_tipo['tipo']] = $resultado_tipo['nombre_tipo'];
                    }
                }
                foreach (array_keys($array_agencias) as $key) {
                    if (in_array($key, self::ARRAY_UPS)) {
                        unset($array_agencias[$key]);
                    }
                }
            }
        }
        return Tools::jsonEncode($array_agencias);
    }


    private function getNotInstalledCarriersList($datos_array)
    {
        $datos_array['usuario_servicio'] = $this->configurationGet('usuario_servicio_genei');
        $datos_array['password_servicio'] = $this->configurationGet('password_servicio_genei');
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $url = 'http://www.genei.es/json_interface/obtener_lista_agencias_disponibles';
        $array_agencias = Tools::jsonDecode($this->curlJson($datos_array, $url), true);
        if (is_array($array_agencias)) {
            if (count($array_agencias) > 0) {
                foreach (array_keys($array_agencias) as $key) {
                    if (in_array($key, array_keys($this->getAllCarriersVariationPriceAmount()))) {
                        unset($array_agencias[$key]);
                    }
                }
            }
        }
        return Tools::jsonEncode($array_agencias);
    }

    private function getInstalledCarriersList($datos_array)
    {
        $datos_array['usuario_servicio'] = $this->configurationGet('usuario_servicio_genei');
        $datos_array['password_servicio'] = $this->configurationGet('password_servicio_genei');
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $url = 'http://www.genei.es/json_interface/obtener_lista_agencias_disponibles';
        $array_agencias = Tools::jsonDecode($this->curlJson($datos_array, $url), true);
        if (is_array($array_agencias)) {
            if (count($array_agencias) > 0) {
                foreach (array_keys($array_agencias) as $key) {
                    if (!in_array($key, array_keys($this->getAllCarriersVariationPriceAmount()))) {
                        unset($array_agencias[$key]);
                    }
                }
            }
        }
        return Tools::jsonEncode($array_agencias);
    }

    private function carrierInUpsTypes($id_agencia, $array_agencias_ups_tipos)
    {
        $tipo = 0;
        $found = false;
        $nombre_tipo= '';
        foreach ($array_agencias_ups_tipos as $key => $value) {
            foreach ($value['ids_agencias'] as $agencias_tipo) {
                if ($agencias_tipo["id_agencia"] == $id_agencia) {
                    $tipo = $key;
                    $nombre_tipo = $value['nombre_tipo'];
                    $found = true;
                }
            }
        }
        return array('tipo' => $tipo, 'found' => $found, 'nombre_tipo'=> $nombre_tipo);
    }


    private function getUpsAccessPointData($datos_array)
    {
        $datos_array['usuario_servicio'] = $this->configurationGet('usuario_servicio_genei');
        $datos_array['password_servicio'] = $this->configurationGet('password_servicio_genei');
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $url = 'http://www.genei.es/json_interface/obtener_lista_access_point';
        return $this->curlJson($datos_array, $url);
    }

    public function getListaOficinasDestino($datos_array)
    {
        $datos_array['usuario_servicio'] = $this->configurationGet('usuario_servicio_genei');
        $datos_array['password_servicio'] = $this->configurationGet('password_servicio_genei');
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $url = 'http://www.genei.es/json_interface/localizar_oficina';
        return $this->curlJson($datos_array, $url);
    }

    

    private function getCarriersList($datos_array)
    {
        $datos_array['usuario_servicio'] = $this->configurationGet('usuario_servicio_genei');
        $datos_array['password_servicio'] = $this->configurationGet('password_servicio_genei');
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $url = 'http://www.genei.es/json_interface/obtener_lista_agencias_disponibles';
        return $this->curlJson($datos_array, $url);
    }

    private function getCorreosGoodsList()
    {
        $datos_array = array();
        $datos_array['usuario_servicio'] = $this->configurationGet('usuario_servicio_genei');
        $datos_array['password_servicio'] = $this->configurationGet('password_servicio_genei');
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $url = 'http://www.genei.es/json_interface/obtener_lista_tipo_mercancia_correos';
        return $this->curlJson($datos_array, $url);
    }

    public function getAddressesList($cache = 1)
    {
        $addressListBD = Tools::jsonDecode($this->getAddressesListBD(), true);
        if (is_array($addressListBD) && count($addressListBD)> 0
                && $cache == 1
                && Tools::strlen($addressListBD['addresses'] > 10)
                && strtotime($addressListBD['fecha_hora_insercion']) >= (strtotime(' -1 hour'))) {
            return $addressListBD['addresses'];
        }
        $datos_array = array();
        $datos_array['usuario_servicio'] = $this->configurationGet('usuario_servicio_genei');
        $datos_array['password_servicio'] = $this->configurationGet('password_servicio_genei');
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $url = 'http://www.genei.es/json_interface/obtener_listado_direcciones_parcial_usuario';
        $datos_array['id_usuario'] = $this->getUserId($datos_array);
        $addressesJSON = $this->curlJson($datos_array, $url);
        if ($cache == 1) {
            $this->insertAddressesListBD($addressesJSON);
        }
        return $addressesJSON;
    }
    
    public function getUserRefs($tipo = 1, $cantidades = '', $grupos = '')
    {
        $datos_array = array();
        $datos_array['usuario_servicio'] = $this->configurationGet('usuario_servicio_genei');
        $datos_array['password_servicio'] = $this->configurationGet('password_servicio_genei');
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $url = 'http://www.genei.es/json_interface/obtener_referencias_usuario';
        $datos_array['id_usuario'] = $this->getUserId($datos_array);
        $datos_array['cantidades'] = $cantidades;
        $datos_array['grupos'] = $grupos;
        $datos_array['tipo'] = $tipo;
        return $this->curlJson($datos_array, $url);
    }
    
   

    public function createShip($datos_json_crear_envio)
    {
        $datos_array = $this->calculateOrderData($datos_json_crear_envio);
        $datos_array['usuario_servicio'] = $this->configurationGet('usuario_servicio_genei');
        $datos_array['password_servicio'] = $this->configurationGet('password_servicio_genei');
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $url = 'http://www.genei.es/json_interface/crear_envio';
        $datos_array['id_usuario'] = $this->getUserId($datos_array);
        return $this->curlJson($datos_array, $url);
    }

    public function checkPromoCode($datos_json_promo_code)
    {
        $datos_array = array();
        $datos_array['cod_promo'] =
            Tools::jsonDecode($datos_json_promo_code, true)['codigo_promocional_pag_pedido_genei'];
        $datos_array['usuario_servicio'] = $this->configurationGet('usuario_servicio_genei');
        $datos_array['password_servicio'] = $this->configurationGet('password_servicio_genei');
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $url = 'http://www.genei.es/json_interface/comprobar_codigo_promocional';
        $datos_array['id_usuario'] = $this->getUserId($datos_array);
        return $this->curlJson($datos_array, $url);
    }

    public function checkValuePromoCode($datos_json_promo_code)
    {
        $datos_array = array();
        $datos_array['cod_promo'] =
            Tools::jsonDecode($datos_json_promo_code, true)['codigo_promocional_pag_pedido_genei'];
        $datos_array['usuario_servicio'] = $this->configurationGet('usuario_servicio_genei');
        $datos_array['password_servicio'] = $this->configurationGet('password_servicio_genei');
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $url = 'http://www.genei.es/json_interface/comprobar_valor_codigo_promocional';
        $datos_array['id_usuario'] = $this->getUserId($datos_array);
        return $this->curlJson($datos_array, $url);
    }

    public function getShipCodeExternalService($codigo_envio_externo)
    {
        $datos_array = array();
        $datos_array['usuario_servicio'] = $this->configurationGet('usuario_servicio_genei');
        $datos_array['password_servicio'] = $this->configurationGet('password_servicio_genei');
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $datos_array['codigo_envio_externo'] = $codigo_envio_externo;
        $url = 'http://www.genei.es/json_interface/obtener_codigo_envio_servicio_externo';
        $datos_array['id_usuario'] = $this->getUserId($datos_array);
        $salida = $this->curlJson($datos_array, $url);
        return $salida;
    }

    public function setOrderState($id_orden, $estado_genei)
    {
        $estado_prestashop = $this->convertGeneiStatusToPrestaShop($estado_genei);
        $objOrder = new Order($id_orden);
        $history = new OrderHistory();
        if ($estado_prestashop != 0 && $objOrder->current_state != $estado_prestashop) {
            $history->id_order = (int) $objOrder->id;
            $history->changeIdOrderState($estado_prestashop, (int) ($objOrder->id));
            $history->addWithemail(true);
            //$history->addWs();
        }
    }

    public function setOrderTrackCode($id_orden, $codigo_seguimiento)
    {
        if ($codigo_seguimiento != '') {
            $objOrder = new Order($id_orden);
            $objOrder->setWsShippingNumber($codigo_seguimiento);
        }
    }

    public function getStatusesList()
    {
        $default_lang = $this->context->language->id;
        $order_states = OrderState::getOrderStates($default_lang);
        $array_estados = array();
        foreach ($order_states as $estado) {
            $array_estados[$estado['id_order_state']] = $estado['name'];
        }
        return $array_estados;
    }

    public function getPaymentMethod($id_orden)
    {
        $objOrder = new Order($id_orden);
        return($objOrder->payment);
    }

    public function isCodOrder($id_orden)
    {
        $array_metodos_pago = $this->getArrayPayMethods();
        if (!array_key_exists(
            $this->configurationGet('metodo_pago_contrareembolso_defecto_genei_default'),
            $array_metodos_pago
        )) {
            $this->configurationUpdateValue('metodo_pago_contrareembolso_defecto_genei_default', 3);
        }
        if (array_key_exists(
            $this->configurationGet('metodo_pago_contrareembolso_defecto_genei_default'),
            $array_metodos_pago
        )) {
            if ($this->getPaymentMethod($id_orden) ==
                $array_metodos_pago[$this->configurationGet('metodo_pago_contrareembolso_defecto_genei_default')]) {
                return true;
            } else {
                return false;
            }
        }
        return false;
    }

    public function getOrderPrice($id_orden)
    {
        $objOrder = new Order($id_orden);
        return($objOrder->total_paid);
    }

    public function getUserComments($id_orden)
    {
        $order_message = Message::getMessagesByOrderId($id_orden, false);
        if (count($order_message) > 0) {
            return ($order_message[0]['message']);
        } else {
            return '';
        }
    }

    public function getArrayPayMethods()
    {
        $array_metodos_pago = array();
        $modules_list = Module::getPaymentModules();
        array_push($array_metodos_pago, 'Ninguno');
        foreach ($modules_list as $module) {
            $module_obj = Module::getInstanceById($module['id_module']);
            array_push($array_metodos_pago, $module_obj->displayName);
        }
        return($array_metodos_pago);
    }

    public function updateGeneiShipStatus($datos_array)
    {
        $datos_array['usuario_servicio'] = $this->configurationGet('usuario_servicio_genei');
        $datos_array['password_servicio'] = $this->configurationGet('password_servicio_genei');
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $datos_array['id_usuario'] = $this->getUserId($datos_array);
        $url = 'http://www.genei.es/json_interface/actualizar_estado_envio';
        $salida = $this->curlJson($datos_array, $url);
        return $salida;
    }

    public function convertGeneiStatusToPrestaShop($estado_genei)
    {
        switch ($estado_genei) {
            case 1:
            case 6:
                $estado_prestashop = $this->configurationGet('estado_recogida_tramitada_genei');
                break;
            case 3:
                $estado_prestashop = $this->configurationGet('estado_envio_entregado_genei');
                break;
            case 5:
                $estado_prestashop = $this->configurationGet('estado_envio_transito_genei');
                break;
            case 10:
                $estado_prestashop = $this->configurationGet('estado_envio_incidencia_genei');
                break;
            default:
                $estado_prestashop = 5;
                break;
        }

        return $estado_prestashop;
    }

    private function formatAddress($direccion)
    {
        $direccion_formateada = $direccion['codigo'] . " - " . ucwords(Tools::strtolower($direccion['nombre']))
            . " - " . ucwords(Tools::strtolower($direccion['codigo_postal'])) . ", "
            . ucwords(Tools::strtolower($direccion['poblacion']));
        return $direccion_formateada;
    }

    public function obtainAddressDataId($addressID)
    {
        $addressDataIdBD = Tools::jsonDecode($this->getAddressesDataIdBD($addressID), true);
        if (is_array($addressDataIdBD) && count($addressDataIdBD) > 0
                && strtotime($addressDataIdBD['fecha_hora_insercion']) >= (strtotime(' -1 hour'))) {
            return $addressDataIdBD['data'];
        }
        $datos_array = array();
        $datos_array['usuario_servicio'] = $this->configurationGet('usuario_servicio_genei');
        $datos_array['password_servicio'] = $this->configurationGet('password_servicio_genei');
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $datos_array['id_usuario'] = $this->getUserId($datos_array);
        $datos_array['id_direccion'] = $addressID;
        $url = 'http://www.genei.es/json_interface/obtener_datos_direccion';
        $addressDataJSON = $this->curlJson($datos_array, $url);
        $this->insertAddressesDataIdBD($addressDataJSON, $addressID);
        return $addressDataJSON;
    }

    public function obtainAddressDataCode($address_code)
    {
        $datos_array = array();
        $datos_array['usuario_servicio'] = $this->configurationGet('usuario_servicio_genei');
        $datos_array['password_servicio'] = $this->configurationGet('password_servicio_genei');
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $datos_array['id_usuario'] = $this->getUserId($datos_array);
        $datos_array['codigo_direccion'] = $address_code;
        $url = 'http://www.genei.es/json_interface/obtener_datos_codigo_direccion';
        $salida = $this->curlJson($datos_array, $url);
        return $salida;
    }

    public function getUserId($datos_array)
    {
        $datos_array['usuario_servicio'] = $this->configurationGet('usuario_servicio_genei');
        $datos_array['password_servicio'] = $this->configurationGet('password_servicio_genei');
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $url = 'http://www.genei.es/json_interface/obtener_id_usuario';
        $salida = $this->curlJson($datos_array, $url);
        $salida = Tools::jsonDecode($salida, true);
        return $salida['id_usuario'];
    }

    public function getPickupHours($datos_json_obtener_horas_recogida_genei)
    {
        $datos_array = Tools::jsonDecode($datos_json_obtener_horas_recogida_genei, true);
        $datos_array['usuario_servicio'] = $this->configurationGet('usuario_servicio_genei');
        $datos_array['password_servicio'] = $this->configurationGet('password_servicio_genei');
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $datos_array['id_usuario'] = $this->getUserId($datos_array);
        $url = 'http://www.genei.es/json_interface/obtener_horas_recogida';
        return $this->curlJson($datos_array, $url);
    }

    public function getOriginIdCountry($datos_array)
    {
        $datos_array['usuario_servicio'] = $this->configurationGet('usuario_servicio_genei');
        $datos_array['password_servicio'] = $this->configurationGet('password_servicio_genei');
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $url = 'http://www.genei.es/json_interface/obtener_id_pais_salida';
        $salida = $this->curlJson($datos_array, $url);
        $salida = Tools::jsonDecode($salida, true);
        return $salida['id_pais_salida'];
    }

    public function getIdCountry($datos_array)
    {
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $url = 'http://www.genei.es/json_interface/obtener_id_pais';
        $salida = $this->curlJson($datos_array, $url);
        $salida = Tools::jsonDecode($salida, true);
        return $salida['id_pais'];
    }

    public function getCarrierName($datos_array)
    {
        $datos_array['usuario_servicio'] = $this->configurationGet('usuario_servicio_genei');
        $datos_array['password_servicio'] = $this->configurationGet('password_servicio_genei');
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $url = 'http://www.genei.es/json_interface/obtener_nombre_agencia';
        $salida = $this->curlJson($datos_array, $url);
        $salida = Tools::jsonDecode($salida);
        return $salida;
    }

    public function getCarrierService($datos_array)
    {
        $datos_array['usuario_servicio'] = $this->configurationGet('usuario_servicio_genei');
        $datos_array['password_servicio'] = $this->configurationGet('password_servicio_genei');
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $url = 'http://www.genei.es/json_interface/obtener_servicio_agencia';
        $salida = $this->curlJson($datos_array, $url);
        $salida = Tools::jsonDecode($salida);
        return $salida;
    }

    public function getCarrierImageJpg($datos_array)
    {
        $datos_array['usuario_servicio'] = $this->configurationGet('usuario_servicio_genei');
        $datos_array['password_servicio'] = $this->configurationGet('password_servicio_genei');
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $url = 'http://www.genei.es/json_interface/obtener_imagen_agencia_jpg';
        $salida = $this->curlJson($datos_array, $url);
        $salida = Tools::jsonDecode($salida);
        return $salida;
    }

    public function getDestinationIdCountry($datos_array)
    {
        $datos_array['usuario_servicio'] = $this->configurationGet('usuario_servicio_genei');
        $datos_array['password_servicio'] = $this->configurationGet('password_servicio_genei');
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $url = 'http://www.genei.es/json_interface/obtener_id_pais_llegada';
        $salida = $this->curlJson($datos_array, $url);
        $salida = Tools::jsonDecode($salida, true);
        return $salida['id_pais_llegada'];
    }

    public function noIvaZone($datos_array)
    {
        $datos_array['usuario_servicio'] = $this->configurationGet('usuario_servicio_genei');
        $datos_array['password_servicio'] = $this->configurationGet('password_servicio_genei');
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $url = 'http://www.genei.es/json_interface/zona_iva_exenta';
        $salida = $this->curlJson($datos_array, $url);
        $salida = Tools::jsonDecode($salida, true);
        return $salida['zona_iva_exenta'];
    }

    public function noIvaCart($id_cart)
    {
        $objeto_cart = new Cart($id_cart);
        $delivery_address_object = new Address($objeto_cart->id_address_delivery);
        $delivery_country_object = new Country($delivery_address_object->id_country);
        $zona_iva_exenta_llegada = $this->noIvaZone(
            array(
                'iso_pais' => $delivery_country_object->iso_code,
                'codpos' => $delivery_address_object->postcode
            )
        );
        if ($zona_iva_exenta_llegada != 0) {
            return 1;
        } else {
            return 0;
        }
    }

    public function getLabel($datos_array)
    {
        $datos_array['usuario_servicio'] = $this->configurationGet('usuario_servicio_genei');
        $datos_array['password_servicio'] = $this->configurationGet('password_servicio_genei');
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $url = 'http://www.genei.es/json_interface/obtener_etiquetas_envio';
        $salida = $this->curlJson($datos_array, $url);
        $salida = Tools::jsonDecode($salida, true);
        return true;
    }

    public function prepareGeneiAddressList()
    {
        $array_direcciones = Tools::jsonDecode($this->getAddressesList(0), true);
        if ($array_direcciones != null) {
            $array_direcciones_formateado = array();
            if ($this->configurationGet('direccion_predeterminada_genei') == '') {
                array_push($array_direcciones_formateado, ' ');
            }
            foreach ($array_direcciones as $direccion) {
                if (is_array($direccion)) {
                    $array_direcciones_formateado[$direccion['codigo']] = $this->formatAddress($direccion);
                }
            }
            return $array_direcciones_formateado;
        }
    }
    
    public function prepareGeneiAddressListValues()
    {
        $array_direcciones = Tools::jsonDecode($this->getAddressesList(0), true);
        if ($array_direcciones != null) {
            $array_direcciones_formateado = array();
            if ($this->configurationGet('direccion_predeterminada_genei') == '') {
                array_push($array_direcciones_formateado, ' ');
            }
            foreach ($array_direcciones as $direccion) {
                if (is_array($direccion)) {
                     $array_direcciones_formateado[$direccion['codigo']] = $direccion['almacen_genei'];
                }
            }
            return $array_direcciones_formateado;
        }
    }

    public function getMerchandiseListCodes()
    {
        $datos_array = array();
        $datos_array['usuario_servicio'] = $this->configurationGet('usuario_servicio_genei');
        $datos_array['password_servicio'] = $this->configurationGet('password_servicio_genei');
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $url = 'http://www.genei.es/json_interface/obtener_lista_codigos_mercancia_correos';
        $datos_array['id_usuario'] = $this->getUserId($datos_array);
        return $this->curlJson($datos_array, $url);
    }

    public function prepareMerchandiseListCodes()
    {
        $array_codigos_mercancia = Tools::jsonDecode($this->getMerchandiseListCodes(), true);
        if ($array_codigos_mercancia != null) {
            $array_codigos_mercancia_formateado = array();
            foreach ($array_codigos_mercancia as $campo_mercancia) {
                $array_codigos_mercancia_formateado[$campo_mercancia['codigo_mercancia']] =
                    $campo_mercancia['codigo_mercancia'] . ' - ' . $campo_mercancia['mercancia'];
            }
            return $array_codigos_mercancia_formateado;
        }
    }

    public function obtainFirstMerchandiseListCode($array_codigos_mercancia_formateado)
    {
        if (is_array($array_codigos_mercancia_formateado)) {
            if (array_key_exists('0', $array_codigos_mercancia_formateado)) {
                if (is_array($array_codigos_mercancia_formateado[0])) {
                    return array_keys($array_codigos_mercancia_formateado[0]);
                }
            }
        }
    }

    public function geneiSignUp($datos_json_registro_genei)
    {
        $datos_array = Tools::JsonDecode($datos_json_registro_genei, true);
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $url = 'http://www.genei.es/json_interface/registro_nuevo_usuario';
        $salida = $this->curlJson($datos_array, $url);
        return $salida;
    }

    public function getGeneiCountryList($datos_json_lista_paises_genei)
    {
        $lista_paises_configuracion = $this->configurationGet('lista_paises');
        if (count(Tools::jsonDecode($lista_paises_configuracion, true)) > 0) {
            return $lista_paises_configuracion;
        }
        $datos_array = $datos_json_lista_paises_genei;
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $url = 'http://www.genei.es/json_interface/obtener_lista_paises';
        $salida = $this->curlJson($datos_array, $url);
        $this->configurationUpdateValue('lista_paises', $salida);
        return $salida;
    }

    public function getGeneiProvincesList($datos_json_lista_provincias_genei)
    {
        $datos_array = Tools::JsonDecode($datos_json_lista_provincias_genei, true);
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $url = 'http://www.genei.es/json_interface/obtener_lista_provincias';
        $salida = $this->curlJson($datos_array, $url);
        return $salida;
    }

    public function showTermsGenei($datos_json_terminos_condiciones_genei)
    {
        $datos_array = Tools::JsonDecode($datos_json_terminos_condiciones_genei, true);
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $url = 'http://www.genei.es/json_interface/mostrar_terminos_condiciones_genei';
        $salida = $this->curlJson($datos_array, $url);
        return $salida;
    }

    public function getLastVersion()
    {
        $datos_array = array();
        $datos_array['usuario_servicio'] = $this->configurationGet('usuario_servicio_genei');
        $datos_array['password_servicio'] = $this->configurationGet('password_servicio_genei');
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $url = 'http://www.genei.es/json_interface/obtener_ultima_version_servicios_externos';
        $salida = $this->curlJson($datos_array, $url);
        $salida = Tools::jsonDecode($salida, true);
        return $salida;
    }

    public function getBalance()
    {
        $datos_array = array();
        $datos_array['usuario_servicio'] = $this->configurationGet('usuario_servicio_genei');
        $datos_array['password_servicio'] = $this->configurationGet('password_servicio_genei');
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $datos_array['id_usuario'] = $this->getUserId($datos_array);
        $url = 'http://www.genei.es/json_interface/obtener_saldo';
        $salida = $this->curlJson($datos_array, $url);
        $salida = Tools::jsonDecode($salida, true);
        $salida['saldo'] = number_format($salida['saldo'], 2);
        return $salida;
    }

    public function userCredit()
    {
        $datos_array = array();
        $datos_array['usuario_servicio'] = $this->configurationGet('usuario_servicio_genei');
        $datos_array['password_servicio'] = $this->configurationGet('password_servicio_genei');
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $datos_array['id_usuario'] = $this->getUserId($datos_array);
        $url = 'http://www.genei.es/json_interface/usuario_a_credito';
        $salida = $this->curlJson($datos_array, $url);
        $salida = Tools::jsonDecode($salida, true);
        return $salida;
    }

    public function hookActionCarrierUpdate($params)
    {
        $id_carrier_old = (int) ($params['id_carrier']);
        $id_carrier_new = (int) ($params['carrier']->id);
        Db::getInstance()->execute(
            'UPDATE `' . _DB_PREFIX_ .
            'genei_carriers` SET id_carrier = ' . (int) $id_carrier_new . ' WHERE id_carrier = ' . (int) $id_carrier_old
        );
    }

    public function hookactionCarrierProcess($params)
    {
        $id_cart = (int) ($params['cart']->id);
        $id_delivery_point = (int) Tools::getValue('id_delivery_point');
        if ($id_cart > 0 && $id_delivery_point > 0) {
            if ($this->existsGeneiDeliveryPoint($id_cart)) {
                $this->updateGeneiDeliveryPoint($id_cart, $id_delivery_point);
            } else {
                $this->insertGeneiDeliveryPoint($id_cart, $id_delivery_point);
            }
        }
    }

    public function hookDisplayAfterCarrier($params)
    {
        $array_id_genei_mondial_relay = array(5040, 5041);
        $array_id_carrier_mondial_relay = array();
        foreach ($array_id_genei_mondial_relay as $id_genei_mondial_relay) {
            if ($this->existsGeneiCarrier($id_genei_mondial_relay)) {
                $array_id_carrier_mondial_relay[] = $this->obtainIdCarrier($id_genei_mondial_relay);
            }
        }

        $array_id_genei_ups_access_point = array(88, 5108);
        $array_id_carrier_ups_access_point = array();
        foreach ($array_id_genei_ups_access_point as $id_genei_ups_access_point) {
            if ($this->existsGeneiCarrier($id_genei_ups_access_point)) {
                $array_id_carrier_ups_access_point[] = $this->obtainIdCarrier($id_genei_ups_access_point);
            }
        }

        $array_id_genei_correos_oficina = array(65, 73);
        $array_id_carrier_correos_oficina = array();
        foreach ($array_id_genei_correos_oficina as $id_genei_correos_oficina) {
            if ($this->existsGeneiCarrier($id_genei_correos_oficina)) {
                $array_id_carrier_correos_oficina[] = $this->obtainIdCarrier($id_genei_correos_oficina);
            }
        }
        $array_id_genei_correos_express_oficina = array(2, 17);
        $array_id_carrier_correos_express_oficina = array();
        foreach ($array_id_genei_correos_express_oficina as $id_genei_correos_express_oficina) {
            if ($this->existsGeneiCarrier($id_genei_correos_express_oficina)) {
                $array_id_carrier_correos_express_oficina[] = $this->obtainIdCarrier($id_genei_correos_express_oficina);
            }
        }
        $googleApiKey = $this->configurationGet('google_api_key');
        if (!$googleApiKey) {
            $googleApiKey = 'AIzaSyADAyFRN_Cm6LhFWFx5krHM-HY_aL775tw';
        }
        if ($this->existsGeneiDeliveryPoint($params['cart']->id)) {
            $id_delivery_point = $this->getDeliveryPoint($params['cart']->id);
        } else {
            $id_delivery_point = 0;
        }
        $lista_access_points_ups = array();
        if (!empty($array_id_carrier_ups_access_point)) {
            $delivery_address_object = new Address($params['cart']->id_address_delivery);
            $delivery_country_object = new Country($delivery_address_object->id_country);
            $datos_array = array(
                'codigo_postal' => $delivery_address_object->postcode,
                'iso_pais' => $delivery_country_object->iso_code
            );
            $lista_access_points_ups = Tools::jsonDecode($this->getUpsAccessPointData($datos_array));
        }
        $lista_oficinas_destino = array();
        if (!empty($array_id_carrier_correos_oficina)) {
            $delivery_address_object = new Address($params['cart']->id_address_delivery);
            $delivery_country_object = new Country($delivery_address_object->id_country);
            $datos_array = array(
                'codigo_postal_oficina' => $delivery_address_object->postcode,
            );
            $lista_oficinas_destino = Tools::jsonDecode($this->getListaOficinasDestino($datos_array));
        }

        $lista_oficinas_destino_express = array();
        if (!empty($array_id_carrier_correos_express_oficina)) {
            $delivery_address_object = new Address($params['cart']->id_address_delivery);
            $delivery_country_object = new Country($delivery_address_object->id_country);
            $datos_array = array(
                'codigo_postal_oficina' => $delivery_address_object->postcode,
            );
            $lista_oficinas_destino_express =
                Tools::jsonDecode($this->getListaOficinasDestino($datos_array));
        }
        $this->context->smarty->assign('googleApiKey', $googleApiKey);
        $this->context->smarty->assign('id_delivery_point', $id_delivery_point);
        $this->context->smarty->assign('array_id_carrier_mondial_relay', $array_id_carrier_mondial_relay);
        $this->context->smarty->assign('array_id_carrier_ups_access_point', $array_id_carrier_ups_access_point);
        $this->context->smarty->assign('lista_access_points_ups', $lista_access_points_ups);
        $this->context->smarty->assign('array_id_carrier_correos_oficina', $array_id_carrier_correos_oficina);
        $this->context->smarty->assign('lista_oficinas_destino_correos', $lista_oficinas_destino);
        $this->context->smarty->assign(
            'array_id_carrier_correos_express_oficina',
            $array_id_carrier_correos_express_oficina
        );
        $this->context->smarty->assign(
            'lista_oficinas_destino_correos_express',
            $lista_oficinas_destino_express
        );
        if (!defined('_PS_BASE_URL_SSL_')) {
            $this->context->smarty->assign(
                'pathfrontoficinadestino',
                _PS_BASE_URL_ . _MODULE_DIR_ . $this->name . '/views/js/front_oficina_destino.js'
            );
        } else {
            $this->context->smarty->assign(
                'pathfrontoficinadestino',
                _PS_BASE_URL_SSL_ . _MODULE_DIR_ . $this->name . '/views/js/front_oficina_destino.js'
            );
        }
        if (!empty($array_id_carrier_mondial_relay)
            || !empty($array_id_carrier_ups_access_point)
            || !empty($array_id_carrier_correos_oficina)
            || !empty($array_id_carrier_correos_express_oficina)) {
            return $this->display(__FILE__, 'DisplayAfterCarrier.tpl');
        }
    }

    public function hookDisplayAdminOrder($params)
    {
        $array_direccion_seleccionada_completa = Tools::jsonDecode(
            $this->obtainAddressDataCode($this->configurationGet('direccion_predeterminada_genei'))
        );
        if ($this->configurationGet('estado_autenticacion_genei') != 1
            || !is_object($array_direccion_seleccionada_completa)) {
            return;
        }
        $array_version = $this->getLastVersion();
        $this->context->smarty->assign('ultima_version_disponible_genei', $array_version['ultima_version_txt']);
        if ($this->cn < $array_version['ultima_version_cn']) {
            $this->context->smarty->assign('nueva_version_disponible_genei', 1);
        } else {
            $this->context->smarty->assign('nueva_version_disponible_genei', 0);
        }
        $datos_array = array();
        $datos_array['usuario_servicio'] = $this->configurationGet('usuario_servicio_genei');
        $datos_array['password_servicio'] = $this->configurationGet('password_servicio_genei');
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $datos_array['id_usuario'] = $this->getUserId($datos_array);
        
        $this->context->smarty->assign('id_usuario', $datos_array['id_usuario']);
        $this->smarty->assign(array(
            'id_order' => $params['id_order']));
        $this->context->smarty->assign('geneiajaxcontrollerlink', $this->context->link->getAdminLink('Genei'));

        $order = new Order($params['id_order']);
        $codigo_envio_externo = $order->reference;
        $delivery_address_object = new Address($order->id_address_delivery);
        $this->context->smarty->assign(
            'direccion_destino_genei',
            $delivery_address_object->firstname . ' ' .
            $delivery_address_object->lastname . ' - ' .
            $delivery_address_object->address1 . ' ' .
            $delivery_address_object->address2 . ' ' .
            $delivery_address_object->postcode . ' ' .
            $delivery_address_object->city
        );
        $this->context->smarty->assign(
            'direcciones_almacen_genei',
            $this->prepareGeneiAddressListValues()
        );
        $this->context->smarty->assign(
            'codigo_postal_destino_genei',
            $delivery_address_object->postcode
        );
        $this->context->smarty->assign(
            'observaciones_recogida_defecto_genei',
            $this->configurationGet('observaciones_recogida_defecto_genei')
        );
        $this->context->smarty->assign(
            'observaciones_entrega_defecto_genei',
            $this->configurationGet('observaciones_entrega_defecto_genei')
        );
        $this->context->smarty->assign(
            'direccion_predeterminada_genei',
            $this->configurationGet('direccion_predeterminada_genei')
        );
        $this->context->smarty->assign(
            'codigos_mercancia_genei',
            $this->prepareMerchandiseListCodes()
        );
        $this->context->smarty->assign(
            'codigo_mercancia_genei',
            $this->obtainFirstMerchandiseListCode($this->prepareMerchandiseListCodes())
        );
        $this->context->smarty->assign('direccion_predeterminada_dropshipping_genei', "");
        $this->context->smarty->assign(
            'agencia_predeterminada_genei',
            $this->configurationGet('agencia_predeterminada_genei')
        );
        $this->context->smarty->assign(
            'agencias_genei',
            Tools::jsonDecode(
                $this->configurationGet('agencias_genei'),
                true
            )
        );
        $this->context->smarty->assign(
            'atributos_defecto_genei_default',
            $this->configurationGet('atributos_defecto_genei_default')
        );
        if (defined('_PS_BASE_URL_SSL_')) {
            $googleApiKey = $this->configurationGet('google_api_key');
            if (!$googleApiKey) {
                $googleApiKey = 'AIzaSyADAyFRN_Cm6LhFWFx5krHM-HY_aL775tw';
            }
            $this->context->controller->
                addJS('https://maps.googleapis.com/maps/api/js?key=' . $googleApiKey);
        }
        $this->context->smarty->assign(
            'estado_autenticacion_genei',
            $this->configurationGet('estado_autenticacion_genei')
        );
        if (!defined('_PS_BASE_URL_SSL_')) {
            $this->context->smarty->assign('url_logo', _PS_BASE_URL_ . _MODULE_DIR_ . '/genei/logo.png');
            $this->context->smarty->assign(
                'path_envio_pasos_prestashop',
                _PS_BASE_URL_ . _MODULE_DIR_ . $this->name . '/views/js/drag_drop_warehouse/envio_pasos_prestashop.js'
            );
            $this->context->smarty->assign(
                'module_dir_url',
                _PS_BASE_URL_ . _MODULE_DIR_ . $this->name
            );
        } else {
            $this->context->smarty->assign('url_logo', _PS_BASE_URL_SSL_ . _MODULE_DIR_ . '/genei/logo.png');
            $this->context->smarty->assign(
                'path_envio_pasos_prestashop',
                _PS_BASE_URL_SSL_ . _MODULE_DIR_ . $this->name .
                '/views/js/drag_drop_warehouse/envio_pasos_prestashop.js'
            );
            $this->context->smarty->assign(
                'module_dir_url',
                _PS_BASE_URL_SSL_ . _MODULE_DIR_ . $this->name
            );
        }
        
        if ($this->configurationGet('estado_autenticacion_genei') == 1
                && is_object($array_direccion_seleccionada_completa)) {
            $array_codigo_envio_genei = Tools::jsonDecode(
                $this->getShipCodeExternalService($codigo_envio_externo),
                true
            );
            $this->context->smarty->assign(
                'envio_creado_codigo_envio',
                $array_codigo_envio_genei['codigo_envio']
            );
            if ($array_codigo_envio_genei['codigo_envio'] == '#') {
                $this->context->smarty->assign(
                    'direcciones_genei',
                    $this->prepareGeneiAddressList()
                );
                $this->context->smarty->assign('reembolso_pag_pedido_genei', 0);
                $this->context->smarty->assign('cantidad_reembolso_pag_pedido_genei', 0);
                $delivery_address_object = new Address($order->id_address_delivery);
                $invoice_address_object = new Address($order->id_address_invoice);
                if ($delivery_address_object->phone == '' && $delivery_address_object->phone_mobile == '') {
                    $this->context->smarty->assign('telefono_llegada_vacio_genei', '1');
                } else {
                    $this->context->smarty->assign('telefono_llegada_vacio_genei', '0');
                }
                $delivery_country_object = new Country($delivery_address_object->id_country);
                $zona_iva_exenta_salida = $this->noIvaZone(
                    array(
                        'iso_pais' => $array_direccion_seleccionada_completa->country_code,
                        'codpos' => $array_direccion_seleccionada_completa->codigo_postal
                    )
                );
                $zona_iva_exenta_llegada = $this->noIvaZone(
                    array(
                        'iso_pais' => $delivery_country_object->iso_code,
                        'codpos' => $delivery_address_object->postcode
                    )
                );
                if ($zona_iva_exenta_salida != 0 || $zona_iva_exenta_llegada != 0) {
                    $this->context->smarty->assign('zona_iva_exenta', 1);
                } else {
                    $this->context->smarty->assign('zona_iva_exenta', 0);
                }
                $array_pesos = array();
                $array_largos = array();
                $array_anchos = array();
                $array_altos = array();
                $array_valores = array();
                $array_contenidos = array();
                $array_dni_contenidos = array();
                $order_details = $order->getOrderDetailList();
                if ($this->configurationGet('atributos_defecto_genei_default') == 1) {
                    for ($i = 1; $i <= $this->configurationGet('num_bultos_defecto_genei'); $i++) {
                        $array_pesos[$i] = $this->configurationGet('peso_defecto_genei');
                        $array_largos[$i] = $this->configurationGet('largo_defecto_genei');
                        $array_anchos[$i] = $this->configurationGet('ancho_defecto_genei');
                        $array_altos[$i] = $this->configurationGet('alto_defecto_genei');
                        $array_contenidos[$i] = '';
                        $array_valores[$i] = '0';
                        if ($invoice_address_object->vat_number != '') {
                            $array_dni_contenidos[$i] = $invoice_address_object->vat_number;
                        } else {
                            $array_dni_contenidos[$i] = $invoice_address_object->dni;
                        }
                    }
                } else {
                    $contador_productos = 0;
                    foreach ($order_details as $order_detail) {
                        $contador_productos++;
                        $product = new Product($order_detail['product_id']);
                        $array_pesos[$contador_productos] = $order_detail['product_weight'];
                        if ($array_pesos[$contador_productos] < 0.1) {
                            $array_pesos[$contador_productos] = 0.1;
                        }
                        $array_largos[$contador_productos] = $product->depth;
                        if ($array_largos[$contador_productos] < 1) {
                            $array_largos[$contador_productos] = 1;
                        }
                        $array_anchos[$contador_productos] = $product->width;
                        if ($array_anchos[$contador_productos] < 1) {
                            $array_anchos[$contador_productos] = 1;
                        }
                        $array_altos[$contador_productos] = $product->height;
                        if ($array_altos[$contador_productos] < 1) {
                            $array_altos[$contador_productos] = 1;
                        }
                        $array_contenidos[$contador_productos] = $product->name[$this->context->language->id];
                        $array_valores[$contador_productos] = round($product->price, 2);
                        if ($invoice_address_object->vat_number != '') {
                            $array_dni_contenidos[$contador_productos] = $invoice_address_object->vat_number;
                        } else {
                            $array_dni_contenidos[$contador_productos] = $invoice_address_object->dni;
                        }
                        if ($order_detail['product_quantity'] > 1) {
                            $array_pesos[$contador_productos]=
                                $array_pesos[$contador_productos] * $order_detail['product_quantity'];
                            $array_largos[$contador_productos] =
                                $array_largos[$contador_productos] * pow($order_detail['product_quantity'], 1 / 3);
                            $array_anchos[$contador_productos] =
                                $array_anchos[$contador_productos] * pow($order_detail['product_quantity'], 1 / 3);
                            $array_altos[$contador_productos] =
                                $array_altos[$contador_productos] * pow($order_detail['product_quantity'], 1 / 3);
                        }
                    }
                }
                $array_mercancias_correos = Tools::jsonDecode($this->getCorreosGoodsList(), true);
                if ($array_mercancias_correos == null) {
                    $array_mercancias_correos = array();
                }
                $this->context->smarty->assign('array_mercancias_correos', $array_mercancias_correos);
                $this->context->smarty->assign('array_pesos', $array_pesos);
                $this->context->smarty->assign('array_largos', $array_largos);
                $this->context->smarty->assign('array_anchos', $array_anchos);
                $this->context->smarty->assign('array_altos', $array_altos);
                $this->context->smarty->assign('array_contenidos', $array_contenidos);
                $this->context->smarty->assign('array_dni_contenidos', $array_dni_contenidos);
                $this->context->smarty->assign('array_valores', $array_valores);
                $array_boxes = $this->getArrayBoxes($order->id_cart);
                $this->context->smarty->assign('array_boxes', $array_boxes);
                $this->context->smarty->assign(
                    'array_boxes_count',
                    count($array_boxes)
                );
            } else {
                $array_envio_creado = Tools::jsonDecode(
                    $this->shipAlreadyCreated(array('codigo_envio_servicio' => $codigo_envio_externo)),
                    true
                );
                if ($this->configurationGet('estados_automaticos_pedidos_genei') == 1) {
                    Tools::jsonDecode(
                        $this->setOrderState(
                            $params['id_order'],
                            $array_envio_creado['estado']
                        ),
                        true
                    );
                }
                $array_mercancias_correos = Tools::jsonDecode($this->getCorreosGoodsList(), true);
                if ($array_mercancias_correos == null) {
                    $array_mercancias_correos = array();
                }
                $this->context->smarty->assign('array_mercancias_correos', $array_mercancias_correos);
                $this->context->smarty->assign(
                    'envio_creado_fecha_hora_creacion',
                    $array_envio_creado['fecha_hora_creacion']
                );
                $this->context->smarty->assign(
                    'envio_creado_estado',
                    $array_envio_creado['estado']
                );
                $this->context->smarty->assign(
                    'envio_creado_nombre_estado',
                    $array_envio_creado['nombre_estado']
                );
                $this->context->smarty->assign(
                    'envio_creado_seguimiento',
                    $array_envio_creado['seguimiento']
                );
                Tools::jsonDecode(
                    $this->setOrderTrackCode(
                        $params['id_order'],
                        $array_envio_creado['seguimiento']
                    ),
                    true
                );
                $this->context->smarty->assign(
                    'envio_creado_web_seguimiento',
                    $array_envio_creado['web_seguimiento']
                );
                $this->context->smarty->assign(
                    'envio_creado_nombre_agencia',
                    $array_envio_creado['nombre_agencia']
                );
                $this->context->smarty->assign(
                    'envio_creado_url_etiquetas',
                    'http://www.genei.es/obtener_etiqueta_envio/obtener_etiqueta_envio_servicio_externo/'
                    . $array_envio_creado['codigo_envio']
                    . '/' . $this->configurationGet('usuario_servicio_genei')
                    . '/' . $this->configurationGet('password_servicio_genei')
                    . '/prestashop'
                );
                $this->context->smarty->assign(
                    'envio_creado_url_etiquetas_zebra',
                    'http://www.genei.es/obtener_etiqueta_envio/obtener_etiqueta_envio_servicio_externo/'
                    . $array_envio_creado['codigo_envio']
                    . '/' . $this->configurationGet('usuario_servicio_genei')
                    . '/' . $this->configurationGet('password_servicio_genei')
                    . '/prestashop/1/1'
                );
                $this->context->smarty->assign(
                    'envio_creado_url_proforma',
                    $this->getProformaUrl($array_envio_creado['codigo_envio'])
                );
            }
        } else {
            $this->context->smarty->assign('envio_creado_codigo_envio', null);
            $this->context->smarty->assign('array_mercancias_correos', null);
        }
        if (!defined('_PS_BASE_URL_SSL_')) {
            $this->context->
            controller->addCSS(_PS_BASE_URL_ . _MODULE_DIR_ . 'genei/views/css/switch.css', 'all');
            $this->context->
            controller->addCSS(_PS_BASE_URL_ . _MODULE_DIR_ . 'genei/views/css/lista_precios.css', 'all');
            $this->context->
            controller->addCSS(_PS_BASE_URL_ . _MODULE_DIR_ .
            'genei/views/css/drag_drop_warehouse/envio_pasos.css', 'all');
        } else {
            $this->context->
            controller->addCSS(_PS_BASE_URL_SSL_ . _MODULE_DIR_ . 'genei/views/css/switch.css', 'all');
            $this->context->
            controller->addCSS(_PS_BASE_URL_SSL_ . _MODULE_DIR_ . 'genei/views/css/lista_precios.css', 'all');
            $this->context->
            controller->addCSS(_PS_BASE_URL_SSL_ . _MODULE_DIR_ .
            'genei/views/css/drag_drop_warehouse/envio_pasos.css', 'all');
        }
        $this->context->controller->addJqueryUI('ui.draggable');
        $this->context->controller->addJqueryUI('ui.droppable');
        return $this->display(__FILE__, $this->name . '.tpl');
    }

    public function displayForm()
    {
        $datos_array = array(
            'usuario_servicio' => $this->configurationGet('usuario_servicio_genei'),
            'password_servicio' => $this->configurationGet('password_servicio_genei'),
            'servicio' => self::SERVICIO
        );
        $this->configurationUpdateValue(
            'agencias_genei_utilizadas',
            $this->getInstalledCarriersList($datos_array)
        );
        $this->configurationUpdateValue(
            'agencias_genei_no_utilizadas',
            $this->getNotInstalledCarriersList($datos_array)
        );
        $this->configurationUpdateValue(
            'agencias_genei_utilizadasVisibles',
            $this->getInstalledCarriersListVisibles($datos_array)
        );
        $this->configurationUpdateValue(
            'agencias_genei_no_utilizadasVisibles',
            $this->getNotInstalledCarriersListVisibles($datos_array)
        );
        if (!defined('_PS_BASE_URL_SSL_')) {
            $this->context->
            controller->addCSS(_PS_BASE_URL_ . _MODULE_DIR_ . 'genei/views/css/genei.css', 'all');
        } else {
            $this->context->controller->
                addCSS(_PS_BASE_URL_SSL_ . _MODULE_DIR_ . 'genei/views/css/genei.css', 'all');
        }
        $this->context->smarty->assign('request_uri', Tools::safeOutput($_SERVER['REQUEST_URI']));
        $this->context->smarty->assign('path', $this->_path);
        $this->context->smarty->
            assign('usuario_servicio_genei', $this->configurationGet('usuario_servicio_genei'));
        $this->context->smarty->
            assign('password_servicio_genei', $this->configurationGet('password_servicio_genei'));
        $this->context->smarty->assign('direcciones_genei', $this->prepareGeneiAddressList());
        $this->context->smarty->assign('variation_price_amount_genei', $this->getAllCarriersVariationPriceAmount());
        $this->context->smarty->assign('variation_amount_free_genei', $this->getAllCarriersVariationAmountFree());
        $this->context->smarty->assign('variation_type_genei', $this->getAllCarriersVariationPriceType());
        $country_list_genei = array();
        foreach (Tools::jsonDecode($this->getGeneiCountryList($datos_array), true) as $pais) {
            $country_list_genei[$pais['id_pais']] = $pais['nombre_pais'];
        }
        $datos_array['iso_pais'] = Tools::strtoupper(Configuration::get('PS_LOCALE_COUNTRY'));
        $id_pais_selectionado = $this->getIdCountry($datos_array);
        $this->context->smarty->assign('country_list_genei', $country_list_genei);
        $this->context->smarty->assign('id_pais_selectionado', $id_pais_selectionado);
        $this->context->smarty->assign(
            'performancelink_genei',
            $this->context->link->getAdminLink('AdminPerformance')
        );
        $this->context->smarty->assign(
            'direccion_predeterminada_genei',
            $this->configurationGet('direccion_predeterminada_genei')
        );
        $this->context->smarty->assign(
            'google_api_key',
            $this->configurationGet('google_api_key')
        );
        $this->context->smarty->assign(
            'agencias_genei_utilizadas',
            Tools::jsonDecode($this->configurationGet('agencias_genei_utilizadasVisibles'), true)
        );
        $this->context->smarty->assign(
            'agencias_genei_no_utilizadas',
            Tools::jsonDecode($this->configurationGet('agencias_genei_no_utilizadasVisibles'), true)
        );
        $this->context->smarty->assign(
            'estado_autenticacion_genei',
            $this->configurationGet('estado_autenticacion_genei')
        );
        $this->context->smarty->assign(
            'observaciones_recogida_defecto_genei',
            $this->configurationGet('observaciones_recogida_defecto_genei')
        );
        $this->context->smarty->assign(
            'observaciones_entrega_defecto_genei',
            $this->configurationGet('observaciones_entrega_defecto_genei')
        );
        $this->context->smarty->assign(
            'metodo_pago_contrareembolso_defecto_genei',
            $this->getArrayPayMethods()
        );
        if ($this->configurationGet('metodo_pago_contrareembolso_defecto_genei_default') == null) {
            $this->configurationUpdateValue('metodo_pago_contrareembolso_defecto_genei_default', 3);
        }
        $this->context->smarty->assign(
            'metodo_pago_contrareembolso_defecto_genei_default',
            $this->configurationGet('metodo_pago_contrareembolso_defecto_genei_default')
        );
        $this->context->smarty->assign(
            'atributos_defecto_genei',
            array(0 => 'PrestaShop', 1 => 'Manual')
        );
        $this->context->smarty->assign(
            'atributos_defecto_genei_default',
            $this->configurationGet('atributos_defecto_genei_default')
        );
        $this->context->smarty->assign(
            'estado_recogida_tramitada_genei',
            $this->getStatusesList()
        );
        $this->context->smarty->assign(
            'estado_recogida_tramitada_genei_default',
            $this->configurationGet('estado_recogida_tramitada_genei')
        );
        $this->context->smarty->assign(
            'estado_envio_transito_genei',
            $this->getStatusesList()
        );
        $this->context->smarty->assign(
            'estado_envio_transito_genei_default',
            $this->configurationGet('estado_envio_transito_genei')
        );
        $this->context->smarty->assign(
            'estado_envio_incidencia_genei',
            $this->getStatusesList()
        );
        $this->context->smarty->assign(
            'estado_envio_incidencia_genei_default',
            $this->configurationGet('estado_envio_incidencia_genei')
        );
        $this->context->smarty->assign(
            'estado_envio_entregado_genei',
            $this->getStatusesList()
        );
        $this->context->smarty->assign(
            'estado_envio_entregado_genei_default',
            $this->configurationGet('estado_envio_entregado_genei')
        );
        $this->context->smarty->assign(
            'estados_automaticos_pedidos_genei',
            $this->configurationGet('estados_automaticos_pedidos_genei')
        );
        $array_version = $this->getLastVersion();
        $this->context->smarty->assign('ultima_version_disponible_genei', $array_version['ultima_version_txt']);
        if ($this->cn < $array_version['ultima_version_cn']) {
            $this->context->smarty->assign('nueva_version_disponible_genei', 1);
        } else {
            $this->context->smarty->assign('nueva_version_disponible_genei', 0);
        }
        $array_saldo = $this->getBalance();
        $this->context->smarty->assign('saldo_credito_disponible_genei', $array_saldo['saldo']);
        $array_usuario_a_credito = $this->userCredit();
        $this->context->smarty->assign('usuario_a_credito_genei', $array_usuario_a_credito['usuario_a_credito']);
        if ($this->configurationGet('peso_defecto_genei') == '') {
            $this->context->smarty->assign('peso_defecto_genei', 1);
        } else {
            $this->context->smarty->assign('peso_defecto_genei', $this->configurationGet('peso_defecto_genei'));
        }
        if ($this->configurationGet('largo_defecto_genei') == '') {
            $this->context->smarty->assign('largo_defecto_genei', 1);
        } else {
            $this->context->smarty->assign('largo_defecto_genei', $this->configurationGet('largo_defecto_genei'));
        }
        if ($this->configurationGet('ancho_defecto_genei') == '') {
            $this->context->smarty->assign('ancho_defecto_genei', 1);
        } else {
            $this->context->smarty->assign('ancho_defecto_genei', $this->configurationGet('ancho_defecto_genei'));
        }
        if ($this->configurationGet('alto_defecto_genei') == '') {
            $this->context->smarty->assign('alto_defecto_genei', 1);
        } else {
            $this->context->smarty->assign('alto_defecto_genei', $this->configurationGet('alto_defecto_genei'));
        }
        if ($this->configurationGet('num_bultos_defecto_genei') == '') {
            $this->context->smarty->assign('num_bultos_defecto_genei', 1);
        } else {
            $this->context->smarty->
                assign('num_bultos_defecto_genei', $this->configurationGet('num_bultos_defecto_genei'));
        }
        $this->context->smarty->assign('submitName', 'submit' . Tools::ucfirst($this->name));
        $this->context->smarty->assign('PS_SHOP_EMAIL', Configuration::get('PS_SHOP_EMAIL'));
        $this->context->smarty->assign('PS_SHOP_NAME', Configuration::get('PS_SHOP_NAME'));
        $this->context->smarty->assign('PS_SHOP_ADDR1', Configuration::get('PS_SHOP_ADDR1'));
        $this->context->smarty->assign('PS_SHOP_ADDR2', Configuration::get('PS_SHOP_ADDR2'));
        $this->context->smarty->assign('PS_SHOP_CODE', Configuration::get('PS_SHOP_CODE'));
        $this->context->smarty->assign('PS_SHOP_DETAILS', Configuration::get('PS_SHOP_DETAILS'));
        $this->context->smarty->assign('PS_SHOP_CITY', Configuration::get('PS_SHOP_CITY'));
        $this->context->smarty->assign('PS_SHOP_COUNTRY_ID', Configuration::get('PS_SHOP_COUNTRY_ID'));
        $this->context->smarty->assign('PS_SHOP_STATE_ID', Configuration::get('PS_SHOP_STATE_ID'));
        $this->context->smarty->assign('PS_SHOP_PHONE', Configuration::get('PS_SHOP_PHONE'));
        $this->context->smarty->assign('PS_DISABLE_OVERRIDES', Configuration::get('PS_DISABLE_OVERRIDES'));
        if (!file_exists(_PS_ROOT_DIR_ . '/override/classes/Cart.php')) {
            Tools::copy(
                _PS_MODULE_DIR_ . '/genei/override/classes/Cart.php',
                _PS_ROOT_DIR_ . '/override/classes/Cart.php'
            );
        }
        if (!file_exists(_PS_ROOT_DIR_ . '/override/controllers/admin/AdminCarriersController.php')) {
            Tools::copy(
                _PS_MODULE_DIR_ . '/genei/override/controllers/admin/AdminCarriersController.php',
                _PS_ROOT_DIR_ . '/override/controllers/admin/AdminCarriersController.php'
            );
        }
        if (!file_exists(_PS_ROOT_DIR_ . '/override/classes/Cart.php')) {
            $this->context->smarty->assign('override_error_genei', 1);
        } else {
            $this->context->smarty->assign('override_error_genei', 0);
        }
        if ($this->configurationGet('PS_SSL_ENABLED') == 1) {
            $this->context->smarty->assign('base_url_genei', 'https://' . Configuration::get('PS_SHOP_DOMAIN_SSL'));
        } else {
            $this->context->smarty->assign('base_url_genei', 'http://' . Configuration::get('PS_SHOP_DOMAIN'));
        }
        $this->context->smarty->assign('_MODULE_DIR_', _MODULE_DIR_);
        $this->context->smarty->assign(
            'PS_DISABLE_NON_NATIVE_MODULE',
            Configuration::get('PS_DISABLE_NON_NATIVE_MODULE')
        );
        $this->context->smarty->assign(
            'pathgeneilogin',
            _PS_MODULE_DIR_ . $this->name . '/views/templates/admin/geneilogin.tpl'
        );
        $this->context->smarty->assign(
            'pathgeneidefaultaddresses',
            _PS_MODULE_DIR_ . $this->name . '/views/templates/admin/defaultaddresses.tpl'
        );
        $this->context->smarty->assign(
            'pathgeneidefaultatributes',
            _PS_MODULE_DIR_ . $this->name . '/views/templates/admin/defaultattributes.tpl'
        );
        $this->context->smarty->assign(
            'pathgeneidefaultpaymentmethod',
            _PS_MODULE_DIR_ . $this->name . '/views/templates/admin/defaultpaymentmethod.tpl'
        );
        $this->context->smarty->assign(
            'pathgeneimodalalert',
            _PS_MODULE_DIR_ . $this->name . '/views/templates/admin/modalalert.tpl'
        );
        $this->context->smarty->assign(
            'pathgeneimodalregister',
            _PS_MODULE_DIR_ . $this->name . '/views/templates/admin/modalregister.tpl'
        );
        $this->context->smarty->assign(
            'pathgeneimodalregisterok',
            _PS_MODULE_DIR_ . $this->name . '/views/templates/admin/modalregisterok.tpl'
        );
        $this->context->smarty->assign(
            'pathgeneimodaltermsandconditions',
            _PS_MODULE_DIR_ . $this->name . '/views/templates/admin/modaltermsandconditions.tpl'
        );
        $this->context->smarty->assign(
            'pathgeneimodalerrorlogin',
            _PS_MODULE_DIR_ . $this->name . '/views/templates/admin/modalerrorlogin.tpl'
        );
        $this->context->smarty->assign(
            'pathgeneinewreversionavailable',
            _PS_MODULE_DIR_ . $this->name . '/views/templates/admin/newversionavailable.tpl'
        );
        $this->context->smarty->assign(
            'pathgeneiscripts',
            _PS_MODULE_DIR_ . $this->name . '/views/templates/admin/scripts.tpl'
        );
        $this->context->smarty->assign(
            'pathgeneistatusesrelations',
            _PS_MODULE_DIR_ . $this->name . '/views/templates/admin/statusesrelations.tpl'
        );
        $this->context->smarty->assign(
            'pathgeneigoogleapikey',
            _PS_MODULE_DIR_ . $this->name . '/views/templates/admin/googleapikey.tpl'
        );
        $this->context->smarty->assign(
            'pathgeneiusedcarriersinstalled',
            _PS_MODULE_DIR_ . $this->name . '/views/templates/admin/usedcarriersinstalled.tpl'
        );
        $this->context->smarty->assign(
            'pathgeneiusedcarriersnotinstalled',
            _PS_MODULE_DIR_ . $this->name . '/views/templates/admin/usedcarriersnotinstalled.tpl'
        );
        $this->context->smarty->assign(
            'pathpricevariation',
            _PS_MODULE_DIR_ . $this->name . '/views/templates/admin/pricevariation.tpl'
        );
        $this->context->smarty->assign(
            'pathaccountinfo',
            _PS_MODULE_DIR_ . $this->name . '/views/templates/admin/accountinfo.tpl'
        );
        $this->context->smarty->assign('errors', $this->errors);
        $this->context->smarty->assign(
            'geneiajaxcontrollerlink',
            $this->context->link->getAdminLink('Genei')
        );
        return $this->context->smarty->
                createTemplate(
                    _PS_MODULE_DIR_
                    . $this->name . '/views/templates/admin/configure.tpl',
                    $this->context->smarty
                )->fetch();
    }

    public function isGeneiCarrier($id_carrier)
    {
        $objCarrier = new Carrier($id_carrier);
        if ($objCarrier->is_module == 1
            && $objCarrier->external_module_name == $this->name
            && $this->obtainGeneiCarrier($id_carrier) > 0) {
            return true;
        } else {
            return false;
        }
    }

    public function cartPriceGenei($id_cart)
    {
        $fichero = getcwd().'/modules/genei/logcart.html';
        $objeto_cart = new Cart($id_cart);
        if (is_null($objeto_cart)) {
            $objeto_cart = new Cart($this->context->cookie->id_cart);
        }
        if (is_null($objeto_cart)) {
            return false;
        }
        $id_customer = $objeto_cart->id_customer;
        $customer = new Customer((int) $id_customer);
        $delivery_address_object = new Address($objeto_cart->id_address_delivery);
        $invoice_address_object = new Address($objeto_cart->id_address_invoice);
        $delivery_country_object = new Country($delivery_address_object->id_country);
        $array_bultos = array();
        $array_bultos[0] = array();
        $valor_mercancia = 0;
        $contenido_envio = '';
        $products = $objeto_cart->getProducts();
        $i = 1;
        foreach ($products as $product) {
            if ($product['weight'] <= 0) {
                $product['weight'] = 1;
            }
            if ($product['height'] <= 0) {
                $product['height'] = 1;
            }
            if ($product['width'] <= 0) {
                $product['width'] = 1;
            }
            if ($product['depth'] <= 0) {
                $product['depth'] = 1;
            }
            if ($product['quantity'] == 1) {
                $array_bultos[$i]['peso'] = $product['weight'];
                $array_bultos[$i]['alto'] = $product['height'];
                $array_bultos[$i]['ancho'] = $product['width'];
                $array_bultos[$i]['largo'] = $product['depth'];
                $array_bultos[$i]['contenido'] = '';
                $array_bultos[$i]['valor'] = 0;
            } else {
                $total_kg = $product['weight'] * $product['quantity'];
                $total_volumetric =
                    (($product['width'] / 100)
                    * ($product['height'] / 100)
                    * ($product['depth'] / 100))
                    * 167 * $product['quantity'];
                $total_weight = max(array($total_kg, $total_volumetric));
                $array_products =
                    array('width' => $product['width'],
                        'height' => $product['height'],
                        'depth' => $product['depth']);
                asort($array_products);
                $convertir_idioma = array();
                $convertir_idioma['width'] = 'ancho';
                $convertir_idioma['height'] = 'alto';
                $convertir_idioma['depth'] = 'largo';
                if ($total_weight > 38) {
                    $exploded_items_number = $total_weight / 38;
                    if ((float) ($exploded_items_number) > 0) {
                        $exploded_items_number++;
                    }
                    if ($exploded_items_number == 0) {
                        $exploded_items_number = 1;
                    }
                } else {
                    $exploded_items_number = 1;
                }
                $exploded_items_number = (int) ($exploded_items_number);
                $articles_each_exploded_items_number = (int) ($product['quantity'] / $exploded_items_number);
                if ($product['quantity'] % $exploded_items_number !=0) {
                    $remain_articles_box = true;
                } else {
                    $remain_articles_box = false;
                }
                $remain_kg = $total_kg;
                $array_allboxes = array();
                for ($k = 1; $k < $articles_each_exploded_items_number; $k++) {
                    $array_box = array();
                    $array_box['length'] = $product['depth'];
                    $array_box['width'] = $product['width'];
                    $array_box['height'] = $product['height'];
                    array_push($array_allboxes, $array_box);
                }
                for ($j = 0; $j < $exploded_items_number; $j++) {
                    if ($remain_articles_box && $j == ($exploded_items_number - 1)) {
                        $array_box = array();
                        $array_box['length'] = $product['depth'];
                        $array_box['width'] = $product['width'];
                        $array_box['height'] = $product['height'];
                        array_push($array_allboxes, $array_box);
                    }
                    $boxDimension = $this->boxNumberCalculation($array_allboxes);
                    $array_bultos[$i + $j]['peso'] =
                        $product['weight']
                        * (int) ($product['quantity'] / $exploded_items_number);
                    $array_bultos[$i + $j]['alto'] = $boxDimension['height'];
                    $array_bultos[$i + $j]['ancho'] = $boxDimension['width'];
                    $array_bultos[$i + $j]['largo'] = $boxDimension['length'];
                    $array_bultos[$i + $j]['contenido'] = '';
                    $array_bultos[$i + $j]['valor'] = 0;
                    $remain_kg -= $array_bultos[$i + $j]['peso'];
                }
                $array_bultos[$i + ($j - 1)]['peso'] += $remain_kg;
                $i = $i + $j;
            }
            $i++;
        }
        if (file_exists($fichero)) {
            $d = DateTime::createFromFormat('U.u', microtime(true));
            file_put_contents(
                $fichero,
                $d->format('Y-m-d h:i:s:u').': boxDimension: '.
                    var_export($boxDimension, true).' array_allboxes :'.
                    var_export($array_allboxes, true).' array_bultos: '.
                    var_export($array_bultos, true).'<p>',
                FILE_APPEND | LOCK_EX
            );
        }
        $this->insertGeneiArrayBoxes($id_cart, $array_bultos);
        $valor_mercancia = 0;
        $contenido_envio = 'No informado';
        $datos_array = array();
        $datos_array['array_bultos'] = $array_bultos;
        $datos_array['valor_mercancia'] = $valor_mercancia;
        $datos_array['contenido_envio'] = $contenido_envio;
        if (file_exists($fichero)) {
            $d = DateTime::createFromFormat('U.u', microtime(true));
            file_put_contents(
                $fichero,
                $d->format('Y-m-d h:i:s:u').': Estoy obteniendo las direcciónes para saber el precio<p>',
                FILE_APPEND | LOCK_EX
            );
        }
        
        $array_direccion_seleccionada_completa =
        Tools::jsonDecode($this->configurationGet('direccion_predeterminada_genei_json'));
        if ($array_direccion_seleccionada_completa == null) {
            return(Tools::jsonEncode(array()));
        }
        $datos_array['codigos_origen'] = $array_direccion_seleccionada_completa->codigo_postal;
        $datos_array['poblacion_salida'] = $array_direccion_seleccionada_completa->poblacion;
        $datos_array['iso_pais_salida'] = $array_direccion_seleccionada_completa->country_code;
        $datos_array['direccion_salida'] = $array_direccion_seleccionada_completa->direccion;
        $datos_array['email_salida'] = $array_direccion_seleccionada_completa->mail;
        if ($datos_array['email_salida'] == '') {
            $datos_array['email_salida'] = 'email_no_informado@genei.es';
        }
        $datos_array['nombre_salida'] = $array_direccion_seleccionada_completa->nombre;
        $datos_array['telefono_salida'] = $array_direccion_seleccionada_completa->telefono;
        $datos_array['codigos_destino'] = $delivery_address_object->postcode;
        $datos_array['poblacion_llegada'] = $delivery_address_object->city;
        $datos_array['iso_pais_llegada'] = $delivery_country_object->iso_code;
        $datos_array['direccion_llegada'] =
            $delivery_address_object->address1 . " " . $delivery_address_object->address2;
        $datos_array['telefono_llegada'] = $delivery_address_object->phone;
        if ($datos_array['telefono_llegada'] == '') {
            $datos_array['telefono_llegada'] = $delivery_address_object->phone_mobile;
        }
        $datos_array['email_llegada'] = $customer->email;
        $datos_array['nombre_llegada'] =
            $delivery_address_object->firstname . ' ' . $delivery_address_object->lastname;
        if (property_exists($invoice_address_object, 'vat_number')) {
            $datos_array['dni_llegada'] =$invoice_address_object->vat_number;
        } else {
            if (property_exists($customer, 'dni')) {
                $datos_array['dni_llegada'] =$customer->dni;
            } else {
                if (property_exists($customer, 'cif')) {
                    $datos_array['dni_llegada'] = $customer->cif;
                } else {
                    if (property_exists($customer, 'nif')) {
                        $datos_array['dni_llegada'] = $customer->nif;
                    } else {
                        $datos_array['dni_llegada'] = '00000000t';
                    }
                }
            }
        }
        if (file_exists($fichero)) {
            $d = DateTime::createFromFormat('U.u', microtime(true));
            file_put_contents(
                $fichero,
                $d->format('Y-m-d h:i:s:u').': Estoy obteniendo el precio ahora<p>',
                FILE_APPEND | LOCK_EX
            );
        }
        $array_agencias_precios = $this->getAgenciesPriceList($datos_array);
        $array_agencias_precios = $array_agencias_precios['datos_agencia2'];
        return(Tools::jsonEncode($array_agencias_precios));
    }

    public function boxNumberCalculation($array_boxes)
    {
        $datos_array = array();
        $datos_array['array_boxes'] = $array_boxes;
        $datos_array['usuario_servicio'] = $this->configurationGet('usuario_servicio_genei');
        $datos_array['password_servicio'] = $this->configurationGet('password_servicio_genei');
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $url = 'http://www.genei.es/json_interface/obtener_caja_optima';
        $datos_array['id_usuario'] = $this->getUserId($datos_array);
        $salida = $this->curlJson($datos_array, $url);
        return Tools::jsonDecode($salida, true);
    }

    public function searchGeneiPrices($datos_json_obtener_datos_buscar_precios_genei)
    {
        $datos_array = $this->calculateOrderData($datos_json_obtener_datos_buscar_precios_genei, true);
        return(Tools::jsonEncode($this->getAgenciesPriceList($datos_array)['datos_agencia2']));
    }

    public function calculateOrderData($datos_json_obtener_datos_pedido_genei)
    {
        $pedido_array = Tools::jsonDecode($datos_json_obtener_datos_pedido_genei, true);
        $order = $pedido_array['id_order'];

        $objeto_orden = new Order($order);

        $id_customer = $objeto_orden->id_customer;
        $id_cart = $objeto_orden->id_cart;
        $customer = new Customer((int) $id_customer);
        $delivery_address_object = new Address($objeto_orden->id_address_delivery);
        $invoice_address_object = new Address($objeto_orden->id_address_invoice);
        $delivery_country_object = new Country($delivery_address_object->id_country);

        $datos_buscar_precios = new stdClass();
        $datos_buscar_precios->text_max_bultos = $pedido_array['text_max_bultos'];
        if (array_key_exists('stock_api', $pedido_array)) {
            $datos_buscar_precios->stock_api = $pedido_array['stock_api'];
        }
        if (array_key_exists('codigo_promocional_pag_pedido_genei', $pedido_array)) {
            $datos_buscar_precios->codigo_promocional_pag_pedido_genei =
                $pedido_array['codigo_promocional_pag_pedido_genei'];
        } else {
            $pedido_array['codigo_promocional_pag_pedido_genei']  = '';
        }
        $datos_buscar_precios->dropshipping_pag_pedido_genei = $pedido_array['dropshipping_pag_pedido_genei'];
        $datos_buscar_precios->direccion_predeterminada_dropshipping_genei =
            $pedido_array['direccion_predeterminada_dropshipping_genei'];
        $datos_buscar_precios->direccion_predeterminada_genei = $pedido_array['direccion_predeterminada_genei'];
        $datos_buscar_precios->observaciones_salida = $pedido_array['observaciones_salida'];
        $datos_buscar_precios->contacto_salida = $pedido_array['contacto_salida'];
        $datos_buscar_precios->contacto_llegada = $pedido_array['contacto_llegada'];
        $datos_buscar_precios->codigo_mercancia = $pedido_array['codigo_mercancia'];
        if (array_key_exists('recoger_tienda_pag_pedido_genei', $pedido_array)) {
            $datos_buscar_precios->recoger_tienda_pag_pedido_genei =
                $pedido_array['recoger_tienda_pag_pedido_genei'];
        } else {
            $pedido_array['recoger_tienda_pag_pedido_genei']  = '';
        }
        $datos_buscar_precios->recoger_tienda_pag_pedido_genei =
            $pedido_array['recoger_tienda_pag_pedido_genei'];
        $datos_buscar_precios->observaciones_llegada =
            $pedido_array['observaciones_llegada'] . '-' . $this->getUserComments($order, true);
        $datos_buscar_precios->fecha_recogida = $this->configurationGet('fecha_recogida');
        $datos_buscar_precios->unidad_correo = $this->configurationGet('unidad_correo');
        $array_bultos = array();
        $array_bultos[0] = array();
        $valor_mercancia = 0;
        $contenido_envio = '';
        for ($i = 1; $i <= $datos_buscar_precios->text_max_bultos; $i++) {
            $propiedad = "peso_" . $i;
            $array_bultos[$i]['peso'] = $pedido_array[$propiedad];
            if ($array_bultos[$i]['peso'] <= 0) {
                $array_bultos[$i]['peso'] = 1;
            }
            $propiedad = "largo_" . $i;
            $array_bultos[$i]['largo'] = $pedido_array[$propiedad];
            $propiedad = "ancho_" . $i;
            $array_bultos[$i]['ancho'] = $pedido_array[$propiedad];
            $propiedad = "alto_" . $i;
            $array_bultos[$i]['alto'] = $pedido_array[$propiedad];

            $propiedad = "contenido_" . $i;
            if (!array_key_exists($propiedad, $pedido_array)) {
                $pedido_array[$propiedad] = '';
            }
            $array_bultos[$i]['contenido'] = $pedido_array[$propiedad];

            $propiedad = "taric_" . $i;
            if (!array_key_exists($propiedad, $pedido_array)) {
                $pedido_array[$propiedad] = '';
            }
            $array_bultos[$i]['taric'] = $pedido_array[$propiedad];

            $propiedad = "dni_contenido_" . $i;
            if (!array_key_exists($propiedad, $pedido_array)) {
                $pedido_array[$propiedad] = '';
            }
            if ($invoice_address_object->dni != '') {
                $array_bultos[$i]['dni_contenido'] = $invoice_address_object->dni;
            } else {
                $array_bultos[$i]['dni_contenido'] = $invoice_address_object->vat_number;
            }
            $propiedad = "valor_" . $i;
            if (!array_key_exists($propiedad, $pedido_array)) {
                $pedido_array[$propiedad] = '';
            }
            $array_bultos[$i]['valor'] = $pedido_array[$propiedad];
            if (is_numeric($array_bultos[$i]['valor'])) {
                $valor_mercancia += $array_bultos[$i]['valor'];
            }
            $contenido_envio .= $array_bultos[$i]['contenido'] . ', ';
        }

        if ($contenido_envio == '') {
            $contenido_envio = 'No informado';
        }
        $datos_array = array();
        $datos_array['array_bultos'] = $array_bultos;
        $datos_array['valor_mercancia'] = $valor_mercancia;
        $datos_array['contenido_envio'] = $contenido_envio;
        $datos_array['contrareembolso'] = 0;
        $datos_array['cantidad_reembolso'] = 0;
        $datos_array['seguro'] = 0;
        $datos_array['cantidad_seguro'] = 0;
        $array_direcciones_genei = Tools::jsonDecode($this->getAddressesList(), true);
        if ($datos_buscar_precios->dropshipping_pag_pedido_genei == 1) {
            foreach ($array_direcciones_genei as $direccion) {
                if ($direccion['codigo'] == $datos_buscar_precios->direccion_predeterminada_dropshipping_genei) {
                    $array_direccion_seleccionada_dropshipping = $direccion;
                } else {
                    continue;
                }
            }
            $array_direccion_seleccionada_dropshipping_completa = Tools::jsonDecode(
                $this->obtainAddressDataId($array_direccion_seleccionada_dropshipping['id_direccion'], true)
            );
            $datos_array['dropshipping'] = 1;
            $datos_array['iso_pais_drop'] = $array_direccion_seleccionada_dropshipping_completa->country_code;
            $datos_array['cp_drop'] = $array_direccion_seleccionada_dropshipping_completa->codigo_postal;
            $datos_array['pob_drop'] = $array_direccion_seleccionada_dropshipping_completa->poblacion;
            $datos_array['dir_drop'] = $array_direccion_seleccionada_dropshipping_completa->direccion;
            $datos_array['obs_drop'] = $datos_buscar_precios->observaciones_salida;
            $datos_array['nombre_drop'] = $array_direccion_seleccionada_dropshipping_completa->nombre;
            $datos_array['email_drop'] = $array_direccion_seleccionada_dropshipping_completa->mail;
            $datos_array['tel_drop'] = $array_direccion_seleccionada_dropshipping_completa->telefono;
            $datos_array['contacto_drop'] = $datos_buscar_precios->contacto_salida;
        } else {
            $datos_array['dropshipping'] = 0;
        }
        foreach ($array_direcciones_genei as $direccion) {
            if ($direccion['codigo'] == $datos_buscar_precios->direccion_predeterminada_genei) {
                $array_direccion_seleccionada = $direccion;
                break;
            } else {
                continue;
            }
        }
        
        $array_direccion_seleccionada_completa = Tools::jsonDecode(
            $this->obtainAddressDataId(
                $array_direccion_seleccionada['id_direccion'],
                true
            )
        );
        $datos_array['codigos_origen'] = $array_direccion_seleccionada_completa->codigo_postal;
        $datos_array['poblacion_salida'] = $array_direccion_seleccionada_completa->poblacion;
        $datos_array['iso_pais_salida'] = $array_direccion_seleccionada_completa->country_code;
        $datos_array['direccion_salida'] = $array_direccion_seleccionada_completa->direccion;
        $datos_array['email_salida'] = $array_direccion_seleccionada_completa->mail;
        if ($datos_array['email_salida'] == '') {
            $datos_array['email_salida'] = 'email_no_informado@genei.es';
        }
        $datos_array['nombre_salida'] = $array_direccion_seleccionada_completa->nombre;
        $datos_array['telefono_salida'] = $array_direccion_seleccionada_completa->telefono;
        $datos_array['codigos_destino'] = $delivery_address_object->postcode;
        $datos_array['poblacion_llegada'] = $delivery_address_object->city;
        $datos_array['iso_pais_llegada'] = $delivery_country_object->iso_code;
        $datos_array['direccion_llegada'] =
            $delivery_address_object->address1 . " " . $delivery_address_object->address2;
        $datos_array['telefono_llegada'] = $delivery_address_object->phone;
        if ($datos_array['telefono_llegada'] == '') {
            $datos_array['telefono_llegada'] = $delivery_address_object->phone_mobile;
        }
        $datos_array['email_llegada'] = $customer->email;
        $datos_array['nombre_llegada'] = $delivery_address_object->firstname . ' ' . $delivery_address_object->lastname;
        if (property_exists($invoice_address_object, 'vat_number')) {
            $datos_array['dni_llegada'] =$invoice_address_object->vat_number;
        } else {
            if (property_exists($customer, 'dni')) {
                $datos_array['dni_llegada'] =$customer->dni;
            } else {
                if (property_exists($customer, 'cif')) {
                    $datos_array['dni_llegada'] = $customer->cif;
                } else {
                    if (property_exists($customer, 'nif')) {
                        $datos_array['dni_llegada'] = $customer->nif;
                    } else {
                        $datos_array['dni_llegada'] = '00000000t';
                    }
                }
            }
        }
        $datos_array['observaciones_salida'] = $datos_buscar_precios->observaciones_salida;
        if (property_exists($datos_buscar_precios, 'stock_api')) {
            $datos_array['stock_api'] = $datos_buscar_precios->stock_api;
        }
        $datos_array['contacto_salida'] = $datos_buscar_precios->contacto_salida;
        $datos_array['observaciones_llegada'] = $datos_buscar_precios->observaciones_llegada;
        $datos_array['contacto_llegada'] = $datos_buscar_precios->contacto_llegada;
        $datos_array['codigo_mercancia'] = $datos_buscar_precios->codigo_mercancia;
        $datos_array['recoger_tienda'] = $datos_buscar_precios->recoger_tienda_pag_pedido_genei;
        if (array_key_exists('contrareembolso', $pedido_array)) {
            $datos_array['contrareembolso'] = $pedido_array['contrareembolso'];
        } else {
            $datos_array['contrareembolso'] = '';
        }
        if (array_key_exists('cantidad_reembolso', $pedido_array)) {
            $datos_array['cantidad_reembolso'] = $pedido_array['cantidad_reembolso'];
        } else {
            $datos_array['cantidad_reembolso'] = '';
        }
        if (array_key_exists('seguro', $pedido_array)) {
            $datos_array['seguro'] = $pedido_array['seguro'];
        } else {
            $datos_array['seguro'] = '';
        }
        if (array_key_exists('cantidad_seguro', $pedido_array)) {
            $datos_array['cantidad_seguro'] = $pedido_array['cantidad_seguro'];
        } else {
            $datos_array['cantidad_seguro'] = '';
        }
        if (array_key_exists('cod_promo', $pedido_array)) {
            $datos_array['cod_promo'] = $pedido_array['cod_promo'];
        } else {
            $datos_array['cod_promo'] = '';
        }
        if (array_key_exists('activar_oficina_destino_correos_express', $pedido_array)) {
            $datos_array['activar_oficina_destino_correos_express'] =
                $pedido_array['activar_oficina_destino_correos_express'];
        } else {
            $datos_array['activar_oficina_destino_correos_express'] = '';
        }
        $idDeliveryPoint = $this->getDeliveryPoint($id_cart);
        if ((!array_key_exists('select_oficinas_destino', $pedido_array)
            || $pedido_array['select_oficinas_destino']=='')
            && $idDeliveryPoint > 0) {
            $datos_array['select_oficinas_destino'] = $this->getDeliveryPoint($id_cart);
        }
        if ((array_key_exists('select_oficinas_destino', $pedido_array)
            && $pedido_array['select_oficinas_destino']!='')
            && !($idDeliveryPoint > 0)) {
            $datos_array['select_oficinas_destino'] = $pedido_array['select_oficinas_destino'];
        }
        if (array_key_exists('fecha_recogida', $pedido_array)) {
            $datos_array['fecha_recogida'] = $pedido_array['fecha_recogida'];
        }
        if (array_key_exists('hora_recogida_desde', $pedido_array)) {
            $datos_array['hora_recogida_desde'] = $pedido_array['hora_recogida_desde'];
        }
        if (array_key_exists('hora_recogida_hasta', $pedido_array)) {
            $datos_array['hora_recogida_hasta'] = $pedido_array['hora_recogida_hasta'];
        }
        if (array_key_exists('unidad_correo', $pedido_array)) {
            $datos_array['unidad_correo'] = $pedido_array['unidad_correo'];
        }
        if (array_key_exists('id_order', $pedido_array)) {
            $objeto_order = new Order($pedido_array['id_order']);
            $datos_array['codigo_envio_servicio'] = $objeto_order->reference;
        }
        if (array_key_exists('id_agencia', $pedido_array)) {
            $datos_array['id_agencia'] = $pedido_array['id_agencia'];
        }
        if (array_key_exists('tipo_mercancia_correos', $pedido_array)) {
            $datos_array['tipo_mercancia_correos'] = $pedido_array['tipo_mercancia_correos'];
        }
        if (array_key_exists('valor_mercancia_correos', $pedido_array)) {
            $datos_array['valor_mercancia_correos'] = $pedido_array['valor_mercancia_correos'];
        }
        if (array_key_exists('suplemento_picking_total', $pedido_array)) {
            $datos_array['suplemento_picking_total'] = $pedido_array['suplemento_picking_total'];
        }
        if (array_key_exists('suplemento_picking_total_con_iva', $pedido_array)) {
            $datos_array['suplemento_picking_total_con_iva'] = $pedido_array['suplemento_picking_total_con_iva'];
        }
        if (array_key_exists('envio_desde_almacen', $pedido_array)) {
            $datos_array['envio_desde_almacen'] = $pedido_array['envio_desde_almacen'];
        }
        if (array_key_exists('observaciones_almacen', $pedido_array)) {
            $datos_array['observaciones_almacen'] = $pedido_array['observaciones_almacen'];
        }
        return $datos_array;
    }

    public function getOrderData($datos_json_obtener_datos_pedido_genei, $morir = false)
    {
        $array_datos_pedido = array();
        $datos_array = $this->calculateOrderData($datos_json_obtener_datos_pedido_genei, false);
        $array_datos_pedido['codigos_origen'] = $datos_array['codigos_origen'];
        $array_datos_pedido['codigos_destino'] = $datos_array['codigos_destino'];
        if (array_key_exists('select_oficinas_destino', $datos_array)) {
            $array_datos_pedido['select_oficinas_destino'] = $datos_array['select_oficinas_destino'];
        } else {
            $array_datos_pedido['select_oficinas_destino'] = '';
        }
        $array_datos_pedido['id_usuario'] = $this->getUserId($datos_array);
        $array_datos_pedido['id_pais_salida'] = $this->getOriginIdCountry($datos_array);
        $array_datos_pedido['id_pais_llegada'] = $this->getDestinationIdCountry($datos_array);
        $datos_array['id_pais'] = $array_datos_pedido['id_pais_salida'];
        $datos_array['codpos'] = $array_datos_pedido['codigos_origen'];
        $array_datos_pedido['zona_iva_exenta_salida'] = $this->noIvaZone($datos_array);
        $datos_array['id_pais'] = $array_datos_pedido['id_pais_llegada'];
        $datos_array['codpos'] = $array_datos_pedido['codigos_destino'];
        $array_datos_pedido['zona_iva_exenta_llegada'] = $this->noIvaZone($datos_array);
        if ($array_datos_pedido['zona_iva_exenta_salida'] == 1 || $array_datos_pedido['zona_iva_exenta_llegada'] == 1) {
            $array_datos_pedido['zona_iva_exenta'] = 1;
        } else {
            $array_datos_pedido['zona_iva_exenta'] = 0;
        }
        if ($morir) {
            die(Tools::jsonEncode($array_datos_pedido));
        } else {
            return $array_datos_pedido;
        }
    }

    private function curlJson($datos_array, $url)
    {
        $datos_json_post = Tools::jsonEncode($datos_array);
        $headers = array('Content-type: application/json');
        $respuesta = '';
        $ch = curl_init($url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_HEADER, false);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $datos_json_post);
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 15);
        curl_setopt($ch, CURLOPT_TIMEOUT, 15);
        $respuesta = curl_exec($ch);
        curl_close($ch);
        return($respuesta);
    }

    public function getUpsCarriersBytype($tipo)
    {
        $datos_array = array();
        $datos_array['usuario_servicio'] = $this->configurationGet('usuario_servicio_genei');
        $datos_array['password_servicio'] = $this->configurationGet('password_servicio_genei');
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $datos_array['tipo'] = $tipo;
        $url = 'http://www.genei.es/json_interface/obtener_agencias_ups_tipo';
        $salida = $this->curlJson($datos_array, $url);
        return json_decode($salida, true);
    }

    public function uninstallGeneiCarrier($id_agencia_json)
    {
        $id_agencia = Tools::jsonDecode($id_agencia_json);
        if (Tools::substr($id_agencia, 0, 4) != "9500" && !$this->existsGeneiCarrier($id_agencia)) {
            return;
        }
        if (Tools::substr($id_agencia, 0, 4) == "9500") {
            $array_agencias_tipo = $this->getUpsCarriersByType($id_agencia);
            foreach ($array_agencias_tipo as $agenciaUps) {
                $this->uninstallGeneiCarrierUnique($agenciaUps['id_agencia']);
            }
        } else {
            $this->uninstallGeneiCarrierUnique($id_agencia);
        }
    }

    public function uninstallGeneiCarrierUnique($id_genei_carrier)
    {
        $id_carrier = $this->obtainIdCarrier($id_genei_carrier);
        $this->deleteCarrier($id_carrier);
        $this->deleteGeneiCarrier($id_genei_carrier);
    }

    public function getCarrierVariationPriceJson($datos_json_obtener_variaciones_precio_transportista)
    {
        $id_genei_carrier = Tools::jsonDecode($datos_json_obtener_variaciones_precio_transportista);
        $sql = 'SELECT id_carrier,price_variation,variation_type FROM `'
            . _DB_PREFIX_ . 'genei_carriers` WHERE `id_genei_carrier` = \'' . (int) $id_genei_carrier . '\';';
        if ($row = Db::getInstance()->getRow($sql)) {
            return Tools::jsonEncode($row);
        }
    }
    
    public function createTableAddress()
    {
        if (!Db::getInstance()->execute(
            'CREATE TABLE IF NOT EXISTS `' . _DB_PREFIX_ . 'genei_addresses` (
                                `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
                                `addresses` TEXT NULL,
                                `fecha_hora_insercion` DATETIME NULL DEFAULT NULL,
                                PRIMARY KEY (`id`),
                                INDEX `fecha_hora_insercion` (`fecha_hora_insercion`)
                                ) ENGINE=' . _MYSQL_ENGINE_ . ' DEFAULT CHARSET=utf8'
        )) {
            $this->_errors[] = sprintf(Tools::displayError(
                $this->l('Unable to create Genei address table.')
            ));
        }
    }
    
    public function createTableAddressDataID()
    {
        if (!Db::getInstance()->execute(
            'CREATE TABLE IF NOT EXISTS `' . _DB_PREFIX_ . 'genei_addressdata` (
                                `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
                                `id_direccion` INT(11) UNSIGNED NULL DEFAULT NULL,
                                `data` TEXT NULL,
                                `fecha_hora_insercion` DATETIME NULL DEFAULT NULL,
                                PRIMARY KEY (`id`),
                                INDEX `fecha_hora_insercion` (`fecha_hora_insercion`),
                                INDEX `id_direccion` (`id_direccion`)
                                ) ENGINE=' . _MYSQL_ENGINE_ . ' DEFAULT CHARSET=utf8'
        )) {
            $this->_errors[] = sprintf(Tools::displayError(
                $this->l('Unable to create Genei addressdata cart table.')
            ));
        }
    }
    
    public function getAddressesListBD()
    {
        $sql = 'SELECT addresses,fecha_hora_insercion FROM `'
            . _DB_PREFIX_ . 'genei_addresses`;';
        if ($row = Db::getInstance()->getRow($sql)) {
            return Tools::jsonEncode($row);
        }
    }
    
    public function getAddressesDataIdBD($addressID)
    {
        $sql = 'SELECT data,fecha_hora_insercion FROM `'
            . _DB_PREFIX_ . 'genei_addressdata` WHERE `id_direccion` = \'' . (int) $addressID . '\';';
        if ($row = Db::getInstance()->getRow($sql)) {
            return Tools::jsonEncode($row);
        }
    }
    
    public function insertAddressesListBD($addresses_json)
    {
        $this->dropAddressesListBD();
        $this->createTableAddress();
        return Db::getInstance()->execute(
            'INSERT INTO `' . _DB_PREFIX_ . 'genei_addresses` (
            `addresses`,`fecha_hora_insercion`)
            VALUES (\'' . (string) $addresses_json . '\', \'' . pSQL(date('Y-m-d H:i:s')) . '\');'
        );
    }
    
    public function insertAddressesDataIdBD($addressData_json, $addressID)
    {
        $this->dropAddressesDataIdBD();
        $this->createTableAddressDataID();
        return Db::getInstance()->execute(
            'INSERT INTO `' . _DB_PREFIX_ . 'genei_addressdata` (
            `data`,`id_direccion`,`fecha_hora_insercion`)
            VALUES (\'' . (string) $addressData_json . '\',\''
            . (int) $addressID . '\', \'' . pSQL(date('Y-m-d H:i:s')) . '\');'
        );
    }
    
    public function dropAddressesListBD()
    {
        Db::getInstance()->execute(
            'DROP TABLE IF EXISTS `' . _DB_PREFIX_ . 'genei_addresses`'
        );
    }
    
    public function dropAddressesDataIdBD()
    {
        Db::getInstance()->execute(
            'DROP TABLE IF EXISTS `' . _DB_PREFIX_ . 'genei_addressdata`'
        );
    }

    public function getCarrierVariationPriceAmount($id_genei_carrier)
    {
        $sql = 'SELECT price_variation FROM `'
            . _DB_PREFIX_ . 'genei_carriers` WHERE `id_genei_carrier` = \'' . (int) $id_genei_carrier . '\';';
        if ($row = Db::getInstance()->getRow($sql)) {
            return $row['price_variation'];
        }
    }

    public function getCarrierVariationFreeAmount($id_genei_carrier)
    {
        $sql = 'SELECT amount_free FROM `'
            . _DB_PREFIX_ . 'genei_carriers` WHERE `id_genei_carrier` = \'' . (int) $id_genei_carrier . '\';';
        if ($row = Db::getInstance()->getRow($sql)) {
            return $row['amount_free'];
        }
    }

    public function getCarrierVariationType($id_genei_carrier)
    {
        $sql = 'SELECT variation_type FROM `'
            . _DB_PREFIX_ . 'genei_carriers` WHERE `id_genei_carrier` = \'' . (int) $id_genei_carrier . '\';';
        if ($row = Db::getInstance()->getRow($sql)) {
            return $row['variation_type'];
        }
    }

    public function getAllCarriersVariationPriceAmount()
    {
        $array_variations_amounts = array();
        $sql = 'SELECT id_genei_carrier,price_variation FROM `' . _DB_PREFIX_ . 'genei_carriers`;';
        if ($results = Db::getInstance()->ExecuteS($sql)) {
            foreach ($results as $row) {
                $array_variations_amounts[$row['id_genei_carrier']] = $row['price_variation'];
            }
        }
        return $array_variations_amounts;
    }

    public function getAllCarriersVariationAmountFree()
    {
        $array_variations_amount_free = array();
        $sql = 'SELECT id_genei_carrier,amount_free FROM `' . _DB_PREFIX_ . 'genei_carriers`;';
        if ($results = Db::getInstance()->ExecuteS($sql)) {
            foreach ($results as $row) {
                $array_variations_amount_free[$row['id_genei_carrier']] = $row['amount_free'];
            }
        }
        return $array_variations_amount_free;
    }

    public function getAllCarriersVariationPriceType()
    {
        $array_type_variations = array();
        $sql = 'SELECT id_genei_carrier,variation_type FROM `'
            . _DB_PREFIX_ . 'genei_carriers`;';
        if ($results = Db::getInstance()->ExecuteS($sql)) {
            foreach ($results as $row) {
                $array_type_variations[$row['id_genei_carrier']] = $row['variation_type'];
            }
        }
        return $array_type_variations;
    }

    public function setCarrierVariationPrice($id_genei_carrier, $price_variation, $amount_free, $variation_type)
    {
        Db::getInstance()->execute(
            'UPDATE `' . _DB_PREFIX_
            . 'genei_carriers` SET price_variation = \'' . (float) $price_variation
            . '\', variation_type = \'' . (float) $variation_type
            . '\', amount_free = \'' . (float) $amount_free
            . '\' WHERE id_genei_carrier = \'' . (int) $id_genei_carrier . '\';'
        );
    }

    public function obtainIdCarrier($id_genei_carrier)
    {
        $sql = 'SELECT id_carrier FROM `'
            . _DB_PREFIX_ . 'genei_carriers` WHERE `id_genei_carrier` = \'' . (int) $id_genei_carrier . '\';';
        if ($row = Db::getInstance()->getRow($sql)) {
            return $row['id_carrier'];
        }
    }

    public function installGeneiCarrier($id_agencia_json)
    {
        $id_agencia = Tools::jsonDecode($id_agencia_json);
        if ($this->existsGeneiCarrier($id_agencia)) {
            return;
        }
       

        if (Tools::substr($id_agencia, 0, 4) == "9500") {
            $array_agencias_tipo = $this->getUpsCarriersByType($id_agencia);
            foreach ($array_agencias_tipo as $agenciaUps) {
                $this->installGeneiCarrierUnique($agenciaUps['id_agencia']);
            }
        } else {
            $this->installGeneiCarrierUnique($id_agencia);
        }
    }

    public function installGeneiCarrierUnique($id_agencia)
    {
        $carrier = new Carrier();
        $carrier->name = $this->getCarrierName(array('id_agencia' => $id_agencia));
        $carrier->id_tax_rules_group = 0;
        $carrier->active = 1;
        $carrier->deleted = 0;
        foreach (Language::getLanguages(true) as $language) {
            $carrier->delay[(int) $language['id_lang']] = $this->l('Delivery term: ')
                . $this->getCarrierService(array('id_agencia' => $id_agencia));
        }
        $carrier->id_tax_rules_group = 0;
        $carrier->shipping_handling = false;
        $carrier->range_behavior = 0;
        $carrier->is_module = true;
        $carrier->shipping_handling = false;
        $carrier->shipping_external = true;
        $carrier->external_module_name = $this->name;
        $carrier->need_range = true;
        if (!$carrier->add()) {
            return false;
        }

        // Associate carrier to all groups
        $groups = Group::getGroups(true);
        foreach ($groups as $group) {
            Db::getInstance()->insert(
                'carrier_group',
                array('id_carrier' => (int) $carrier->id,
                    'id_group' => (int) $group['id_group'])
            );
        }
        $rangeWeight = new RangeWeight();
        $rangeWeight->id_carrier = $carrier->id;
        $rangeWeight->delimiter1 = '0';
        $rangeWeight->delimiter2 = '99999';
        $rangeWeight->add();
        // Associate carrier to all zones
        $zones = Zone::getZones(true);
        foreach ($zones as $zone) {
            Db::getInstance()->insert(
                'carrier_zone',
                array('id_carrier' => (int) $carrier->id,
                    'id_zone' => (int) $zone['id_zone'])
            );
            Db::getInstance()->insert(
                'delivery',
                array(
                'id_carrier' => (int) $carrier->id,
                'id_range_price' => null,
                'id_range_weight' => (int) $rangeWeight->id,
                'id_zone' => (int) $zone['id_zone'],
                'price' => '1000'
                )
            );
            Db::getInstance()->insert(
                'delivery',
                array(
                'id_carrier' => (int) $carrier->id,
                'id_range_price' => null,
                'id_range_weight' => (int) $rangeWeight->id,
                'id_zone' => (int) $zone['id_zone'],
                'price' => '1000'
                )
            );
        }
        // Copy the carrier logo
        $ruta_imagen_transportista = $this->getCarrierImageJpg(array('id_agencia' => $id_agencia));
        file_put_contents(
            _PS_SHIP_IMG_DIR_ . '/' . (int) $carrier->id . '.jpg',
            Tools::file_get_contents(
                'https://www.genei.es/'
                . $ruta_imagen_transportista
            )
        );
        $this->insertGeneiCarrier((int) $carrier->id, (int) $id_agencia);
        Tools::clearSmartyCache();
        Tools::clearXMLCache();
        Media::clearCache();
        Tools::generateIndex();
    }

    public function deleteCarrier($id_carrier)
    {
        Db::getInstance()->execute(
            'UPDATE `' . _DB_PREFIX_ . 'carrier` SET deleted = 1 WHERE id_carrier = \'' . (int) $id_carrier . '\';'
        );
        Db::getInstance()->execute(
            'DELETE FROM `' . _DB_PREFIX_
            . 'delivery` WHERE `id_carrier` = \'' . (int) $id_carrier . '\';'
        );
        Db::getInstance()->execute(
            'DELETE FROM `' . _DB_PREFIX_
            . 'carrier_zone` WHERE `id_carrier` = \'' . (int) $id_carrier . '\';'
        );
    }

    public function deleteAllGeneiCarriers()
    {
        $rs_carriers = Db::getInstance()->executeS(
            'SELECT id_carrier FROM `' . _DB_PREFIX_
            . 'carrier` WHERE `external_module_name` = \'' . pSQL($this->name) . '\';'
        );
        foreach ($rs_carriers as $row_carrier) {
            Db::getInstance()->execute(
                'DELETE FROM `' . _DB_PREFIX_
                . 'delivery` WHERE `id_carrier` = \'' . (int) $row_carrier['id_carrier'] . '\';'
            );
            Db::getInstance()->execute(
                'DELETE FROM `' . _DB_PREFIX_
                . 'carrier_zone` WHERE `id_carrier` = \'' . (int) $row_carrier['id_carrier'] . '\';'
            );
        }
        Db::getInstance()->execute(
            'DELETE FROM `' . _DB_PREFIX_
            . 'carrier` WHERE `external_module_name` = \'' . pSQL($this->name) . '\';'
        );
        return true;
    }

    public function insertGeneiCarrier($id_carrier, $id_genei_carrier)
    {
        return Db::getInstance()->execute(
            'INSERT INTO `' . _DB_PREFIX_ . 'genei_carriers` (
            `id_carrier`,`id_genei_carrier`,`price_variation`,`variation_type`)
            VALUES (\'' . (int) $id_carrier . '\', \'' . (int) $id_genei_carrier . '\', \'0\',\'0\');'
        );
    }

    public function saveJsonRequest($json_request, $json_response)
    {
        return Db::getInstance()->execute(
            'INSERT INTO `' . _DB_PREFIX_ . 'genei_cart_price` (
            `json_request`,`json_response`,`fecha_hora`)
            VALUES (\'' . pSQL($json_request) . '\', \'' . pSQL($json_response) . '\', \''
                . pSQL(date('Y-m-d H:i:s')) . '\');'
        );
    }

    public function getJsonRequest($json_request)
    {
        $row = Db::getInstance()->getRow(
            'SELECT json_response FROM `' . _DB_PREFIX_ . 'genei_cart_price` WHERE `json_request` = \''
            . pSQL($json_request) . '\' AND json_response != \'\' and json_response
            IS NOT NULL AND fecha_hora > (NOW() - INTERVAL 12 HOUR) ORDER BY id DESC;'
        );
        if ($row == false) {
            return false;
        }
        return $row['json_response'];
    }

    public function insertGeneiArrayBoxes($id_cart, $array_boxes)
    {
        if ($array_boxes != null) {
            array_shift($array_boxes);
            foreach ($array_boxes as $box) {
                Db::getInstance()->execute(
                    'DELETE FROM `' . _DB_PREFIX_ . 'genei_array_boxes` WHERE `id_cart` = \'' . (int) $id_cart . '\';'
                );
            }
            foreach ($array_boxes as $box) {
                Db::getInstance()->execute(
                    'INSERT INTO `' . _DB_PREFIX_ . 'genei_array_boxes` (
                    `id_cart`,`box_weight`,`box_width`,`box_height`,`box_depth`)
                    VALUES (\'' . (int) $id_cart . '\', \'' . (float) $box['peso'] . '\', \'' . (float) $box['alto']
                    . '\', \'' . (float) $box['ancho'] . '\', \'' . (float) $box['largo'] . '\');'
                );
            }
        }
    }

    public function getArrayBoxes($id_cart)
    {
        $sql = 'SELECT box_weight, box_width,box_height,box_depth FROM `'
            . _DB_PREFIX_ . 'genei_array_boxes` WHERE `id_cart` = \''
            . (int) $id_cart . '\';';
        $results = Db::getInstance()->executeS($sql);
        return $results;
    }

    public function insertGeneiDeliveryPoint($id_cart, $id_delivery_point)
    {
        return Db::getInstance()->execute(
            'INSERT INTO `' . _DB_PREFIX_ . 'genei_cart_delivery_point` (
            `id_cart`,`id_delivery_point`)
            VALUES (\'' . (int) $id_cart . '\', \'' . (int) $id_delivery_point . '\');'
        );
    }

    public function existsGeneiDeliveryPoint($id_cart)
    {
        $sql = 'SELECT id_cart FROM `'
            . _DB_PREFIX_ . 'genei_cart_delivery_point` WHERE `id_cart` = \'' . (int) $id_cart . '\';';
        if (Db::getInstance()->getRow($sql)) {
            return true;
        } else {
            return false;
        }
    }

    public function updateGeneiDeliveryPoint($id_cart, $id_delivery_point)
    {
        Db::getInstance()->execute(
            'UPDATE `' . _DB_PREFIX_ .
            'genei_cart_delivery_point` SET id_delivery_point = ' .
            (int) $id_delivery_point . ' WHERE id_cart = ' . (int) $id_cart
        );
    }

    public function getDeliveryPoint($id_cart)
    {
        $row = Db::getInstance()->getRow(
            'SELECT id_delivery_point FROM `'
            . _DB_PREFIX_ . 'genei_cart_delivery_point` WHERE `id_cart` = \'' . (int) $id_cart . '\';'
        );
        return $row['id_delivery_point'];
    }

    public function getOrderShippingCost()
    {
        if (Configuration::get('PS_DISABLE_OVERRIDES') == 1
            || Configuration::get('PS_DISABLE_NON_NATIVE_MODULE') == 1) {
            return false;
        }
        if (!Module::isEnabled($this->name)) {
            return false;
        }
    }

    public function deleteOldJsonRequests()
    {
        return Db::getInstance()->execute(
            'DELETE FROM `' . _DB_PREFIX_
            . 'genei_cart_price` WHERE `fecha_hora` < NOW() - INTERVAL 12 HOUR;'
        );
    }

    public function deleteGeneiCarrier($id_genei_carrier)
    {
        return Db::getInstance()->execute(
            'DELETE FROM `' . _DB_PREFIX_
            . 'genei_carriers` WHERE `id_genei_carrier` = \'' . (int) $id_genei_carrier . '\';'
        );
    }

    public function obtainGeneiCarrier($id_carrier)
    {
        $row = Db::getInstance()->getRow(
            'SELECT id_genei_carrier FROM `'
            . _DB_PREFIX_ . 'genei_carriers` WHERE `id_carrier` = \'' . (int) $id_carrier . '\';'
        );
        return $row['id_genei_carrier'];
    }


    public function existsGeneiCarrier($id_genei_carrier)
    {
        $sql = 'SELECT id_genei_carrier FROM `'
            . _DB_PREFIX_ . 'genei_carriers` WHERE `id_genei_carrier` = \'' . (int) $id_genei_carrier . '\';';
        if (Db::getInstance()->getRow($sql)) {
            return true;
        } else {
            return false;
        }
    }

    public function updateOrderStatus($datos_json_actualizar_estado_pedido_genei)
    {
        $datos_array = Tools::jsonDecode($datos_json_actualizar_estado_pedido_genei, true);
        $objeto_order = new Order($datos_array['id_order']);
        $array_envio_creado = Tools::jsonDecode($this->getShipCodeExternalService($objeto_order->reference), true);
        Tools::jsonDecode($this->updateGeneiShipStatus($array_envio_creado), true);
    }

    public function shipAlreadyCreated($datos_array)
    {
        $datos_array['usuario_servicio'] = $this->configurationGet('usuario_servicio_genei');
        $datos_array['password_servicio'] = $this->configurationGet('password_servicio_genei');
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $url = 'http://www.genei.es/json_interface/obtener_codigo_envio';
        $datos_array['id_usuario'] = $this->getUserId($datos_array);
        $salida = $this->curlJson($datos_array, $url);
        return $salida;
    }

    public function getProformaUrl($codigo_envio)
    {
        $datos_array = array();
        $datos_array['usuario_servicio'] = $this->configurationGet('usuario_servicio_genei');
        $datos_array['password_servicio'] = $this->configurationGet('password_servicio_genei');
        $datos_array['codigo_envio'] = $codigo_envio;
        $datos_array['cn'] = $this->cn;
        $datos_array['servicio'] = self::SERVICIO;
        $url = 'http://www.genei.es/json_interface/obtener_url_proforma';
        $datos_array['id_usuario'] = $this->getUserId($datos_array);
        $salida = $this->curlJson($datos_array, $url);
        return $salida;
    }

    public function getPackageShippingCost($params)
    {
        if (!file_exists(_PS_ROOT_DIR_ . '/override/classes/Cart.php')) {
            return false;
        }
        if (!file_exists(_PS_ROOT_DIR_ . '/override/classes/Cart.php') && $params) {
            return false;
        }
    }

    public function configurationUpdateValue($name, $value)
    {
        if ($this->configurationNameExists($name)) {
            Db::getInstance()->execute(
                'UPDATE `' . _DB_PREFIX_ . 'genei_configuration` SET value = \''
                . pSQL($value) . '\', date_upd = \''
                . pSQL(date('Y-m-d H:i:s'))
                . '\' WHERE name = \'' . pSQL($name) . '\';'
            );
        } else {
            $this->configurationNameCreate($name, $value);
        }
    }

    public function configurationNameExists($name)
    {
        $row = Db::getInstance()->getRow(
            'SELECT name FROM `'
            . _DB_PREFIX_ . 'genei_configuration` WHERE `name` = \'' . pSQL($name) . '\';'
        );
        if ($row['name'] != null) {
            return true;
        } else {
            return false;
        }
    }

    public function configurationGet($name)
    {
        $row = Db::getInstance()->getRow(
            'SELECT value FROM `'
            . _DB_PREFIX_ . 'genei_configuration` WHERE `name` = \'' . pSQL($name) . '\';'
        );
        if ($row['value'] != null) {
            return $row['value'];
        } else {
            return null;
        }
    }

    public function configurationNameCreate($name, $value)
    {
        return Db::getInstance()->execute(
            'INSERT INTO `' . _DB_PREFIX_ . 'genei_configuration` (
            `name`,`value`,`date_add`,`date_upd`)
            VALUES (\'' . pSQL($name) . '\', \'' . pSQL($value) . '\', \''
                . pSQL(date('Y-m-d H:i:s')) . '\', \'' . pSQL(date('Y-m-d H:i:s')) . '\');'
        );
    }
}
