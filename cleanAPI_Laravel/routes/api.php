<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

use App\Http\Controllers\Api\login\usuarioController;

use App\Http\Controllers\Api\menu\menuController;

use App\Http\Controllers\Api\sistemaApiController;

use App\Http\Controllers\Api\tiporolController;

use App\Http\Controllers\Api\rolModuloController;


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

//sistema apis
Route::get('/SP_SistemaAPIs',[sistemaApiController::class, 'SP_SistemaAPIs']);

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


//listar rol modulo
Route::get('/SPL_RolModulo',[rolModuloController::class, 'SPL_RolModulo']);

//agregar rol modulo
Route::post('/SPA_RolModulo',[rolModuloController::class, 'SPA_RolModulo']);

//borrar rol modulo
Route::delete('/SPB_RolModulo',[rolModuloController::class, 'SPB_RolModulo']);

//habilitar rol modulo
Route::put('/SPH_RolModulo',[rolModuloController::class, 'SPH_RolModulo']);
