<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Usuario extends Model
{
    protected $table = 'usuario'; // Nombre de la tabla en la base de datos

    protected $fillable = [
        'Usuario', // Nombre del campo 'Usuario' en la tabla
        'Clave', // Nombre del campo 'Clave' en la tabla
    ];

}