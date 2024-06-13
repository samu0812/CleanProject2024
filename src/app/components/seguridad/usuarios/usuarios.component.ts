import { Component, OnInit, Input, TemplateRef } from '@angular/core';
import { Usuario } from '../../../models/seguridad/Usuario';
import { UsuarioService } from '../../../services/seguridad/usuario.service';
import { ModalDismissReasons, NgbModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { FormBuilder, FormGroup, Validators, FormControl, FormArray } from '@angular/forms';
import { Menu } from '../../../models/menu/menu';
import { ImagenService } from '../../../services/imagen/imagen.service';
import { AlertasService } from '../../../services/alertas/alertas.service';
import { Sucursales } from '../../../models/parametria/tiposucursal';
import { TiposucursalService } from '../../../services/parametria/tiposucursal.service';
import { TipoRol } from '../../../models/seguridad/TipoRol';
import { TiporolService } from '../../../services/seguridad/tiporol.service';
import { NgIfContext } from '@angular/common';
import { ValidacionErroresService } from '../../../services/validaciones/validacion-errores.service';


@Component({
  selector: 'app-usuarios',
  templateUrl: './usuarios.component.html',
  styleUrl: './usuarios.component.css'
})
export class UsuariosComponent implements OnInit {
  @Input() menu: Menu;
  tituloModal: string;
  tituloBoton: string;
  itemGrilla: Usuario; // cada item de la tabla
  listaGrilla: Usuario[]; // tabla completa en donde se cargan los datos
  modalRef: NgbModalRef;
  formItemGrilla: FormGroup;
  formItemRol: FormGroup;
  formFiltro: FormGroup;
  Token: string;
  imgSubmenu: Menu;
  lPersonas: any[] = []; //para listar las personas
  lSucursales: Sucursales[]; //para listar las personas
  lRoles: TipoRol[]; //para listar las personas
  lRolesUsuario: any[] = [];
  rolesUsuario: Usuario;
  rol:TipoRol;
  paginaActual = 1;
  elementosPorPagina = 10;
  loading: boolean = true;
  busquedausuarios = "";
  noData: TemplateRef<NgIfContext<boolean>>;

  constructor(
    private UsuarioService: UsuarioService,
    private modalService: NgbModal,
    private formBuilder: FormBuilder,
    private imagenService: ImagenService,
    private tiposucursalService: TiposucursalService,
    private tiporolService: TiporolService,
    private alertasService: AlertasService, // agregue las alertas
    private ValidacionErroresService: ValidacionErroresService,
  ) { }

  async ngOnInit(): Promise<void> {
    this.obtenerImgMenu();
    this.Token = localStorage.getItem('Token');

    this.formItemGrilla = this.formBuilder.group({
      usuario: new FormControl('', [Validators.required]),
      clave: new FormControl('', [Validators.required]),
      sucursal: new FormControl('', [Validators.required]),
      rol: new FormControl('', [Validators.required]),
      listaPersonal: new FormControl('', [Validators.required])
    });

    this.formItemRol = this.formBuilder.group({
      usuario: new FormControl('', [Validators.required]),
      rol: new FormControl('', [Validators.required])
    });

    this.formFiltro = this.formBuilder.group({
      idFiltro: new FormControl('1', [Validators.required]),
      busquedausuarios: new FormControl('') // Control de búsqueda
    });

    this.listar(1);

    this.formFiltro.get('idFiltro').valueChanges.subscribe(value => {
      this.listar(value);
    });

    this.formFiltro.get('busquedausuarios').valueChanges.subscribe(value => {
      this.busquedausuarios = value;
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

  obtenerImgMenu() {
    this.imagenService.getImagenSubMenu('/seguridad/usuarios').subscribe(data => {
      this.imgSubmenu = data.ImagenSubmenu[0];
    });
  }
  listar(TipoLista: number): void { // 1 habilitados, 2 inhabilitados y 3 todos
    this.loading = true;
    this.UsuarioService.listar(TipoLista).subscribe(
      response => {
        this.itemGrilla = new Usuario();
        this.listaGrilla = response.Usuarios;
        this.loading = false;
      },
      error => {
        this.alertasService.ErrorAlert('Error', error.error.message);
        this.loading = false;
      }
    );
    //llama a la api y trae la lista de personas
    this.UsuarioService.listarPersonas().subscribe(
      data => {
        this.lPersonas = data.Personas;
        this.loading = false;
      },
      error => {
        console.error('Error fetching personas', error);
      });
    this.tiposucursalService.listar(1).subscribe(data => {
      this.lSucursales = data.Sucursales;
      this.loading = false;
    });
    this.tiporolService.listar(1).subscribe(data => {
      this.lRoles = data.TiposRol;
      this.loading = false;
    });
  }
  cambiarFiltro(): void {
    const filtro = this.formFiltro.get('idFiltro').value;
    this.listar(filtro);
  }

  agregarRol() {
    this.loading = true;
    const rolSeleccionado = this.formItemRol.get('rol').value;
    this.rolesUsuario.IdTipoRol = rolSeleccionado;
    this.UsuarioService.agregarRolUsuario(this.rolesUsuario, this.Token)
    .subscribe(response => {
      this.alertasService.OkAlert('Éxito', 'Rol agregado exitosamente');
      this.getListaRoles(this.rolesUsuario.IdUsuario);
    }, error => {
      console.error('Error al agregar usuario:', error);
      if (error.error && error.error.Message) {
        this.alertasService.ErrorAlert('Error', error.error.Message);
        this.loading = false;
      } else {
        this.alertasService.ErrorAlert('Error', 'Ocurrió un error al guardar el usuario');
        this.loading = false;
      }
    });
  }

  eliminarRol(item: any) {
    this.loading = true;
    this.UsuarioService.eliminarUsuarioRol(item, this.Token)
    .subscribe(response => {
      this.alertasService.OkAlert('Éxito', 'Rol eliminado exitosamente');
      this.getListaRoles(this.rolesUsuario.IdUsuario);
    }, error => {
      if (error.error && error.error.Message) {
        this.alertasService.ErrorAlert('Error', error.error.Message);
        this.loading = false;
      } else {
        this.alertasService.ErrorAlert('Error', 'Ocurrió un error al guardar el usuario');
        this.loading = false;
      }
    });
  }
  openAgregar(content) {
    this.tituloModal = "Agregar";
    this.tituloBoton = "Agregar";
    this.itemGrilla = Object.assign({}, new Usuario());
    this.modalRef = this.modalService.open(content, { size: 'lg', centered: true });
    const selectSucursal = this.formItemGrilla.get('sucursal').value;
    const selectRol = this.formItemGrilla.get('rol').value;

    if (selectSucursal == null || selectSucursal == ''){
      this.formItemGrilla.get('sucursal').setValue(1);
    }

    if (selectRol == null || selectRol == ''){
      this.formItemGrilla.get('rol').setValue(1);
    }
    this.modalRef.result.then((result) => {
    }, (reason) => {
      if (reason === ModalDismissReasons.BACKDROP_CLICK || reason === ModalDismissReasons.ESC) {
        this.formItemGrilla.reset();
      }
    });
  }
  openEditar(content, item: Usuario) {
    this.tituloModal = "Editar";
    this.tituloBoton = "Guardar";
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(content, { size: 'sm', centered: true });
    const selectSucursal = this.formItemGrilla.get('sucursal').value;
    const selectRol = this.formItemGrilla.get('rol').value;

    if (selectSucursal == null || selectSucursal == ''){
      this.formItemGrilla.get('sucursal').setValue(1);
    }

    if (selectRol == null || selectRol == ''){
      this.formItemGrilla.get('rol').setValue(1);
    }

    this.modalRef.result.then((result) => {
    }, (reason) => {
      if (reason === ModalDismissReasons.BACKDROP_CLICK || reason === ModalDismissReasons.ESC) {
        this.formItemGrilla.reset();
      }
    });
  }
  openEditarSucursal(contentSucursal, item: Usuario) {
    this.tituloModal = "Editar Sucursal";
    this.tituloBoton = "Guardar";
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(contentSucursal, { size: 'sm', centered: true });
    const selectRol = this.formItemGrilla.get('rol').value;
    const selectListaPersonal = this.formItemGrilla.get('listaPersonal').value;

    if (selectRol == null || selectRol == ''){
      this.formItemGrilla.get('rol').setValue(1);
    }
    if (selectListaPersonal == null || selectListaPersonal == ''){
      this.formItemGrilla.get('listaPersonal').setValue(1);
    }

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

  modUsuarioSucursal(): void {
    this.loading = true;
    this.UsuarioService.modificarUsuarioSucursal(this.itemGrilla.IdUsuario, this.itemGrilla.IdSucursal, this.Token)
      .subscribe(response => {
        this.listar(1);
        this.alertasService.OkAlert('OK', 'Se Agregó Correctamente');
        this.modalRef.close();
      }, error => {
        this.alertasService.ErrorAlert('Error', error.error.Message);
        this.loading = false;
      });
  }

  getListaRoles(IdUsuario: number){
    this.UsuarioService.listarUsuariosRol(IdUsuario).subscribe(data => {
      this.lRolesUsuario = data.UsuariosPorRol;
      this.loading = false;
    });
  }

  openEditarRol(contentRol, item: Usuario) {
    this.tituloModal = "Editar Rol";
    this.tituloBoton = "Guardar";
    this.rolesUsuario = Object.assign({}, item);
    this.rol = Object.assign({}, new TipoRol());
    this.getListaRoles(this.rolesUsuario.IdUsuario);
    this.modalRef = this.modalService.open(contentRol, { size: 'lg', centered: true });
    const selectListaPersonal = this.formItemGrilla.get('listaPersonal').value;
    const selectSucursal = this.formItemGrilla.get('sucursal').value;

    if (selectListaPersonal == null || selectListaPersonal == ''){
      this.formItemGrilla.get('listaPersonal').setValue(1);
    }

    if (selectSucursal == null || selectSucursal == ''){
      this.formItemGrilla.get('sucursal').setValue(1);
    }

    this.modalRef.result.then((result) => {
    }, (reason) => {
      if (reason === ModalDismissReasons.BACKDROP_CLICK || reason === ModalDismissReasons.ESC) {
        console.log('BOTONDSDASDSA');
        this.formItemGrilla.reset();
      }
    });
  }
  openInhabilitar(contentInhabilitar, item: Usuario) {
    this.tituloModal = "Inhabilitar";
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(contentInhabilitar, { size: 'sm', centered: true });
  }

  guardar(): void {
    this.loading = true;

    const selectListaPersonal = this.formItemGrilla.get('listaPersonal').value;

    if (this.formItemGrilla.valid) {
      if (this.itemGrilla.IdUsuario == null) {
        this.itemGrilla.IdPersona = selectListaPersonal; // Asigna el ID de la persona seleccionada
        this.UsuarioService.agregar(this.itemGrilla, this.Token)
          .subscribe(response => {
            this.alertasService.OkAlert('Éxito', 'Usuario creado exitosamente');
            this.modalRef.close();
            this.listar(1);
          }, error => {
            if (error.error && error.error.Message) {
              this.alertasService.ErrorAlert('Error', error.error.Message);
              this.loading = false;
            } else {
              this.alertasService.ErrorAlert('Error', 'Ocurrió un error al guardar el usuario');
              this.loading = false;
            }
          });
      } else {
        this.loading = true;
        this.UsuarioService.editar(this.itemGrilla, this.Token)
          .subscribe(response => {
            this.listar(1);
            this.alertasService.OkAlert('Éxito', 'Usuario modificado exitosamente');
            this.modalRef.close();
          }, error => {
            if (error.error.Errors.NuevoUsuario) {
              this.alertasService.ErrorAlert('Error', error.error.Errors.NuevoUsuario);
              this.loading = false;
            }if (error.error.Errors.NuevaClave) {
              this.alertasService.ErrorAlert('Error', error.error.Errors.NuevaClave);
              this.loading = false;
            } else {
              this.alertasService.ErrorAlert('Error', 'Ocurrió un error al modificar el usuario');
              this.loading = false;
            }
          });
      }
    } else {
      this.alertasService.ErrorAlert('Error', 'Formulario Inválido');
      this.formItemGrilla.markAllAsTouched();
      this.loading = false;
    }
  }

  inhabilitar(): void {
    this.loading = true;
    this.UsuarioService.inhabilitar(this.itemGrilla, this.Token)
      .subscribe(response => {
        this.alertasService.OkAlert('Éxito', 'Usuario eliminado exitosamente');
          this.modalRef.close();
          this.listar(1);
      }, error => {
        if (error.error && error.error.Message) {
          this.alertasService.ErrorAlert('Error', error.error.Message);
          this.loading = false;
        } else {
          this.alertasService.ErrorAlert('Error', 'Ocurrió un error al eliminar el usuario');
          this.loading = false;
        }
      });
  }

  limpiarBusqueda(): void {
    this.formFiltro.get('busquedausuarios').setValue('');
  }
  cambiarPagina(event): void {
    this.paginaActual = event;
  }
}