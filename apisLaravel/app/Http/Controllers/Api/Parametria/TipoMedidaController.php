<?php

namespace App\Http\Controllers\Api\Parametria;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;
class TipoMedidaController extends Controller
{
    public function SPL_TipoMedida() {
        // Ejecutar el procedimiento almacenado SPL_TipoMedida
        $resultados = DB::select('CALL SPL_TipoMedida()');

        // Verificar si el resultado está vacío
        if (empty($resultados)) {
            return response()->json([
                'Message' => 'Error al ejecutar el procedimiento almacenado',
                'Status' => 400,
            ], 400);
        }

        // Devolver los resultados como respuesta
        return response()->json([
            'Message' => 'OK',
            'Status' => 200,
            'TipoMedidas' => $resultados,
        ], 200);
    }
}
