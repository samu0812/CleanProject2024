import { Component, OnInit, Input } from '@angular/core';
import { ClienteService } from '../../../services/recursos/cliente.service';
import { cliente } from '../../../models/recursos/cliente';
import { NgbModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { FormBuilder, FormGroup, Validators, FormControl } from '@angular/forms';
import { Menu } from '../../../models/menu/menu';
import { ImagenService } from '../../../services/imagen/imagen.service';
import { AlertasService } from '../../../services/alertas/alertas.service';
import { TipopersonaService } from '../../../services/parametria/tipopersona.service';
import { TipoPersonas } from '../../../models/parametria/tipopersona';
import { TipodomicilioService } from '../../../services/parametria/tipodomicilio.service';
import { TipoDomicilios } from '../../../models/parametria/tipodomicilio';
import { TipodocumentacionService } from '../../../services/parametria/tipodocumentacion.service';
import { TipoDocumentacion } from '../../../models/parametria/tipodocumentacion';
import { Localidad } from '../../../models/seguridad/localidad';
import { LocalidadService } from '../../../services/recursos/localidad.service';
import { provincia } from '../../../models/parametria/provincia';
import { ProvinciaService } from '../../../services/parametria/provincia.service';

@Component({
  selector: 'app-clientes',
  templateUrl: './clientes.component.html',
  styleUrl: './clientes.component.css'
})
export class ClientesComponent implements OnInit {
  @Input() menu: Menu;
  tituloModal: string;
  tituloBoton: string;
  itemGrilla: cliente;
  listaGrilla: cliente[];
  modalRef: NgbModalRef;
  formItemGrilla: FormGroup;
  formFiltro: FormGroup;
  Token: string;
  imgSubmenu: Menu;
  paginaActual = 1;
  elementosPorPagina = 10;
  loading: boolean = true;
  lTipoPersona: TipoPersonas[];
  lTipoDomicilio: TipoDomicilios[];
  lTipoDocumentacion: TipoDocumentacion[];
  llocalidad: Localidad[];
  lprovincia: provincia[];
  constructor(
    private ClienteService: ClienteService,
    private modalService: NgbModal,
    private formBuilder: FormBuilder,
    private imagenService: ImagenService,
    private alertasService: AlertasService,
    private TipopersonaService: TipopersonaService,
    private TipodomicilioService: TipodomicilioService,
    private TipodocumentacionService: TipodocumentacionService,
    private LocalidadService: LocalidadService,
    private ProvinciaService: ProvinciaService,
  ) {}

  ngOnInit(): void {
    this.obtenerImgMenu();
    this.Token = localStorage.getItem('Token');
    this.formItemGrilla = this.formBuilder.group({
      TipoPersona: new FormControl('', [Validators.required]),
      TipoDomicilio: new FormControl('', [Validators.required]),
      Calle: new FormControl('', [Validators.required]),
      Nro: new FormControl('', [Validators.required]),
      Piso: new FormControl('', [Validators.required]),
      TipoDocumentacion: new FormControl('', [Validators.required]),
      Documentacion: new FormControl('', [Validators.required]),
      Nombre: new FormControl('', [Validators.required]),
      Apellido: new FormControl('', [Validators.required]),
      Mail: new FormControl('', [Validators.required]),
      RazonSocial: new FormControl('', [Validators.required]),
      FechaNacimiento: new FormControl('', [Validators.required]),
      Telefono: new FormControl('', [Validators.required]),
      Localidad: new FormControl('', [Validators.required]),
      Provincia: new FormControl('', [Validators.required]),
    });

    this.formFiltro = this.formBuilder.group({
      idFiltro: new FormControl('1', [Validators.required])
    });

    this.listar(1);

    this.formFiltro.get('idFiltro').valueChanges.subscribe(value => {
      this.listar(value);
    });
    this.obtenerListas();
  }
  obtenerListas(){
    this.TipopersonaService.listar(1).subscribe(data => {
      this.lTipoPersona = data.TipoPersonas;
    });
    this.TipodomicilioService.listar(1).subscribe(data => {
      this.lTipoDomicilio = data.TipoDomicilios;
    });
    this.TipodocumentacionService.listar(1).subscribe(data => {
      this.lTipoDocumentacion = data.TipoDocumentacion;
    });
    this.LocalidadService.listar(1).subscribe(data => {
      console.log(data.Localidades);
      this.llocalidad = data.Localidades;
    });
    this.ProvinciaService.listar(1).subscribe(data => {
      console.log(data.Provincias);
      this.lprovincia = data.Provincias;
    });
  }
  obtenerImgMenu() {
    this.imagenService.getImagenSubMenu('/recursos/clientes').subscribe(data => {
      this.imgSubmenu = data.ImagenSubmenu[0];
    });
  }

  listar(TipoLista: number): void {
    this.loading = true;
    this.ClienteService.listar(TipoLista).subscribe(
      response => {
        console.log(response.Clientes);
        this.itemGrilla = new cliente();
        this.listaGrilla = response.Clientes || [];
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
    //this.listar(filtro);
  }

  openAgregar(content) {
    this.tituloModal = 'Agregar';
    this.tituloBoton = 'Agregar';
    this.itemGrilla = Object.assign({}, new cliente());
    this.modalRef = this.modalService.open(content, { size: 'lg', centered: true });
  }

  openEditar(content, item: cliente) {
    console.log(item, 'editarsadsad');
    this.tituloModal = 'Editar';
    this.tituloBoton = 'Guardar';
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(content, { size: 'lg', centered: true });
  }

  openInhabilitar(contentInhabilitar, item: cliente) {
    this.tituloModal = 'Inhabilitar';
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(contentInhabilitar, { size: 'sm', centered: true });
  }

  openHabilitar(contentHabilitar, item: cliente) {
    console.log(item);
    this.tituloModal = 'Habilitar';
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(contentHabilitar, { size: 'sm', centered: true });
  }

  //falta agregar los seletc de provincias y localidades
  guardar(): void {
    this.loading = true;
    if (this.itemGrilla.IdCliente == null) {
      this.ClienteService.agregar(this.itemGrilla, this.Token).subscribe(
        response => {
          this.loading = false;
          this.listar(1);
          this.modalRef.close();
          this.alertasService.OkAlert('OK', 'Se Agregó Correctamente');
        },
        error => {
          console.log('Error', error.error.Message);
          this.alertasService.ErrorAlert('Error', error.error.Message);
          this.loading = false; // Asegúrate de manejar el caso de error
        }
      );
    } else {
      console.log(this.itemGrilla);
      this.ClienteService.editar(this.itemGrilla, this.Token).subscribe(
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
    // console.log(this.itemGrilla,'------' ,this.Token);
    this.loading = true;
    this.ClienteService.inhabilitar(this.itemGrilla , this.Token).subscribe(
      response => {
        this.listar(1);
        this.loading = false;
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
    // console.log(this.itemGrilla,'------' ,this.Token);
    this.loading = true;
    this.ClienteService.habilitar(this.itemGrilla, this.Token).subscribe(
      response => {
        this.listar(2);
        this.loading = false;
        this.alertasService.OkAlert('OK', 'Se Habilitó Correctamente');
        this.modalRef.close();
      },
      error => {
        this.loading = false;
        this.alertasService.ErrorAlert('Error', error.error.Message);
      }
    );
  }
  cambiarPagina(event): void {
    this.paginaActual = event;
  }

}
