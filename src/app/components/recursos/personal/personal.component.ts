import { Component , OnInit, Input } from '@angular/core';
import { Personal } from '../../../models/recursos/personal';
import { PersonalService } from '../../../services/recursos/personal.service';
import { NgbModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { FormBuilder, FormGroup, Validators, FormControl, FormArray } from '@angular/forms';
import { Menu } from '../../../models/menu/menu';
import { ImagenService } from '../../../services/imagen/imagen.service';
import { AlertasService } from '../../../services/alertas/alertas.service';
import { TipopersonaService } from '../../../services/parametria/tipopersona.service';
import { TipoPersonas } from '../../../models/parametria/tipopersona';
import { TipodomicilioService } from '../../../services/parametria/tipodomicilio.service';
import { TipoDomicilios } from '../../../models/parametria/tipodomicilio';
import { ProvinciaService } from '../../../services/parametria/provincia.service';
import { LocalidadService } from '../../../services/recursos/localidad.service';
import { provincia } from '../../../models/parametria/provincia';
import { Localidad } from '../../../models/recursos/localidad';
import { TipoDocumentacion } from '../../../models/parametria/tipodocumentacion';
import { TipodocumentacionService } from '../../../services/parametria/tipodocumentacion.service';
@Component({
  selector: 'app-personal',
  templateUrl: './personal.component.html',
  styleUrl: './personal.component.css'
})
export class PersonalComponent {
  @Input() menu: Menu;
  tituloModal: string;
  tituloBoton: string;
  itemGrilla: Personal; // cada item de la tabla
  listaGrilla: Personal[]; // tabla completa en donde se cargan los datos
  modalRef: NgbModalRef;
  formItemGrilla: FormGroup;
  formFiltro: FormGroup;
  Token: string;
  imgSubmenu: Menu;
  personas: any[] = []; //para listar las personas
  lTipoPersona: TipoPersonas[];
  lTipoDomicilio:TipoDomicilios[];
  lProvincia: provincia[];
  lLocalidad: Localidad[];
  lTipoDocumentacion: TipoDocumentacion[];

  constructor(
    private PersonalService: PersonalService,
    private modalService: NgbModal,
    private formBuilder: FormBuilder,
    private imagenService: ImagenService,
    private alertasService: AlertasService, // agregue las alertas
    private TipopersonaService: TipopersonaService,
    private TipodomicilioService: TipodomicilioService,
    private ProvinciaService: ProvinciaService,
    private LocalidadService: LocalidadService,
    private TipodocumentacionService: TipodocumentacionService
  ) {}

  async ngOnInit(): Promise<void> {
    this.obtenerImgMenu()

    this.Token = localStorage.getItem('Token');

    this.formItemGrilla = this.formBuilder.group({
      Nombre: new FormControl('', [Validators.required]),
      Apellido: new FormControl('', [Validators.required]),
      Mail: new FormControl('', [Validators.required]),
      Telefono: new FormControl('', [Validators.required]),
      FechaNacimiento: new FormControl('', [Validators.required]),
      domicilio: new FormControl('', [Validators.required]),
      tipoPersona: new FormControl('', [Validators.required]),
      Calle: new FormControl('', [Validators.required]),
      Nro: new FormControl('', [Validators.required]),
      Piso: new FormControl('', [Validators.required]),
      Localidad: new FormControl('', [Validators.required]),
      TipoDocumentacion: new FormControl('', [Validators.required]),
      Documentacion: new FormControl('', [Validators.required]),
      Provincia: new FormControl('', [Validators.required]),
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


    //llama a la api y trae la lista de personas
      this.obtenerListas();
  }

  obtenerListas(){
    this.TipopersonaService.listar(1).subscribe(data => {
      this.lTipoPersona = data.TipoPersonas;
    });
    this.TipodomicilioService.listar(1).subscribe(data => {
      this.lTipoDomicilio = data.TipoDomicilios;
    });
    this.LocalidadService.listar(1).subscribe(data => {
      this.lLocalidad = data.Personas;
      console.log(data.Personas)
    });
    this.ProvinciaService.listar(1).subscribe(data => {
      console.log(data.Personas)
      this.lProvincia = data.Personas;
    });
    this.TipodocumentacionService.listar(1).subscribe(data => {
      this.lTipoDocumentacion = data.TipoDocumentacion;
    });
  }

  obtenerImgMenu(){
    this.imagenService.getImagenSubMenu('/recursos/personal').subscribe(data => {
      this.imgSubmenu = data.ImagenSubmenu[0];
    });
  }  
  listar(TipoLista: number): void { // 1 habilitados, 2 inhabilitados y 3 todos
    this.PersonalService.listar(TipoLista).subscribe(
      response => {
        this.itemGrilla = new Personal();
        this.listaGrilla = response.Personal;
      },
      error => {
        console.error('Error al cargar personal:', error);
      }
    );
  }

  guardar(): void {
    // this.loading = true;
    console.log(this.itemGrilla);
    if (this.itemGrilla.IdPersona == null) {

      this.PersonalService.agregarPersonal(this.itemGrilla).subscribe(
        response => {
          //this.loading = false;
          this.listar(1);
          this.modalRef.close();
          this.alertasService.OkAlert('OK', 'Se Agregó Correctamente');

        },
        error => {
          this.alertasService.ErrorAlert('Error', error.error.Message);
          //this.loading = false; // Asegúrate de manejar el caso de error
        }
      );
    } else {
      // this.tipoCategoriaService.editar(this.itemGrilla, this.Token).subscribe(
      //   response => {
      //     this.loading = false;
      //     this.listar(1);
      //     this.alertasService.OkAlert('OK', 'Se Modificó Correctamente');
      //     this.modalRef.close();
      //   },
      //   error => {
      //     this.alertasService.ErrorAlert('Error', error.error.Message);
      //     this.loading = false; // Asegúrate de manejar el caso de error
      //   }
      // );
    }
  }

  cambiarFiltro(): void {
    const filtro = this.formFiltro.get('idFiltro').value;
    this.listar(filtro);
  }


  openAgregar(content) {
    this.tituloModal = "Agregar";
    this.tituloBoton = "Agregar";
    this.itemGrilla = Object.assign({}, new Personal());
    this.modalRef = this.modalService.open(content, { size: 'lg', centered: true });
  }

    // openEditar(content, item: Personal) {
    // this.tituloModal = "Editar";
    // this.tituloBoton = "Guardar";
    // this.personas[0].IdPersona = item.IdPersona
    // this.personas[0].NombrePersona = item.Nombre
    // this.itemGrilla = Object.assign({}, item); 
    // this.itemGrilla.listaPersonal = this.personas[0].NombrePersona
    // this.formItemGrilla.patchValue({
    // listaPersonal: this.itemGrilla.listaPersonal
    // });
    // this.modalRef = this.modalService.open(content, { size: 'sm', centered: true });
    // }

  openInhabilitar(contentInhabilitar, item: Personal) {
    this.tituloModal = "Inhabilitar";
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(contentInhabilitar, { size: 'sm', centered: true });
  }

  openHabilitar(contentHabilitar, item: Personal) {
    this.tituloModal = "Habilitar";
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(contentHabilitar, { size: 'sm', centered: true });
  }


// guardar(): void {

//   if (this.itemGrilla.IdPersona == null) {
//       const selectedPersonaId = this.formItemGrilla.get('listaPersonal').value;
//       this.itemGrilla.IdPersona = selectedPersonaId; // Asigna el ID de la persona seleccionada
//       this.PersonalService.agregar(this.itemGrilla , this.Token)
//         .subscribe(response => {
//           console.log('Usuario guardado exitosamente:', response);
//           this.alertasService.OkAlert('Éxito', 'Usuario creado exitosamente');
//           this.modalRef.close();
//           this.listar(1);
//         }, error => {
//           console.error('Error al agregar usuario:', error);
//           if (error.error && error.error.Message) {
//             this.alertasService.ErrorAlert('Error', error.error.Message);
//           } else {
//             this.alertasService.ErrorAlert('Error', 'Ocurrió un error al guardar el usuario');
//           }
//         });
//   } else {
//     console.log('editar');
    // Actualización del usuario existente (código comentado de ejemplo)
    // this.UsuarioService.editar(this.itemGrilla, this.Token)
    //   .subscribe(response => {
    //     this.listar(1);
    //     this.modalRef.close();
    //   }, error => {
    //     console.error('Error al modificar tipo de categoría:', error);
    //   });
//  }
}


// inhabilitar(): void {
//   // this.UsuarioService.inhabilitar(this.itemGrilla, this.Token)
//   //   .subscribe(response => {
//   //     this.listar(1);
//   //     this.modalRef.close();
//   //   }, error => {
//   //     console.error('Error al inhabilitar tipo de categoría:', error);
//   //   });
// }

// habilitar(): void {
//   // this.UsuarioService.habilitar(this.itemGrilla, this.Token)
//   //   .subscribe(response => {
//   //     this.listar(1);
//   //     this.modalRef.close();
//   //   }, error => {
//   //     console.error('Error al habilitar tipo de categoría:', error);
//   //   });
// }


// // fnObtenerUsuDesdeBearer(): Promise<void> {
// //   return new Promise((resolve, reject) => {
// //     this.UsuarioService.fnObtenerUsuDesdeBearer(this.Token).subscribe(
// //       response => {
// //         this.itemGrilla.IdUsuarioCarga = response.IdUsuario;
// //         console.log('fnObtenerUsuDesdeBearer response:', this.itemGrilla.IdUsuarioCarga);
// //         resolve();
// //       },
// //       error => {
// //         console.error('Error al obtener usuario desde Bearer:', error);
// //         reject(error);
// //       }
// //     );
// //   });
// // }

// }
