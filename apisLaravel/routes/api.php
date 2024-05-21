<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

//TODO--------------------------------------LOGIN, TOKENS , MENUES--------------------------------------------

use App\Http\Controllers\Api\login\usuarioController;

use App\Http\Controllers\Api\menu\menuController;


//CAMBIOOOOOOOOOOOOOOOOOOOOOOOOOO


//TODO--------------------------------------MODULO DE SEGURIDAD------------------------------------------------------

use App\Http\Controllers\Api\Seguridad\tiporolController;

use App\Http\Controllers\Api\Seguridad\rolModuloController;

use App\Http\Controllers\Api\Seguridad\sistemaApiController;

use App\Http\Controllers\Api\Seguridad\UsuariosController;

//TODO--------------------------------------MODULO DE PARAMETRIA------------------------------------------------------

use App\Http\Controllers\Api\Parametria\tipoPersonaController;

use App\Http\Controllers\Api\Parametria\TipoDocumentacionController;

use App\Http\Controllers\Api\Parametria\TipoMedidaController;

use App\Http\Controllers\Api\Parametria\TipoDomicilioController;

use App\Http\Controllers\Api\Parametria\TipoFacturaController;

use App\Http\Controllers\Api\Parametria\TipoDestinatarioFacturaController;

use App\Http\Controllers\Api\Parametria\TipoPermisoController;

use App\Http\Controllers\Api\Parametria\TipoPermisoDetalleController;

use App\Http\Controllers\Api\Parametria\TipoPersonaSistemaController;

use App\Http\Controllers\Api\Parametria\TipoProductoController;

use App\Http\Controllers\Api\Parametria\TipoCategoriaController;

use App\Http\Controllers\Api\Parametria\TipoImpuestoController;

use App\Http\Controllers\Api\Parametria\TipoFormaDePagoController;

//TODO--------------------------------------LOGIN, TOKENS , MENUES--------------------------------------------

//LOGIN Y TOKENS
Route::post('/usuario',[usuarioController::class, 'spValidarUsuario']);

//obtener usuario desde el token
Route::get('/fnObtenerUsuDesdeBearer',[usuarioController::class, 'fnObtenerUsuDesdeBearer']);

//menues
Route::get('/SP_GetMenu',[menuController::class, 'SP_GetMenu']);
//submenues
Route::get('/SP_GetSubMenu',[menuController::class, 'SP_GetSubMenu']);

//ImagenSubMenu
Route::get('/SP_GetImagenSubMenu',[menuController::class, 'SP_GetImagenSubMenu']);

//menu usuario
Route::get('/SP_GetMenuUsuario',[menuController::class, 'SP_GetMenuUsuario']);


//cambioooooooooooooooooooooooooooo
//TODO--------------------------------------MODULO DE SEGURIDAD------------------------------------------------------

//-------------------------SUBMODULO DE Usuarios-------------------------
//listar Usuarios
Route::get('/SPL_Usuarios',[UsuariosController::class, 'SPL_Usuarios']);

//agregar Usuarios 
Route::post('/SPA_Usuarios',[UsuariosController::class, 'SPA_Usuarios']);

//editar Usuarios
Route::put('/SPM_Usuarios',[UsuariosController::class, 'SPM_Usuarios']);

//borrar Usuarios
Route::delete('/SPB_Usuarios',[UsuariosController::class, 'SPB_Usuarios']);


//-------------------------SUBMODULO DE TipoRol-------------------------

//agregar tipo rol
Route::post('/SPA_TipoRol',[tiporolController::class, 'SPA_TipoRol']);

//modificar tipo rol
Route::put('/SPM_TipoRol',[tiporolController::class, 'SPM_TipoRol']);

//borrar tipo rol
Route::delete('/SPB_TipoRol',[tiporolController::class, 'SPB_TipoRol']);

//listar tipo rol
Route::get('/SPL_TipoRol',[tiporolController::class, 'SPL_TipoRol']);

//habilitar tipo rol
Route::put('/SPH_TipoRol',[tiporolController::class, 'SPH_TipoRol']);


//-------------------------SUBMODULO DE RolModulo-------------------------

//listar rol modulo
Route::get('/SPL_RolModulo',[rolModuloController::class, 'SPL_RolModulo']);

//agregar rol modulo
Route::post('/SPA_RolModulo',[rolModuloController::class, 'SPA_RolModulo']);

//borrar rol modulo
Route::delete('/SPB_RolModulo',[rolModuloController::class, 'SPB_RolModulo']);

//habilitar rol modulo
Route::put('/SPH_RolModulo',[rolModuloController::class, 'SPH_RolModulo']);


//-------------------------SUBMODULO DE SistemaAPIs-------------------------

//sistema apis
Route::get('/SP_SistemaAPIs',[sistemaApiController::class, 'SP_SistemaAPIs']);


//TODO--------------------------------------MODULO DE PARAMETRIA------------------------------------------------------

//-------------------------SUBMODULO DE TipoPersona-------------------------
//listar tipo persona
Route::get('/SPL_TipoPersona',[tipoPersonaController::class, 'SPL_TipoPersona']);

//-------------------------SUBMODULO DE TipoDocumentacion-------------------------
//listar tipo Documentacion
Route::get('/SPL_TipoDocumentacion',[TipoDocumentacionController::class, 'SPL_TipoDocumentacion']);

//-------------------------SUBMODULO DE TipoMedida-------------------------
//listar tipo Medida
Route::get('/SPL_TipoMedida',[TipoMedidaController::class, 'SPL_TipoMedida']);

