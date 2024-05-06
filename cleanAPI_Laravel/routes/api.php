<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

use App\Http\Controllers\Api\login\usuarioController;

use App\Http\Controllers\Api\menu\menuController;

use App\Http\Controllers\Api\sistemaApiController;


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
