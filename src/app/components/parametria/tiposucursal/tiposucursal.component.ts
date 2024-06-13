import { Component, OnInit, Input, TemplateRef } from '@angular/core';
import { FormBuilder, FormGroup, Validators, FormControl, FormArray } from '@angular/forms';
import { Sucursales } from '../../../models/parametria/tiposucursal';
import { TiposucursalService } from '../../../services/parametria/tiposucursal.service';
import { TipodomicilioService } from '../../../services/parametria/tipodomicilio.service';
import { TipoDomicilios } from '../../../models/parametria/tipodomicilio';
import { Menu } from '../../../models/menu/menu';
import { ImagenService } from '../../../services/imagen/imagen.service';
import { AlertasService } from '../../../services/alertas/alertas.service';
import { NgIfContext } from '@angular/common';
import { ModalDismissReasons, NgbModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { ValidacionErroresService } from '../../../services/validaciones/validacion-errores.service';

@Component({
  selector: 'app-tiposucursal',
  templateUrl: './tiposucursal.component.html',
  styleUrl: './tiposucursal.component.css'
})
export class TiposucursalComponent {
  tituloModal: string;
  tituloBoton: string;
  itemGrilla: Sucursales; // cada item de la tabla
  listaGrilla: Sucursales[]; // tabla completa en donde se cargan los datos
  lTipoDomicilio: TipoDomicilios[];
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

  constructor(private tiposucursalService: TiposucursalService,
    private modalService: NgbModal,
    private formBuilder: FormBuilder,
    private imagenService: ImagenService,
    private alertasService: AlertasService,
    private ValidacionErroresService:ValidacionErroresService,
    private TipodomicilioService:TipodomicilioService
  ) {}
  
  ngOnInit(): void {
    this.obtenerImgMenu();
    this.Token = localStorage.getItem('Token');
    this.formItemGrilla = this.formBuilder.group({
      descripcion: new FormControl('', [Validators.required]),
      IdTipoDomicilio: new FormControl('', [Validators.required]),
      domicilio: new FormControl('', [Validators.required]),
      calle: new FormControl('', [Validators.required]),
      nro: new FormControl('', [Validators.required]),
      piso: new FormControl('', [Validators.required])
    });

    this.formFiltro = this.formBuilder.group({
      idFiltro: new FormControl('1', [Validators.required]),
      busqueda: new FormControl('') // Control de búsqueda
    });

    this.listar(1);
    this.obtenerListas();

    this.formFiltro.get('idFiltro').valueChanges.subscribe(value => {
      this.listar(value);
    });

    this.formFiltro.get('busqueda').valueChanges.subscribe(value => {
      this.Busqueda = value;
    });
  }
  obtenerImgMenu(){
    this.imagenService.getImagenSubMenu('/parametria/sucursal').subscribe(data => {
      this.imgSubmenu = data.ImagenSubmenu[0];
    });
  }
  listar(TipoLista: number): void { // 1 habilitados, 2 inhabilitados y 3 todos
    this.loading = true;
    this.tiposucursalService.listar(TipoLista).subscribe(
      response => {
        this.itemGrilla = new Sucursales();
        this.listaGrilla = response.Sucursales || [];
        this.loading = false;
      },
      error => {
        this.alertasService.ErrorAlert('Error', error.error.Message);
        this.loading = false;
      }
    );
  }

  obtenerListas(){
    this.TipodomicilioService.listar(1).subscribe(data => {
      this.lTipoDomicilio = data.TipoDomicilios;
      console.log(this.lTipoDomicilio);
    });
  }

  cambiarFiltro(): void {
    const filtro = this.formFiltro.get('idFiltro').value;
    this.listar(filtro);
  }

  openAgregar(content) {
    this.tituloModal = "Agregar";
    this.tituloBoton = "Agregar";
    this.itemGrilla = Object.assign({}, new Sucursales());
    this.modalRef = this.modalService.open(content, { size: 'md', centered: true });
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

  openEditar(content, item: Sucursales) {
    this.tituloModal = "Editar";
    this.tituloBoton = "Guardar";
    this.itemGrilla = Object.assign({}, item); // duplica el item para que no cambie por detras y modifiquemos este para enviar al back
    this.modalRef = this.modalService.open(content, { size: 'md', centered: true });
  }

  openInhabilitar(contentInhabilitar, item: Sucursales) {
    this.tituloModal = "Inhabilitar";
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(contentInhabilitar, { size: 'sm', centered: true });
  }



  guardar(): void {
    this.loading = true;
    if (this.formItemGrilla.valid) {
      if (this.itemGrilla.IdSucursal == null) {
        this.tiposucursalService.agregar(this.itemGrilla, this.Token)
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
        this.tiposucursalService.editar(this.itemGrilla, this.Token)
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
      this.alertasService.ErrorAlert('Error','Formulario no válido. Por favor, completa los campos requeridos.');
      this.formItemGrilla.markAllAsTouched(); // Marca todos los controles como tocados para mostrar errores
      this.loading = false;
    }
  }


  inhabilitar(): void {
    this.loading = true;
    this.tiposucursalService.inhabilitar(this.itemGrilla, this.Token)
      .subscribe(response => {
        this.listar(1);
        this.alertasService.OkAlert('OK', 'Se Inhabilitó Correctamente');
        this.modalRef.close();
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

  cerrarModal () {
    console.log('cerrando')
    this.formItemGrilla.reset();
    console.log(this.formItemGrilla)
    this.modalRef.close();
  }


}