//-------------------------SUBMODULO DE TipoDomicilio-------------------------
//listar tipo Domicilio
Route::get('/SPL_TipoDomicilio',[TipoDomicilioController::class, 'SPL_TipoDomicilio']);

//-------------------------SUBMODULO DE TipoFactura-------------------------
//listar tipo Factura
Route::get('/SPL_TipoFactura',[TipoFacturaController::class, 'SPL_TipoFactura']);

//-------------------------SUBMODULO DE TipoDestinatarioFactura-------------------------
//listar tipo DestinatarioFactura
Route::get('/SPL_TipoDestinatarioFactura',[TipoDestinatarioFacturaController::class, 'SPL_TipoDestinatarioFactura']);

//-------------------------SUBMODULO DE TipoTipoPermiso-------------------------
//listar tipo Permiso
Route::get('/SPL_TipoPermiso',[TipoPermisoController::class, 'SPL_TipoPermiso']);

//-------------------------SUBMODULO DE TipoPermisoDetalle-------------------------
//listar tipo PermisoDetalle
Route::get('/SPL_TipoPermisoDetalle',[TipoPermisoDetalleController::class, 'SPL_TipoPermisoDetalle']);

//-------------------------SUBMODULO DE TipoPersonaSistema-------------------------
//listar tipo PersonaSistema
Route::get('/SPL_TipoPersonaSistema',[TipoPersonaSistemaController::class, 'SPL_TipoPersonaSistema']);

//agregar tipo PersonaSistema
Route::post('/SPA_TipoPersonaSistema',[TipoPersonaSistemaController::class, 'SPA_TipoPersonaSistema']);

//editar tipo PersonaSistema
Route::put('/SPM_TipoPersonaSistema',[TipoPersonaSistemaController::class, 'SPM_TipoPersonaSistema']);

//borrar tipo PersonaSistema
Route::delete('/SPB_TipoPersonaSistema',[TipoPersonaSistemaController::class, 'SPB_TipoPersonaSistema']);

//habilitar tipo PersonaSistema
Route::put('/SPH_TipoPersonaSistema',[TipoPersonaSistemaController::class, 'SPH_TipoPersonaSistema']);

//-------------------------SUBMODULO DE TipoProducto-------------------------
//listar Tipo Producto
Route::get('/SPL_TipoProducto',[TipoProductoController::class, 'SPL_TipoProducto']);

//agregar Tipo Producto
Route::post('/SPA_TipoProducto',[TipoProductoController::class, 'SPA_TipoProducto']);

//editar Tipo Producto
Route::put('/SPM_TipoProducto',[TipoProductoController::class, 'SPM_TipoProducto']);

//borrar Tipo Producto
Route::delete('/SPB_TipoProducto',[TipoProductoController::class, 'SPB_TipoProducto']);

//habilitar Tipo Producto
Route::put('/SPH_TipoProducto',[TipoProductoController::class, 'SPH_TipoProducto']);

//-------------------------SUBMODULO DE TipoCategoria-------------------------
//listar Tipo Categoria
Route::get('/SPL_TipoCategoria',[TipoCategoriaController::class, 'SPL_TipoCategoria']);

//agregar Tipo Categoria
Route::post('/SPA_TipoCategoria',[TipoCategoriaController::class, 'SPA_TipoCategoria']);

//editar Tipo Categoria
Route::put('/SPM_TipoCategoria',[TipoCategoriaController::class, 'SPM_TipoCategoria']);

//borrar Tipo Categoria
Route::delete('/SPB_TipoCategoria',[TipoCategoriaController::class, 'SPB_TipoCategoria']);

//habilitar Tipo Categoria
Route::put('/SPH_TipoCategoria',[TipoCategoriaController::class, 'SPH_TipoCategoria']);

//-------------------------SUBMODULO DE TipoImpuesto-------------------------
//listar Tipo Impuesto
Route::get('/SPL_TipoImpuesto',[TipoImpuestoController::class, 'SPL_TipoImpuesto']);

//agregar Tipo Impuesto
Route::post('/SPA_TipoImpuesto',[TipoImpuestoController::class, 'SPA_TipoImpuesto']);

//editar Tipo Impuesto
Route::put('/SPM_TipoImpuesto',[TipoImpuestoController::class, 'SPM_TipoImpuesto']);

//borrar Tipo Impuesto
Route::delete('/SPB_TipoImpuesto',[TipoImpuestoController::class, 'SPB_TipoImpuesto']);

//habilitar Tipo Impuesto
Route::put('/SPH_TipoImpuesto',[TipoImpuestoController::class, 'SPH_TipoImpuesto']);

//-------------------------SUBMODULO DE FormaDePago-------------------------
//listar Tipo FormaDePago
Route::get('/SPL_TipoFormaDePago',[TipoFormaDePagoController::class, 'SPL_TipoFormaDePago']);

//agregar Tipo FormaDePago
Route::post('/SPA_TipoFormaDePago',[TipoFormaDePagoController::class, 'SPA_TipoFormaDePago']);

//editar Tipo FormaDePago
Route::put('/SPM_TipoFormaDePago',[TipoFormaDePagoController::class, 'SPM_TipoFormaDePago']);

//borrar Tipo FormaDePago
Route::delete('/SPB_TipoFormaDePago',[TipoFormaDePagoController::class, 'SPB_TipoFormaDePago']);

//habilitar Tipo FormaDePago
Route::put('/SPH_TipoFormaDePago',[TipoFormaDePagoController::class, 'SPH_TipoFormaDePago']);

//hasta aca anda todo

