import { Component, OnInit, Input, TemplateRef } from '@angular/core';
import { NgIfContext } from '@angular/common';
import { ModulosporrolService } from '../../../services/seguridad/modulosporrol.service';
import { ModulosPorRol } from '../../../models/seguridad/modulosporrol'
import { ModalDismissReasons, NgbModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { FormBuilder, FormGroup, Validators, FormControl, FormArray } from '@angular/forms';
import { Menu } from '../../../models/menu/menu';
import { ImagenService } from '../../../services/imagen/imagen.service';
import { AlertasService } from '../../../services/alertas/alertas.service';
import { TiporolService } from '../../../services/seguridad/tiporol.service';
import { TipoRol } from '../../../models/seguridad/TipoRol';
import { TipopermisoService } from '../../../services/parametria/tipopermiso.service';
import { TipoPermiso } from '../../../models/parametria/tipopermiso';
import { TipomoduloService } from '../../../services/parametria/tipomodulo.service';
import { TipoModulo } from '../../../models/parametria/tipoModulo';
import { FormsModule } from '@angular/forms';
import { ValidacionErroresService } from '../../../services/validaciones/validacion-errores.service';

@Component({
  selector: 'app-rol',
  templateUrl: './rol.component.html',
  styleUrl: './rol.component.css'
})
export class RolComponent {
  @Input() menu: Menu;
  tituloModal: string;
  tituloBoton: string;
  itemGrilla: ModulosPorRol; // cada item de la tabla
  listaGrilla: ModulosPorRol[]; // tabla completa en donde se cargan los datos
  modalRef: NgbModalRef;
  formItemGrilla: FormGroup;
  formFiltro: FormGroup;
  Token: string;
  imgSubmenu: Menu;
  lTipoRol: TipoRol[];
  lTipoPermiso: TipoPermiso[];
  lTipoModulo: TipoModulo[];
  paginaActual = 1;
  elementosPorPagina = 10;
  loading: boolean = true;
  noData: TemplateRef<NgIfContext<boolean>>;


  constructor(private modulosPorRolService: ModulosporrolService,
    private tipoRolService: TiporolService,
    private tipoModuloService: TipomoduloService,
    private tipoPermisoService: TipopermisoService,
    private modalService: NgbModal,
    private formBuilder: FormBuilder,
    private imagenService: ImagenService,
    private alertasService: AlertasService,
    private ValidacionErroresService: ValidacionErroresService
  ) {}

  get fItemGrilla() { return this.formItemGrilla.controls; }

  ngOnInit(): void {
    this.obtenerImgMenu();
    this.obtenerListas();
    this.Token = localStorage.getItem('Token');
    this.formItemGrilla = this.formBuilder.group({
      tiporol: new FormControl('', [Validators.required]),
      tipomodulo: new FormControl('', [Validators.required]),
      tipopermiso: new FormControl('', [Validators.required])
    });

    this.formFiltro = this.formBuilder.group({
      idFiltroMostrar: new FormControl('1', [Validators.required]),
      idFiltroRoles: new FormControl('', [Validators.required])
    });

    this.listar(1, null);
    this.formFiltro.get('idFiltroMostrar').valueChanges.subscribe(value => {
      let rol = this.formFiltro.get('idFiltroRoles').value;
      if (rol == undefined || rol == '' || rol == null){
        rol = 0;
      }
      this.listar(value, rol);
    });
    this.formFiltro.get('idFiltroRoles').valueChanges.subscribe(value => {
      let filtro = this.formFiltro.get('idFiltroMostrar').value;
      this.listar(filtro, value);
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
    this.imagenService.getImagenSubMenu('/seguridad/rolmodulos').subscribe(data => {
      this.imgSubmenu = data.ImagenSubmenu[0];
    });
  }

  obtenerListas(){
    this.tipoRolService.listar(1).subscribe(data => {
      this.lTipoRol = data.TiposRol;
      });
    this.tipoPermisoService.listar().subscribe(data => {
      this.lTipoPermiso = data.TipoPermisos;
      });
    this.tipoModuloService.listar(1).subscribe(data => {
      this.lTipoModulo = data.TipoModulos;
      });
    }

  listar(TipoLista: number, TipoRol: number): void { // 1 habilitados, 2 inhabilitados y 3 todos
    this.loading = true;
    if (TipoRol == null){
      TipoRol = 0;
    }
    this.modulosPorRolService.listar(TipoLista, TipoRol).subscribe(
      response => {
        this.itemGrilla = new ModulosPorRol();
        this.listaGrilla = response.RolModulo || [];
        this.loading = false;
      },
      error => {
        this.alertasService.ErrorAlert('Error', 'Error al Cargar la lista.');
        this.loading = false;
      }
    );
  }

  openAgregar(content) {
    this.tituloModal = "Agregar";
    this.tituloBoton = "Agregar";
    this.itemGrilla = Object.assign({}, new ModulosPorRol());
    this.modalRef = this.modalService.open(content, { size: 'lg', centered: true });
    this.modalRef.result.then((result) => {
    }, (reason) => {
      if (reason === ModalDismissReasons.BACKDROP_CLICK || reason === ModalDismissReasons.ESC) {
        this.formItemGrilla.reset();
      }
    });
  }

  cerrarModal () {
    this.formItemGrilla.reset();
    this.modalRef.close();
  }

  openInhabilitar(contentInhabilitar, item: ModulosPorRol) {
    this.tituloModal = "Inhabilitar";
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(contentInhabilitar, { size: 'sm', centered: true });
  }

  openHabilitar(contentHabilitar, item: ModulosPorRol) {
    this.tituloModal = "Habilitar";
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(contentHabilitar, { size: 'sm', centered: true });
  }

  guardar(): void {
    this.loading = true;
    if (this.formItemGrilla.valid) {
      this.modulosPorRolService.agregar(this.itemGrilla, this.Token)
        .subscribe(response => {
          this.listar(1, 0);
          this.alertasService.OkAlert('OK', 'Se Agregó Correctamente');
          this.modalRef.close();
        }, error => {
          this.alertasService.ErrorAlert('Error', 'Error al agregar.');
          this.loading = false;
        })
    } else {
      this.alertasService.ErrorAlert('Error','Formulario no válido. Por favor, completa los campos requeridos.');
      this.formItemGrilla.markAllAsTouched(); // Marca todos los controles como tocados para mostrar errores
      this.loading = false;
    }
    } 

  inhabilitar(): void {
    this.loading = true;
    this.modulosPorRolService.inhabilitar(this.itemGrilla.IdRolModulo, this.Token)
      .subscribe(response => {
        this.listar(1, 0);
        this.alertasService.OkAlert('OK', 'Se Inhabilitó Correctamente');
        this.modalRef.close();
      }, response => {
        this.alertasService.ErrorAlert('Error', 'Error al Inhabilitarr.');
        this.loading = false;
      });
  }

  habilitar(): void {
    this.loading = true;
    this.modulosPorRolService.habilitar(this.itemGrilla, this.Token)
      .subscribe(response => {
        this.listar(1, 0);
        this.alertasService.OkAlert('OK', 'Se Habilitó Correctamente');
        this.modalRef.close();
      }, error => {
        this.alertasService.ErrorAlert('Error', 'Error al Habilitar.');
        this.loading = false;
      });
  }
  cambiarPagina(event): void {
    this.paginaActual = event;
  }
}