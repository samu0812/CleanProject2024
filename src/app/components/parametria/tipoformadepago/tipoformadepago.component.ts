import { Component, OnInit } from '@angular/core';
import { NgbModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { FormBuilder, FormGroup, Validators, FormControl } from '@angular/forms';
import { TipoFormaDePago } from '../../../models/parametria/tipoformadepago';
import { TipoformadepagoService } from './../../../services/parametria/tipoformadepago.service';

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

  constructor(
    private tipoformadepagoService: TipoformadepagoService,
    private modalService: NgbModal,
    private formBuilder: FormBuilder
  ) {}

  ngOnInit(): void {
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

  listar(TipoLista: number): void { // 1 habilitados, 2 inhabilitados y 3 todos
    this.tipoformadepagoService.listar(TipoLista).subscribe(
      response => {
        console.log('API response:', response);
        this.itemGrilla = new TipoFormaDePago();
        this.listaGrilla = response.TipoFormaDePago || [];
      },
      error => {
        console.error('Error al cargar tipos de forma de pago:', error);
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
          this.modalRef.close();
        },
        error => {
          console.error('Error al agregar tipo de forma de pago:', error);
        }
      );
    } else {
      this.tipoformadepagoService.editar(this.itemGrilla, this.Token).subscribe(
        response => {
          this.listar(this.formFiltro.get('idFiltro').value);
          this.modalRef.close();
        },
        error => {
          console.error('Error al modificar tipo de forma de pago:', error);
        }
      );
    }
  }

  inhabilitar(): void {
    this.tipoformadepagoService.inhabilitar(this.itemGrilla, this.Token).subscribe(
      response => {
        this.listar(this.formFiltro.get('idFiltro').value);
        this.modalRef.close();
      },
      error => {
        console.error('Error al inhabilitar tipo de forma de pago:', error);
      }
    );
  }

  habilitar(): void {
    this.tipoformadepagoService.habilitar(this.itemGrilla, this.Token).subscribe(
      response => {
        this.listar(this.formFiltro.get('idFiltro').value);
        this.modalRef.close();
      },
      error => {
        console.error('Error al habilitar tipo de forma de pago:', error);
      }
    );
  }
}