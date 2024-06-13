import { Component, OnInit, Input, TemplateRef } from '@angular/core';
import { NgbModal, NgbModalRef , ModalDismissReasons} from '@ng-bootstrap/ng-bootstrap';
import { FormBuilder, FormGroup, Validators, FormControl, FormArray } from '@angular/forms';
import { Menu } from '../../../models/menu/menu';
import { ImagenService } from '../../../services/imagen/imagen.service';
import { AlertasService } from '../../../services/alertas/alertas.service';
import { Productos } from '../../../models/recursos/productos';
import { StockService } from '../../../services/recursos/stock.service';
import { TipoMedidas } from '../../../models/parametria/tipomedida';
import { TipomedidaService } from '../../../services/parametria/tipomedida.service';
import { TipoCategoria } from '../../../models/parametria/tipoCategoria';
import { TipoCategoriaService } from '../../../services/parametria/tipocategoria.service';
import { TipoProducto } from '../../../models/parametria/tipoproducto';
import { TipoproductoService } from '../../../services/parametria/tipoproducto.service';
import { Proveedor } from '../../../models/recursos/proveedor';
import { ProveedorService } from '../../../services/recursos/proveedor.service';
import { NgIfContext } from '@angular/common';
import { StockSucursal } from '../../../models/recursos/stockSucursal';
import { ValidacionErroresService } from '../../../services/validaciones/validacion-errores.service';
import { localidadesPorProvService } from '../../../services/recursos/localidadesPorProv.service';

@Component({
  selector: 'app-stock',
  templateUrl: './stock.component.html',
  styleUrl: './stock.component.css'
})
export class StockComponent {
  tituloModal: string;
  tituloBoton: string;
  itemGrilla: Productos; // cada item de la tabla
  listaGrilla: Productos[]; // tabla completa en donde se cargan los datos
  modalRef: NgbModalRef;
  formItemGrilla: FormGroup;
  formFiltro: FormGroup;
  Token: string;
  imgSubmenu: Menu;
  lTipoMedida: TipoMedidas[];
  lTipoCategoria: TipoCategoria[];
  lTipoProducto: TipoProducto[];
  lProveedor: Proveedor[];
  paginaActual = 1;
  elementosPorPagina = 10;
  loading: boolean = true;
  busquedastock = "";
  noData: TemplateRef<NgIfContext<boolean>>;
  tiposAumento: any[] = [];
  aumentosProducto: any[] = [];
  aumentos: any[] = [];
  columns: any[][];
  StockSucursal:StockSucursal;
  cantidad: number;
  selectedRows: any[] = [];
  aumentoExtra: number = 0;  // Variable para el input de aumento extra

  constructor(private stockService: StockService,
    private modalService: NgbModal,
    private formBuilder: FormBuilder,
    private imagenService: ImagenService,
    private alertasService: AlertasService,
    private tipomedidaService: TipomedidaService,
    private tipoCategoriaService: TipoCategoriaService,
    private tipoproductoService: TipoproductoService,
    private proveedorService: ProveedorService,
    private ValidacionErroresService: ValidacionErroresService,
    private localidadesPorProvService : localidadesPorProvService
  ) {}
  
