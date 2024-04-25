<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

use App\Http\Controllers\Api\login\usuarioController;


Route::get('/usuario',[usuarioController::class, 'spValidarUsuario']);