import { Component, OnInit, Input, TemplateRef } from '@angular/core';
import { FormBuilder, FormGroup, Validators, FormControl, FormArray } from '@angular/forms';
import { TipoProducto } from '../../../models/parametria/tipoproducto';
import { TipoproductoService } from '../../../services/parametria/tipoproducto.service';
import { Menu } from '../../../models/menu/menu';
import { ImagenService } from '../../../services/imagen/imagen.service';
import { AlertasService } from '../../../services/alertas/alertas.service';
import { NgIfContext } from '@angular/common';
import { ModalDismissReasons, NgbModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { ValidacionErroresService } from '../../../services/validaciones/validacion-errores.service';
@Component({
  selector: 'app-tipoproducto',
  templateUrl: './tipoproducto.component.html',
  styleUrl: './tipoproducto.component.css'
})

export class TipoproductoComponent {
  tituloModal: string;
  tituloBoton: string;
  itemGrilla: TipoProducto; // cada item de la tabla
  listaGrilla: TipoProducto[]; // tabla completa en donde se cargan los datos
  modalRef: NgbModalRef;
  formItemGrilla: FormGroup;
  formFiltro: FormGroup;
  Token: string;
  imgSubmenu: Menu;
  paginaActual = 1;
  elementosPorPagina = 10;
  loading: boolean = true;
  Busqueda = "";
  noData: TemplateRef<NgIfContext<boolean>>;

  constructor(private tipoproductoService: TipoproductoService,
    private modalService: NgbModal,
    private formBuilder: FormBuilder,
    private imagenService: ImagenService,
    private alertasService: AlertasService,
    private ValidacionErroresService: ValidacionErroresService
  ) { }

  ngOnInit(): void {
    this.obtenerImgMenu();
    this.Token = localStorage.getItem('Token');
    this.formItemGrilla = this.formBuilder.group({
      Detalle: new FormControl('', [Validators.required])
    });

    this.formFiltro = this.formBuilder.group({
      idFiltro: new FormControl('1', [Validators.required]),
      busqueda: new FormControl('') // Control de búsqueda
    });

    // Subscribe to valueChanges after initializing formFiltro
    this.formFiltro.get('idFiltro').valueChanges.subscribe(value => {
      this.listar(value);
    });

    this.listar(1);

    // You don't need to subscribe to idFiltro changes again here
    this.formFiltro.get('busqueda').valueChanges.subscribe(value => {
      this.Busqueda = value;
    });
  }

  obtenerImgMenu() {
    this.imagenService.getImagenSubMenu('/parametria/tipoproducto').subscribe(data => {
      this.imgSubmenu = data.ImagenSubmenu[0];
    });
  }

  listar(TipoLista: number): void { // 1 habilitados, 2 inhabilitados y 3 todos
    this.loading = true;
    this.tipoproductoService.listar(TipoLista).subscribe(
      response => {
        this.itemGrilla = new TipoProducto();
        this.listaGrilla = response.TipoProducto || [];
        this.loading = false;
      },
      error => {
        this.alertasService.ErrorAlert('Error', error.error.Message);
        this.loading = false;
      }
    );
  }

  cambiarFiltro(): void {
    const filtro = this.formFiltro.get('idFiltro').value;
    this.listar(filtro);
  }

  openAgregar(content) {
    this.tituloModal = "Agregar";
    this.tituloBoton = "Agregar";
    this.itemGrilla = Object.assign({}, new TipoProducto());
    this.modalRef = this.modalService.open(content, { size: 'sm', centered: true });
    this.modalRef.result.then((result) => {
      console.log(result, 'BOTON');
      if (result === 'Cancelar') {
        this.formItemGrilla.reset();
      }
    }, (reason) => {
      if (reason === ModalDismissReasons.BACKDROP_CLICK || reason === ModalDismissReasons.ESC) {
        console.log('BOTONDSDASDSA');
        this.formItemGrilla.reset();
      }
    });
  }

  openEditar(content, item: TipoProducto) {
    this.tituloModal = "Editar";
    this.tituloBoton = "Guardar";
    this.itemGrilla = Object.assign({}, item); // duplica el item para que no cambie por detras y modifiquemos este para enviar al back
    this.modalRef = this.modalService.open(content, { size: 'sm', centered: true });
  }

  openInhabilitar(contentInhabilitar, item: TipoProducto) {
    this.tituloModal = "Inhabilitar";
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(contentInhabilitar, { size: 'sm', centered: true });
  }

  openHabilitar(contentHabilitar, item: TipoProducto) {
    this.tituloModal = "Habilitar";
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(contentHabilitar, { size: 'sm', centered: true });
  }

  guardar(): void {
    this.loading = true;
    if (this.formItemGrilla.valid) {
      if (this.itemGrilla.IdTipoProducto == null) {
        this.tipoproductoService.agregar(this.itemGrilla, this.Token)
          .subscribe(response => {
            this.listar(1);
            this.alertasService.OkAlert('OK', 'Se Agrego Correctamente');
            this.modalRef.close();
            this.loading = false;
          }, error => {
            this.alertasService.ErrorAlert('Error', error.error.Message);
            this.loading = false;
          })
      }
      else {
        this.loading = true;
        this.tipoproductoService.editar(this.itemGrilla, this.Token)
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
      // console.log('El formulario no es válido:', this.obtenerErroresDeCampos()); //
      this.alertasService.ErrorAlert('Error', 'Formulario no válido. Por favor, completa los campos requeridos.');
      this.formItemGrilla.markAllAsTouched(); // Marca todos los controles como tocados para mostrar errores
      this.loading = false;
    }
  }

  inhabilitar(): void {
    this.loading = true;
    this.tipoproductoService.inhabilitar(this.itemGrilla, this.Token)
      .subscribe(response => {
        this.listar(1);
        this.alertasService.OkAlert('OK', 'Se Inhabilitó Correctamente');
        this.modalRef.close();
        this.loading = false;
      }, error => {
        this.alertasService.ErrorAlert('Error', error.error.Message);
        this.loading = false;
      });
  }

  habilitar(): void {
    this.loading = true;
    this.tipoproductoService.habilitar(this.itemGrilla, this.Token)
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
    this.formFiltro.get('busqueda').setValue('');
  }
  cambiarPagina(event): void {
    this.paginaActual = event;
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

  cerrarModal() {
    console.log('cerrando')
    this.formItemGrilla.reset();
    console.log(this.formItemGrilla)
    this.modalRef.close();
  }

}
