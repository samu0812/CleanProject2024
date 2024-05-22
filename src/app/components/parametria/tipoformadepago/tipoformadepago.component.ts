import { Component, OnInit } from '@angular/core';
import { NgbModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { FormBuilder, FormGroup, Validators, FormControl } from '@angular/forms';
import { TipoFormaDePago } from '../../../models/parametria/tipoformadepago';
import { TipoformadepagoService } from './../../../services/parametria/tipoformadepago.service';
import { Menu } from '../../../models/menu/menu';
import { ImagenService } from '../../../services/imagen/imagen.service';
import { AlertasService } from '../../../services/alertas/alertas.service';

@Component({
  selector: 'app-tipoformadepago',
  templateUrl: './tipoformadepago.component.html',
  styleUrls: ['./tipoformadepago.component.css']
})
export class TipoformadepagoComponent implements OnInit {

  tituloModal: string;
  tituloBoton: string;
  itemGrilla: TipoFormaDePago; // cada item de la tabla
  listaGrilla: TipoFormaDePago[]; // tabla completa en donde se cargan los datos
  modalRef: NgbModalRef;
  formItemGrilla: FormGroup;
  formFiltro: FormGroup;
  Token: string;
  imgSubmenu: Menu;

  constructor(
    private tipoformadepagoService: TipoformadepagoService,
    private modalService: NgbModal,
    private formBuilder: FormBuilder,
    private imagenService: ImagenService,
    private alertasService: AlertasService
  ) {}

  ngOnInit(): void {
    this.obtenerImgMenu()
    this.Token = localStorage.getItem('Token');
    this.formItemGrilla = this.formBuilder.group({
      descripcion: new FormControl('', [Validators.required])
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
    this.imagenService.getImagenSubMenu('/parametria/tipoformadepago').subscribe(data => {
      this.imgSubmenu = data.ImagenSubmenu[0];
    });
  }


  listar(TipoLista: number): void { // 1 habilitados, 2 inhabilitados y 3 todos
    this.tipoformadepagoService.listar(TipoLista).subscribe(
      response => {
        this.itemGrilla = new TipoFormaDePago();
        this.listaGrilla = response.TipoFormaDePago || [];
      },
      error => {
        this.alertasService.ErrorAlert('Error', 'Error al Cargar la lista.');
      }
    );
  }

  cambiarFiltro(): void {
    const filtro = this.formFiltro.get('idFiltro').value;
    this.listar(filtro);
  }

  openAgregar(content) {
    this.tituloModal = 'Agregar';
    this.tituloBoton = 'Agregar';
    this.itemGrilla = Object.assign({}, new TipoFormaDePago());
    this.modalRef = this.modalService.open(content, { size: 'sm', centered: true });
  }

  openEditar(content, item: TipoFormaDePago) {
    this.tituloModal = 'Editar';
    this.tituloBoton = 'Guardar';
    this.itemGrilla = Object.assign({}, item); // duplica el item para que no cambie por detrás y modifiquemos este para enviar al back
    this.modalRef = this.modalService.open(content, { size: 'sm', centered: true });
  }

  openInhabilitar(contentInhabilitar, item: TipoFormaDePago) {
    this.tituloModal = 'Inhabilitar';
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(contentInhabilitar, { size: 'sm', centered: true });
  }

  openHabilitar(contentHabilitar, item: TipoFormaDePago) {
    this.tituloModal = 'Habilitar';
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(contentHabilitar, { size: 'sm', centered: true });
  }

  guardar(): void {
    if (this.itemGrilla.IdTipoFormaDePago == null) {
      this.tipoformadepagoService.agregar(this.itemGrilla, this.Token).subscribe(
        response => {
          this.listar(this.formFiltro.get('idFiltro').value);
          this.alertasService.OkAlert('OK', 'Se Agregó Correctamente');
          this.modalRef.close();
        },
        error => {
          this.alertasService.ErrorAlert('Error', 'Error al Agregar.');
        }
      );
    } else {
      this.tipoformadepagoService.editar(this.itemGrilla, this.Token).subscribe(
        response => {
          this.listar(this.formFiltro.get('idFiltro').value);
          this.alertasService.OkAlert('OK', 'Se Modificó Correctamente');
          this.modalRef.close();
        },
        error => {
          this.alertasService.ErrorAlert('Error', 'Error al Modificar.');
        }
      );
    }
  }

  inhabilitar(): void {
    this.tipoformadepagoService.inhabilitar(this.itemGrilla, this.Token).subscribe(
      response => {
        this.listar(this.formFiltro.get('idFiltro').value);
        this.alertasService.OkAlert('OK', 'Se Inhabilitó Correctamente');
        this.modalRef.close();
      },
      error => {
        this.alertasService.ErrorAlert('Error', 'Error al Inhabilitar.');
      }
    );
  }

  habilitar(): void {
    this.tipoformadepagoService.habilitar(this.itemGrilla, this.Token).subscribe(
      response => {
        this.listar(this.formFiltro.get('idFiltro').value);
        this.alertasService.OkAlert('OK', 'Se Habilitó Correctamente');
        this.modalRef.close();
      },
      error => {
        this.alertasService.ErrorAlert('Error', 'Error al Habilitar.');
      }
    );
  }
}
