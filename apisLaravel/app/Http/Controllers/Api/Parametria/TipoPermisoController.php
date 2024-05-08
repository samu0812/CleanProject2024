<?php

namespace App\Http\Controllers\Api\Parametria;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;

class TipoPermisoController extends Controller
{
    public function SPL_TipoPermiso() {
        // Ejecutar el procedimiento almacenado SPL_TipoPermiso
        $resultados = DB::select('CALL SPL_TipoPermiso()');

        // Verificar si el resultado está vacío
        if (empty($resultados)) {
            return response()->json([
                'message' => 'Error al ejecutar el procedimiento almacenado',
                'status' => 400,
            ], 400);
        }

        // Devolver los resultados como respuesta
        return response()->json([
            'message' => 'OK',
            'status' => 200,
            'TipoPermisos' => $resultados,
        ], 200);
    }
}