  ngOnInit(): void {
    this.obtenerImgMenu()
    this.Token = localStorage.getItem('Token');
    this.formItemGrilla = this.formBuilder.group({
      Codigo: new FormControl('', [Validators.required, Validators.minLength(8), Validators.maxLength(45)]),
      Nombre: new FormControl('', [Validators.required, Validators.maxLength(45)]),
      Marca: new FormControl('', [Validators.required, Validators.maxLength(45)]),
      PrecioCosto: new FormControl('', [Validators.required, Validators.pattern(/^\d+(\.\d+)?$/)]),
      Tamano: new FormControl('', [Validators.required, Validators.pattern(/^\d+(\.\d+)?$/)]),
      CantMaxima: new FormControl('', [Validators.required, Validators.pattern(/^\d+$/)]),
      CantMinima: new FormControl('', [Validators.required, Validators.pattern(/^\d+$/)]),
      tipoMedida: new FormControl('', [Validators.required]),
      tipoCategoria: new FormControl('', [Validators.required]),
      tipoProducto: new FormControl('', [Validators.required]),
      proveedor: new FormControl('', [Validators.required,Validators.maxLength(45)]),
      
    });

    this.formFiltro = this.formBuilder.group({
      idFiltro: new FormControl('1', [Validators.required]),
      busquedastock: new FormControl('') // Control de búsqueda
    });

    this.listar(1);

    this.formFiltro.get('idFiltro').valueChanges.subscribe(value => {
      this.listar(value);
    });

    this.formFiltro.get('busquedastock').valueChanges.subscribe(value => {
      this.busquedastock = value;
    });

    this.obtenerListas();
  }

  cerrarModal () {
    this.formItemGrilla.reset();
    this.modalRef.close();
  }


  isFieldTouched(fieldName: string): boolean {
    const field = this.formItemGrilla.get(fieldName);
    return field.touched || field.dirty;
  }

  isFieldInvalid(fieldName: string): boolean {
    const field = this.formItemGrilla.get(fieldName);
    return field.invalid && (field.touched || field.dirty);
  }

  getErrorMessage(fieldName: string): string | null {
    const field = this.formItemGrilla.get(fieldName);
    return this.ValidacionErroresService.getErrorMessage(field, fieldName);
  }

  toggleSelection(item: any): void {
    const index = this.selectedRows.findIndex(row => row.IdProducto === item.IdProducto);
  
    if (index === -1) {
      // Añadir a la lista de selección solo si no está seleccionado y no está inhabilitado
      if (item.FechaBaja === null) {
        this.selectedRows.push(item);
      }
    } else {
      // Quitar de la lista de selección si ya está seleccionado
      this.selectedRows.splice(index, 1);
    }
  }

  isSelected(item: any): boolean {
    return this.selectedRows.includes(item);
  }
  obtenerListas(){
    this.tipoCategoriaService.listar(1).subscribe(data => {
      this.lTipoCategoria = data.TipoCategoria;
    });
    this.tipomedidaService.listar(1).subscribe(data => {
      this.lTipoMedida = data.TipoMedidas;
    });
    this.tipoproductoService.listar(1).subscribe(data => {
      this.lTipoProducto = data.TipoProducto;
    });
    this.proveedorService.listar(1).subscribe(data => {
      this.lProveedor = data.Proveedores;
    });
  }
  
  obtenerImgMenu(){
    this.imagenService.getImagenSubMenu('/recursos/inventario').subscribe(data => {
      this.imgSubmenu = data.ImagenSubmenu[0];
    });
  }

  listar(TipoLista: number): void { // 1 habilitados, 2 inhabilitados y 3 todos
    this.loading = true;
    this.stockService.listar(TipoLista).subscribe(
      response => {
        this.itemGrilla = new Productos();
        this.listaGrilla = response.Productos || [];
        this.loading = false;
      },
      error => {
        this.alertasService.ErrorAlert('Error', error.error.message);
        this.loading = false;
      }
    );
  }

  cambiarFiltro(): void {
    const filtro = this.formFiltro.get('idFiltro').value;
    this.listar(filtro);
    this.selectedRows = []; // Limpiar selección al cambiar el filtro
  }

  openModal(content: TemplateRef<any>) {
    this.modalRef = this.modalService.open(content, { size: 'lg', centered: true });
  }



  openAgregar(content) {
    this.tituloModal = "Agregar";
    this.tituloBoton = "Agregar";
    this.itemGrilla = Object.assign({}, new Productos());
    this.modalRef = this.modalService.open(content, { size: 'lg', centered: true });

    this.modalRef.result.then((result) => {
      if (result === 'Cancelar') {
        this.formItemGrilla.reset();
      }
    }, (reason) => {
      if (reason === ModalDismissReasons.BACKDROP_CLICK || reason === ModalDismissReasons.ESC) {
        this.formItemGrilla.reset();
      }
    });
  }

