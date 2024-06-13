import { Component , OnInit, Input, TemplateRef } from '@angular/core';
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
import { NgIfContext } from '@angular/common';
import { ValidacionErroresService } from '../../../services/validaciones/validacion-errores.service';
import { localidadesPorProvService } from '../../../services/recursos/localidadesPorProv.service';
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
  paginaActual = 1;
  elementosPorPagina = 10;
  loading: boolean = true;
  personas: any[] = []; //para listar las personas
  lTipoPersona: TipoPersonas[];
  lTipoDomicilio:TipoDomicilios[];
  lProvincia: provincia[];
  lLocalidad: Localidad[];
  lTipoDocumentacion: TipoDocumentacion[];
  busquedaPersonal = "";
  noData: TemplateRef<NgIfContext<boolean>>;
  

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
    private TipodocumentacionService: TipodocumentacionService,
    private ValidacionErroresService: ValidacionErroresService,
    private localidadesPorProvService : localidadesPorProvService
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
      this.lLocalidad = data.Localidades;
    });
    this.ProvinciaService.listar(1).subscribe(data => {
      this.lProvincia = data.Provincias;
    });
    this.TipodocumentacionService.listar(1).subscribe(data => {
      this.lTipoDocumentacion = data.TipoDocumentacion;
    });

    this.formFiltro = this.formBuilder.group({
      idFiltro: new FormControl('1', [Validators.required]),
      busquedaPersonal: new FormControl('') // Control de búsqueda
    });

    this.formFiltro.get('busquedaPersonal').valueChanges.subscribe(value => {
      this.busquedaPersonal = value;
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

  obtenerLocalidadesPorProv(IdProvincia) {
    this.itemGrilla.IdLocalidad = undefined;
    this.localidadesPorProvService.listar(IdProvincia).subscribe(data => {
      this.lLocalidad = data.Localidades;
    });
  }

  obtenerImgMenu(){
    this.imagenService.getImagenSubMenu('/recursos/personal').subscribe(data => {
      this.imgSubmenu = data.ImagenSubmenu[0];
    });
  }  
  listar(TipoLista: number): void { // 1 habilitados, 2 inhabilitados y 3 todos
    this.loading = true;
    this.PersonalService.listar(TipoLista).subscribe(
      response => {
        console.log(response.Personal)
        this.itemGrilla = new Personal();
        this.listaGrilla = response.Personal || [];
        this.loading = false;
      },
      error => {
        console.error('Error al cargar personal:', error);
        this.loading = false;
      }

    );
    this.obtenerListas();
  }

  guardar(): void {
    this.loading = true;
    console.log(this.itemGrilla);
    if (this.itemGrilla.IdPersona == null) {

      this.PersonalService.agregarPersonal(this.itemGrilla,this.Token).subscribe(
        response => {
          this.alertasService.OkAlert('OK', 'Se Agregó Correctamente');
          this.listar(1);
          this.modalRef.close();
        },
        error => {
          this.alertasService.ErrorAlert('Error', error.error.Message);
          this.loading = false; // Asegúrate de manejar el caso de error
        }
      );
    } else {
      this.loading = true;
       this.PersonalService.editar(this.itemGrilla, this.Token).subscribe(
         response => {
           this.loading = false;
           this.listar(1);
           this.alertasService.OkAlert('OK', 'Se Modificó Correctamente');
           this.modalRef.close();
         },
         error => {
           this.alertasService.ErrorAlert('Error', error.error.Message);
           this.loading = false; // Asegúrate de manejar el caso de error
         }
      );
    }
  }

  inhabilitar(): void {
    this.loading = true;
    this.PersonalService.inhabilitar(this.itemGrilla , this.Token).subscribe(
      response => {
        this.listar(1);
        this.alertasService.OkAlert('OK', 'Se Inhabilitó Correctamente');
        this.modalRef.close();
      },
      response => {
        this.loading = false;
        this.alertasService.ErrorAlert('Error', response.error.Message);
      }
    );
  }
  habilitar(): void {
    this.loading = true;
    this.PersonalService.habilitar(this.itemGrilla,this.Token).subscribe(
      response => {
        this.listar(1);
        this.alertasService.OkAlert('OK', 'Se Habilitó Correctamente');
        this.modalRef.close();
      },
      error => {
        this.loading = false;
        this.alertasService.ErrorAlert('Error', error.error.Message);
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
    this.itemGrilla = Object.assign({}, new Personal());
    this.modalRef = this.modalService.open(content, { size: 'lg', centered: true });
  }

  openEditar(content, item: Personal) {
    console.log(item, 'editarsadsad');
    this.tituloModal = 'Editar';
    this.tituloBoton = 'Guardar';
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(content, { size: 'lg', centered: true });
  }

  openInhabilitar(contentInhabilitar, item: Personal) {
    this.tituloModal = 'Inhabilitar';
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(contentInhabilitar, { size: 'sm', centered: true });
  }

  openHabilitar(contentHabilitar, item: Personal) {
    console.log(item);
    this.tituloModal = 'Habilitar';
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(contentHabilitar, { size: 'sm', centered: true });
  }
  limpiarBusqueda(): void {
    this.formFiltro.get('busquedaPersonal').setValue('');
  }

  cambiarPagina(event): void {
    this.paginaActual = event;
  }

}