<?php

namespace App\Http\Controllers\Api\Parametria;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;

class TipoDocumentacionController extends Controller
{
    public function SPL_TipoDocumentacion() {
        // Ejecutar el procedimiento almacenado SPL_TipoDocumentacion
        $resultados = DB::select('CALL SPL_TipoDocumentacion()');

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
            'TipoDocumentacion' => $resultados,
        ], 200);
    }
}
