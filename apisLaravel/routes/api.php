<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

use App\Http\Controllers\Api\login\usuarioController;


Route::POST('/usuario',[usuarioController::class, 'spValidarUsuario']);
