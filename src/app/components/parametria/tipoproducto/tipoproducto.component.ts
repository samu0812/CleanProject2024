import { Component, OnInit, Input } from '@angular/core';
import { NgbModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { FormBuilder, FormGroup, Validators, FormControl, FormArray } from '@angular/forms';
import { TipoProducto } from '../../../models/parametria/tipoproducto';
import { TipoproductoService } from '../../../services/parametria/tipoproducto.service';

@Component({
  selector: 'app-tipoproducto',
  templateUrl: './tipoproducto.component.html',
  styleUrl: './tipoproducto.component.css'
})

export class TipoproductoComponent {
  tituloModal: string;
  tituloBoton: string;
  itemGrilla: TipoProducto; // cada item de la tabla
  listaGrilla: TipoProducto[]; // tabla completa en donde se cargan los datos
  modalRef: NgbModalRef;
  formItemGrilla: FormGroup;
  formFiltro: FormGroup;
  Token: string;

  constructor(private tipoproductoService: TipoproductoService,
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
    this.tipoproductoService.listar(TipoLista).subscribe(
      response => {
        console.log('API response:', response);
        this.itemGrilla = new TipoProducto();
        this.listaGrilla = response.TipoProducto || [];
        console.log(this.listaGrilla);
      },
      error => {
        console.error('Error al cargar tipos de categoría:', error);
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
    this.itemGrilla = Object.assign({}, new TipoProducto());
    this.modalRef = this.modalService.open(content, { size: 'sm', centered: true });
  }

  openEditar(content, item: TipoProducto) {
    this.tituloModal = "Editar";
    this.tituloBoton = "Guardar";
    this.itemGrilla = Object.assign({}, item); // duplica el item para que no cambie por detras y modifiquemos este para enviar al back
    this.modalRef = this.modalService.open(content, { size: 'sm', centered: true });
  }

  openInhabilitar(contentInhabilitar, item: TipoProducto) {
    this.tituloModal = "Inhabilitar";
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(contentInhabilitar, { size: 'sm', centered: true });
  }

  openHabilitar(contentHabilitar, item: TipoProducto) {
    this.tituloModal = "Habilitar";
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(contentHabilitar, { size: 'sm', centered: true });
  }

  guardar(): void {
    if (this.itemGrilla.IdTipoProducto == null) {
      this.tipoproductoService.agregar(this.itemGrilla, this.Token)
        .subscribe(response => {
          this.listar(1);
          this.modalRef.close();
        }, error => {
          console.error('Error al agregar tipo de categoría:', error);
        })
      }
    else{
      this.tipoproductoService.editar(this.itemGrilla, this.Token)
      .subscribe(response => {
        this.listar(1);
        this.modalRef.close();
      }, error => {
        console.error('Error al modificar tipo de categoría:', error);
      })
    };
  }

  inhabilitar(): void {
    this.tipoproductoService.inhabilitar(this.itemGrilla, this.Token)
      .subscribe(response => {
        this.listar(1);
        this.modalRef.close();
      }, error => {
        console.error('Error al inhabilitar tipo de categoría:', error);
      });
  }

  habilitar(): void {
    this.tipoproductoService.habilitar(this.itemGrilla, this.Token)
      .subscribe(response => {
        this.listar(1);
        this.modalRef.close();
      }, error => {
        console.error('Error al habilitar tipo de categoría:', error);
      });
  }




}