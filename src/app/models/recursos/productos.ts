import { Validators, FormControl } from '@angular/forms';

export class Productos {
  public IdProducto: number;
  public IdTipoMedida: number;
  public TipoMedidaDescripcion: string;
  public IdTipoCategoria: number;
  public IdPersona: number;
  public CategoriaDescripcion: string;
  public IdTipoProducto: number;
  public TipoProductoDescripcion: string;
  public Codigo: string;
  public Nombre: string;
  public Marca: string;
  public PrecioCosto: number;
  public Tamano: number;
  public CantMaxima: number;
  public CantMinima: number;
  public FechaAlta: number;
  public FechaBaja: number;
  public RazonSocial: string;

  // Método para validar cada campo
  public static validarCampo(valor: any, validadores: any[]): FormControl {
    return new FormControl(valor, validadores);
  }

  public static obtenerValidadoresCampo(nombreCampo: string): any[] {
    switch (nombreCampo) {
      case 'Codigo':
        return [Validators.required, Validators.minLength(8), Validators.maxLength(45)];
      case 'Nombre':
        return [Validators.required, Validators.maxLength(45)];
      case 'Marca':
        return [Validators.required, Validators.maxLength(45)];
      case 'PrecioCosto':
      case 'Tamano':
      case 'CantMaxima':
      case 'CantMinima':
        return [Validators.required, Validators.min(0)];
      case 'tipoMedida':
      case 'tipoCategoria':
      case 'tipoProducto':
      case 'proveedor':
        return [Validators.required];
      default:
        return [];
    }
  }
  
  public static obtenerMensajeError(nombreCampo: string): string {
    switch (nombreCampo) {
      case 'Codigo':
        return 'El campo Código es requerido y debe tener al menos 8 caracteres.';
      case 'Nombre':
        return 'El campo Nombre es requerido y debe tener como máximo 45 caracteres.';
      case 'Marca':
        return 'El campo Marca es requerido y debe tener como máximo 45 caracteres.';
      case 'PrecioCosto':
      case 'Tamano':
      case 'CantMaxima':
      case 'CantMinima':
        return 'El campo debe ser un número mayor o igual a 0.';
      case 'tipoMedida':
      case 'tipoCategoria':
      case 'tipoProducto':
      case 'proveedor':
        return 'El campo es requerido.';
      default:
        return '';
    }
  }

  // Método para validar si un campo es inválido
  public static esCampoInvalido(control: FormControl): boolean {
    return control.invalid;
  }
}
