import { Component, OnInit, Input, TemplateRef } from '@angular/core';
import { NgIfContext } from '@angular/common';
import { TipoRol } from '../../../models/seguridad/TipoRol';
import { ModalDismissReasons, NgbModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { TiporolService } from '../../../services/seguridad/tiporol.service';
import { Menu } from '../../../models/menu/menu';
import { FormBuilder, FormGroup, Validators, FormControl, FormArray } from '@angular/forms';
import { AlertasService } from '../../../services/alertas/alertas.service';
import { ImagenService } from '../../../services/imagen/imagen.service';
import { ValidacionErroresService } from '../../../services/validaciones/validacion-errores.service';

@Component({
  selector: 'app-tiporoles',
  templateUrl: './tiporoles.component.html',
  styleUrl: './tiporoles.component.css'
})
export class TiporolesComponent {
  @Input() menu: Menu;
  alerta: AlertasService;
  tituloModal: string;
  tituloBoton: string;
  itemGrilla: TipoRol; // cada item de la tabla
  listaGrilla: TipoRol[]; // tabla completa en donde se cargan los datos
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


  constructor(private TiporolService: TiporolService,
    private modalService: NgbModal,
    private formBuilder: FormBuilder,
    private imagenService: ImagenService,
    private alertasService: AlertasService,
    private ValidacionErroresService: ValidacionErroresService,
  ){

  }
  ngOnInit(): void {
    this.obtenerImgMenu()
    this.Token = localStorage.getItem('Token');
    this.formItemGrilla = this.formBuilder.group({
      Descripcion: new FormControl('', [Validators.required])
    });

    this.formFiltro = this.formBuilder.group({
      idFiltro: new FormControl('1', [Validators.required]),
      busqueda: new FormControl('') // Control de búsqueda
    });

    this.listar(1);

    this.formFiltro.get('idFiltro').valueChanges.subscribe(value => {
      this.listar(value);
    });

    this.formFiltro.get('busqueda').valueChanges.subscribe(value => {
      this.Busqueda = value;
    });

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
  
  obtenerImgMenu(){
    this.imagenService.getImagenSubMenu('/seguridad/tiporoles').subscribe(data => {
      this.imgSubmenu = data.ImagenSubmenu[0];
    });
  }

  listar(TipoLista: number): void { // 1 habilitados, 2 inhabilitados y 3 todos
    this.loading = true;
    this.TiporolService.listar(TipoLista).subscribe(
      response => {
        console.log('API response:', response);
        this.itemGrilla = new TipoRol();
        this.listaGrilla = response.TiposRol || [];
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
    this.itemGrilla = Object.assign({}, new TipoRol());
    this.modalRef = this.modalService.open(content, { size: 'sm', centered: true });

    this.modalRef.result.then((result) => {
    }, (reason) => {
      if (reason === ModalDismissReasons.BACKDROP_CLICK || reason === ModalDismissReasons.ESC) {
        console.log('BOTONDSDASDSA');
        this.formItemGrilla.reset();
      }
    });
  }

  cerrarModal () {
    this.formItemGrilla.reset();
    this.modalRef.close();
  }

  openEditar(content, item: TipoRol) {
    this.tituloModal = "Editar";
    this.tituloBoton = "Guardar";
    this.itemGrilla = Object.assign({}, item); // duplica el item para que no cambie por detras y modifiquemos este para enviar al back
    this.modalRef = this.modalService.open(content, { size: 'sm', centered: true });
  }

  openInhabilitar(contentInhabilitar, item: TipoRol) {
    this.tituloModal = "Inhabilitar";
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(contentInhabilitar, { size: 'sm', centered: true });
  }

  openHabilitar(contentHabilitar, item: TipoRol) {
    this.tituloModal = "Habilitar";
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(contentHabilitar, { size: 'sm', centered: true });
  }

  guardar(): void {
    this.loading = true;
    if (this.formItemGrilla.valid) {
      if (this.itemGrilla.IdTipoRol== null) {
        this.TiporolService.agregar(this.itemGrilla, this.Token)
          .subscribe(response => {
            this.listar(1);
            this.alertasService.OkAlert('OK', 'Se Agregó Correctamente');
            this.modalRef.close();
          }, error => {
            this.alertasService.ErrorAlert('Error', error.error.Message);
            this.loading = false;
          })
        }
      else{
        this.loading = true;
        this.TiporolService.editar(this.itemGrilla, this.Token)
        .subscribe(response => {
          this.listar(1);
          this.alertasService.OkAlert('OK', 'Se modificó Correctamente');
          this.modalRef.close();
        }, error => {
          this.alertasService.ErrorAlert('Error', error.error.Message);
          this.loading = false;
        })
      };
    } else {
      this.alertasService.ErrorAlert('Error','Formulario no válido. Por favor, completa los campos requeridos.');
      this.formItemGrilla.markAllAsTouched(); // Marca todos los controles como tocados para mostrar errores
      this.loading = false;
    }
  }

  inhabilitar(): void {
    this.loading = true;
    this.TiporolService.inhabilitar(this.itemGrilla, this.Token)
      .subscribe(response => {
        this.listar(1);
        this.alertasService.OkAlert('OK', 'Se inhabilitó Correctamente');
        this.modalRef.close();
      }, error => {
        this.alertasService.ErrorAlert('Error', error.error.Message);
        this.loading = false;
      });
  }

  habilitar(): void {
    this.loading = true;
    this.TiporolService.habilitar(this.itemGrilla, this.Token)
      .subscribe(response => {
        this.listar(2);
        this.alertasService.OkAlert('OK', 'Se habilitó Correctamente');
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
}