  openEditar(content, item: Productos) {
    this.tituloModal = "Editar";
    this.tituloBoton = "Guardar";
    this.itemGrilla = Object.assign({}, item); // Duplica el item
    Object.keys(this.formItemGrilla.controls).forEach(controlName => {
      if (controlName !== 'PrecioCosto') {
        this.formItemGrilla.controls[controlName].disable();
      } else {
        this.formItemGrilla.controls[controlName].enable();
      }
    });
    this.modalRef = this.modalService.open(content, { size: 'lg', centered: true });
  }
  openAumentos(content: any, item: Productos): void {
    this.tituloModal = "Aumento";
    this.tituloBoton = "Guardar";
    this.itemGrilla = { ...item };

    // Obtener tipos de aumento
    this.stockService.obtenerTiposAumento().subscribe({
      next: (data) => {
        this.tiposAumento = data.TiposAumento.map(tipo => ({
          ...tipo,
          seleccionado: false
        }));
        this.columns = this.getColumns(this.tiposAumento);

        // Obtener aumentos actuales del producto
        this.stockService.getAumentosPorProducto(this.itemGrilla!.IdProducto).subscribe({
          next: (response) => {
            // Verificamos que response.Aumentos es un array
            if (Array.isArray(response.Aumentos)) {
              this.aumentosProducto = response.Aumentos;
              // Marcar los tipos de aumento que ya están asignados
              this.tiposAumento.forEach(tipo => {
                const aumento = this.aumentosProducto.find(a => a.IdTipoAumento === tipo.IdTipoAumento);
                if (aumento) tipo.seleccionado = true;
              });
            } else {
              console.error('Datos de aumentos no es un array:', response.Aumentos);
            }
          },
          error: (error) => {
            console.error('Error al obtener aumentos del producto', error);
          }
        });
      },
      error: (error) => {
        console.error('Error al obtener tipos de aumento', error);
      }
    });

    this.modalRef = this.modalService.open(content, { size: 'lg', centered: true });
  }

  openCantidad(content: any, item): void {
    this.tituloModal = "Cantidad";
    this.tituloBoton = "Guardar";
    this.itemGrilla = item;
    this.cantidad = 0;
    this.modalRef = this.modalService.open(content, { size: 'md', centered: true });
  }
  
  guardarStock(): void {
    if (this.cantidad <= 0) {
      this.alertasService.ErrorAlert('Error', 'La cantidad debe ser mayor que cero.');
      return;
    }
    const idProducto = this.itemGrilla.IdProducto;
    this.stockService.AgregarStock(idProducto, this.cantidad, this.Token).subscribe(
      response => {
        this.alertasService.OkAlert('Éxito', 'Stock agregado correctamente.');
        this.modalRef.close();
        
      },
      error => {
        this.alertasService.ErrorAlert('Error', error.error.message);
      }
    );
  }

  getColumns(tipos: any[]): any[][] {
    const columns = [];
    let currentColumn = [];
    for (let i = 0; i < tipos.length; i++) {
      currentColumn.push(tipos[i]);
      if ((i + 1) % 4 === 0 || i === tipos.length - 1) {
        columns.push(currentColumn);
        currentColumn = [];
      }
    }
    return columns;
  }

  guardarAumentos() {
    const payload = {
        IdProducto: this.itemGrilla.IdProducto,
        Aumentos: this.tiposAumento.filter(tipo => tipo.seleccionado).map(tipo => ({ IdTipoAumento: tipo.IdTipoAumento })),
        AumentoExtra: this.aumentoExtra,
        Token: this.Token
    };
    this.stockService.guardarAumentosProducto(payload).subscribe(
        response => {
            this.alertasService.OkAlert('Éxito', 'Aumentos guardados correctamente.');
            this.modalRef.close();
            this.loading = false;
        },
        error => {
            this.alertasService.ErrorAlert('Error', 'Error al guardar aumentos.');
            this.loading = false;
        }
    );
}

