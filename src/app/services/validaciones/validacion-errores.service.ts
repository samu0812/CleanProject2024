import { Injectable } from '@angular/core';
import { AbstractControl, FormGroup } from '@angular/forms';

@Injectable({
  providedIn: 'root'
})
export class ValidacionErroresService {

  // public  customPatterns = {
  //   numeric: /^\d+$/,
  //   // Agrega más expresiones regulares personalizadas aquí según sea necesario
  // };

  private validationMessages = {
    required: 'El campo {fieldName} es requerido.',
    email: 'El campo {fieldName} debe ser un email válido.',
    minlength: 'El campo {fieldName} debe tener al menos {requiredLength} caracteres.',
    maxlength: 'El campo {fieldName} debe tener como máximo {requiredLength} caracteres.',
    pattern: 'El formato del campo {fieldName} debe ser numérico.',
    // Puedes agregar más validaciones y sus mensajes aquí
  };

  private fieldNames = {
    Mail: 'Mail',
    RazonSocial: 'Razón Social',
    Telefono: 'Teléfono',
    FechaNacimiento: 'Fecha de Nacimiento',
    domicilio: 'Domicilio',
    tipoPersona: 'Tipo de Persona',
    Calle: 'Calle',
    Nro: 'Número de Calle',
    Piso: 'Piso',
    Localidad: 'Localidad',
    TipoDocumentacion: 'Tipo de Documentación',
    Documentacion: 'Documentación',
    Provincia: 'Provincia',
    listaProveedor: 'Lista de Proveedor',
    // Codigo: 'Codigo',
    // Nombre: 'Nombre',
    // Marca: 'Marca',
    PrecioCosto: 'Precio Costo',
    Tamano: 'Tamaño',
    CantMaxima: 'Cantidad Maxima',
    CantMinima: 'Cantidad Minima',
    tipoMedida: 'Tipo de Medida',
    tipoCategoria: 'Tipo de Categoria',
    tipoProducto: 'Tipo de Producto',
    TipoDomicilio: 'Tipo de Domicilio',
    // Agrega más campos aquí según sea necesario
  };

  constructor() { }

    getErrorMessage(control: AbstractControl, fieldName: string): string | null {
      if (!control || !control.errors) {
        return null;
      }
  
      for (const error in control.errors) {
        if (this.validationMessages[error]) {
          let errorMessage = this.validationMessages[error];
          errorMessage = errorMessage.replace('{fieldName}', this.fieldNames[fieldName] || fieldName);
  
          if (control.errors[error].requiredLength) {
            errorMessage = errorMessage.replace('{requiredLength}', control.errors[error].requiredLength.toString());
          }
          return errorMessage;
        }
      }
  
      return null;
    }
}

