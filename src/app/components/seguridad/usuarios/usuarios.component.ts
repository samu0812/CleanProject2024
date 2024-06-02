import { Component , OnInit, Input } from '@angular/core';
import { Usuario } from '../../../models/seguridad/Usuario';
import { UsuarioService } from '../../../services/seguridad/usuario.service';
import { NgbModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { FormBuilder, FormGroup, Validators, FormControl, FormArray } from '@angular/forms';
import { Menu } from '../../../models/menu/menu';
import { ImagenService } from '../../../services/imagen/imagen.service';
import { AlertasService } from '../../../services/alertas/alertas.service';

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
  formFiltro: FormGroup;
  Token: string;
  imgSubmenu: Menu;
  personas: any[] = []; //para listar las personas

  constructor(
    private UsuarioService: UsuarioService,
    private modalService: NgbModal,
    private formBuilder: FormBuilder,
    private imagenService: ImagenService,
    private alertasService: AlertasService // agregue las alertas
  ) {}

  async ngOnInit(): Promise<void> {
    this.obtenerImgMenu()

    this.Token = localStorage.getItem('Token');

    this.formItemGrilla = this.formBuilder.group({
      usuario: new FormControl('', [Validators.required]),
      clave: new FormControl('', [Validators.required]),
      listaPersonal: new FormControl('', [Validators.required])
    });

    this.formFiltro = this.formBuilder.group({
      idFiltro: new FormControl('1', [Validators.required]) // Default value set to 1
    });

    this.listar(1); // Initially list only enabled items

    // Listen for changes in the filter and update the list accordingly
    this.formFiltro.get('idFiltro').valueChanges.subscribe(value => {
      this.listar(value);
    });
  }

  obtenerImgMenu(){
    this.imagenService.getImagenSubMenu('/seguridad/usuarios').subscribe(data => {
      this.imgSubmenu = data.ImagenSubmenu[0];
    });
  }
  listar(TipoLista: number): void { // 1 habilitados, 2 inhabilitados y 3 todos
    this.UsuarioService.listar(TipoLista).subscribe(
      response => {
        this.itemGrilla = new Usuario();
        this.listaGrilla = response.Usuarios;
      },
      error => {
        console.error('Error al cargar tipos de categoría:', error);
      }
    );
    //llama a la api y trae la lista de personas
    this.UsuarioService.listarPersonas().subscribe(
      data => {
        this.personas = data.Personas;
      },
      error => {
        console.error('Error fetching personas', error);
      });
  }
  cambiarFiltro(): void {
    const filtro = this.formFiltro.get('idFiltro').value;
    this.listar(filtro);
  }
  openAgregar(content) {
    this.tituloModal = "Agregar";
    this.tituloBoton = "Agregar";
    this.itemGrilla = Object.assign({}, new Usuario());
    this.modalRef = this.modalService.open(content, { size: 'lg', centered: true });
  }
  openEditar(content, item: Usuario) {
    this.tituloModal = "Editar";
    this.tituloBoton = "Guardar";
    this.personas[0].IdPersona = item.IdUsuario
    this.personas[0].NombrePersona = item.Usuario
    this.itemGrilla = Object.assign({}, item);
    this.itemGrilla.listaPersonal = this.personas[0].NombrePersona
    this.formItemGrilla.patchValue({
      listaPersonal: this.itemGrilla.listaPersonal
    });
    this.modalRef = this.modalService.open(content, { size: 'sm', centered: true });
  }
  openInhabilitar(contentInhabilitar, item: Usuario) {
    this.tituloModal = "Inhabilitar";
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(contentInhabilitar, { size: 'sm', centered: true });
  }
  openHabilitar(contentHabilitar, item: Usuario) {
    this.tituloModal = "Habilitar";
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(contentHabilitar, { size: 'sm', centered: true });
  }
  guardar(): void {

    if (this.itemGrilla.IdUsuario == null) {
        const selectedPersonaId = this.formItemGrilla.get('listaPersonal').value;
        this.itemGrilla.IdPersona = selectedPersonaId; // Asigna el ID de la persona seleccionada
        this.UsuarioService.agregar(this.itemGrilla , this.Token)
          .subscribe(response => {
            console.log('Usuario guardado exitosamente:', response);
            this.alertasService.OkAlert('Éxito', 'Usuario creado exitosamente');
            this.modalRef.close();
            this.listar(1);
          }, error => {
            console.error('Error al agregar usuario:', error);
            if (error.error && error.error.Message) {
              this.alertasService.ErrorAlert('Error', error.error.Message);
            } else {
              this.alertasService.ErrorAlert('Error', 'Ocurrió un error al guardar el usuario');
            }
          });
    } else {
      console.log('editar');
      // Actualización del usuario existente (código comentado de ejemplo)
      // this.UsuarioService.editar(this.itemGrilla, this.Token)
      //   .subscribe(response => {
      //     this.listar(1);
      //     this.modalRef.close();
      //   }, error => {
      //     console.error('Error al modificar tipo de categoría:', error);
      //   });
    }
  }
  inhabilitar(): void {
    // this.UsuarioService.inhabilitar(this.itemGrilla, this.Token)
    //   .subscribe(response => {
    //     this.listar(1);
    //     this.modalRef.close();
    //   }, error => {
    //     console.error('Error al inhabilitar tipo de categoría:', error);
    //   });
  }

  habilitar(): void {
    // this.UsuarioService.habilitar(this.itemGrilla, this.Token)
    //   .subscribe(response => {
    //     this.listar(1);
    //     this.modalRef.close();
    //   }, error => {
    //     console.error('Error al habilitar tipo de categoría:', error);
    //   });
  }
}