  openInhabilitar(contentInhabilitar, item: Productos) {
    this.tituloModal = "Inhabilitar";
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(contentInhabilitar, { size: 'md', centered: true });
  }

  openHabilitar(contentHabilitar, item: Productos) {
    this.tituloModal = "Habilitar";
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(contentHabilitar, { size: 'md', centered: true });
  }

  guardar(): void {
    this.loading = true;
    if (this.formItemGrilla.valid) {
      if (this.itemGrilla.IdProducto == null) {
        this.stockService.agregar(this.itemGrilla, this.Token)
          .subscribe(response => {
            this.listar(1);
            this.alertasService.OkAlert('OK', 'Se Agregó Correctamente');
            this.modalRef.close();
            this.loading = false;
          }, error => {
            this.alertasService.ErrorAlert('Error', error.error.Message);
            this.loading = false;
          })
        }
      else{
        this.loading = true;
        this.stockService.editar(this.itemGrilla, this.Token)
        .subscribe(response => {
          this.listar(1);
          this.alertasService.OkAlert('OK', 'Se Modificó Correctamente');
          this.modalRef.close();
          this.loading = false;
        }, error => {
          this.alertasService.ErrorAlert('Error', error.error.Message);
          this.loading = false;
        })
      };
    }
    else {
      this.alertasService.ErrorAlert('Error','Formulario no válido. Por favor, completa los campos requeridos.');
      this.formItemGrilla.markAllAsTouched(); // Marca todos los controles como tocados para mostrar errores
      this.loading = false;
    }
  }
  

  inhabilitar(): void {
    this.loading = true;
    this.stockService.inhabilitar(this.itemGrilla, this.Token)
      .subscribe(response => {
        this.listar(1);
        this.alertasService.OkAlert('OK', 'Se Inhabilitó Correctamente');
        this.modalRef.close();
        this.loading = false;
      }, response => {
        this.alertasService.ErrorAlert('Error', response.error.Message);
        this.loading = false;
      });
  }

  habilitar(): void {
    this.loading = true;
    this.stockService.habilitar(this.itemGrilla, this.Token)
      .subscribe(response => {
        this.listar(2);
        this.alertasService.OkAlert('OK', 'Se Habilitó Correctamente');
        this.modalRef.close();
        this.loading = false;
      }, error => {
        this.alertasService.ErrorAlert('Error', error.error.Message);
        this.loading = false;
      });
  }
  limpiarBusqueda(): void {
    this.formFiltro.get('busquedastock').setValue('');
  }
  cambiarPagina(event): void {
    this.paginaActual = event;
  }

  updatePrices() {
    this.selectedRows = [...this.selectedRows];  // Trigger change detection
  }
  calculateNewPrice(precioCosto: number): number {
    return precioCosto * (1 + (this.aumentoExtra || 0) / 100);
  }

  guardarAumentoStock() {

    if (this.aumentoExtra <= 0) {
      this.alertasService.ErrorAlert('Error', 'El aumento extra debe ser mayor a 0');
      return;
    }

    const productosConAumento = this.selectedRows.map(item => ({
      IdProducto: item.IdProducto,
      PrecioCosto: item.PrecioCosto
    }));

    this.stockService.AumentoEnMasa(productosConAumento, this.aumentoExtra, this.Token)
        .subscribe(response => {
        this.listar(1);
        this.alertasService.OkAlert('OK', 'Se Aumento los Precios Correctamente');
        this.modalRef.close();
        this.loading = false;
        this.resetModalValues();
      }, error => {
        this.alertasService.ErrorAlert('Error', error.error.Message);
        this.loading = false;
      });
  }
  resetModalValues() {
    this.selectedRows = [];
    this.aumentoExtra = 0;
  }

}