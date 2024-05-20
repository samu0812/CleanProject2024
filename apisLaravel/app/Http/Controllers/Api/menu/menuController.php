<?php

namespace App\Http\Controllers\Api\menu;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;

class menuController extends Controller{
    public function SP_GetMenu(Request $request) {
        // Validar el token
        $validator = Validator::make($request->all(), [
            'Token' => 'required|string', // Puedes agregar reglas de validación adicionales según tus necesidades
        ]);

        // Si la validación falla, devolver la respuesta correspondiente
        if ($validator->fails()) {
            return response()->json([
                'Message' => 'Error en la validación del token',
                'Errors' => $validator->errors(),
                'Status' => 400,
            ], 400);
        }


        // Obtener el token de la solicitud
        $token = $request->input('Token');

        // Ejecutar el procedimiento almacenado SP_GetMenu
        $menues = DB::select('CALL SP_GetMenu(?)', [$token]);

        // Procesar los resultados del procedimiento almacenado según sea necesario
        // En este ejemplo, simplemente devolvemos los resultados como parte de la respuesta JSON
        return response()->json([
            'Message' => 'OK',
            'Status' => 200,
            'Menues' => $menues,
        ], 200);

    }

    public function SP_GetSubMenu (Request $request){
        // Validar los datos de entrada
        $validator = Validator::make($request->all(), [
            'Token' => 'required|string',
            'IdMenu' => 'required|integer',
        ]);


        // Si la validación falla, devolver la respuesta correspondiente
        if ($validator->fails()) {
            return response()->json([
                'Message' => 'Error en la validación de los datos',
                'Errors' => $validator->errors(),
                'Status' => 400,
            ], 400);
        }

        // Obtener el token y el ID del menú del cuerpo de la solicitud
        $token = $request->input('Token');
        $id_menu = $request->input('IdMenu');

        // Ejecutar el procedimiento almacenado y obtener los menús
        $subMenues = DB::select('CALL SP_GetSubMenu(?, ?)', [$token, $id_menu]);

        // Verificar si el resultado está vacío
        if (empty($subMenues)) {
            return response()->json([
                'Message' => 'Error al ejecutar el procedimiento almacenado',
                'Status' => 400,
            ], 400);
        }

        // Devolver los menús como respuesta
        return response()->json([
            'Message' => 'OK',
            'Status' => 200,
            'Menus' => $subMenues,
        ], 200);
    }

    public function SP_GetImagenSubMenu (Request $request) {

        // Validar los datos de entrada
        $validator = Validator::make($request->all(), [
            'Path' => 'required|string',
        ]);

        // Si la validación falla, devolver la respuesta correspondiente
        if ($validator->fails()) {
            return response()->json([
                'Message' => 'Error en la validación de los datos',
                'Errors' => $validator->errors(),
                'Status' => 400,
            ], 400);
        }

        // Obtener la ruta del submenú del cuerpo de la solicitud
        $path = $request->input('Path');

        // Ejecutar el procedimiento almacenado y obtener los detalles de la imagen del submenú
        $imagenSubMenu = DB::select('CALL SP_GetImagenSubMenu(?)', [$path]);

        // Verificar si el resultado está vacío
        if (empty($imagenSubMenu)) {
            return response()->json([
                'Message' => 'Error al ejecutar el procedimiento almacenado',
                'Status' => 400,
            ], 400);
        }

        // Devolver los detalles de la imagen del submenú como respuesta
        return response()->json([
            'Message' => 'OK',
            'Status' => 200,
            'ImagenSubmenu' => $imagenSubMenu,
        ], 200);
    }


    public function SP_GetMenuUsuario (Request $request) {
        // Validar los datos de entrada
        $validator = Validator::make($request->all(), [
            'IdPersona' => 'required|integer',
        ]);

        // Si la validación falla, devolver la respuesta correspondiente
        if ($validator->fails()) {
            return response()->json([
                'Message' => 'Error en la validación de los datos',
                'Errors' => $validator->errors(),
                'Status' => 400,
            ], 400);
        }

        // Obtener el ID del usuario del cuerpo de la solicitud
        $idPersona = $request->input('IdPersona');

        // Ejecutar el procedimiento almacenado y obtener los menús del usuario
        $menusUsuario = DB::select('CALL SP_GetMenuUsuario(?)', [$idPersona]);

        // Verificar si el conjunto de menús está vacío
        if (empty($menusUsuario)) {
            return response()->json([
                'Message' => 'El ID de persona no existe en el sistema',
                'Status' => 400,
            ], 400);
        }


        // Devolver los menús del usuario como respuesta
        return response()->json([
            'Message' => 'OK',
            'Status' => 200,
            'MenusUsuario' => $menusUsuario,
        ], 200);
    }





}