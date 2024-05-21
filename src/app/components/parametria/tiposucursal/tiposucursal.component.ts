import { Component, OnInit, Input } from '@angular/core';
import { NgbModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { FormBuilder, FormGroup, Validators, FormControl, FormArray } from '@angular/forms';
import { Sucursales } from '../../../models/parametria/tiposucursal';
import { TiposucursalService } from '../../../services/parametria/tiposucursal.service';

@Component({
  selector: 'app-tiposucursal',
  templateUrl: './tiposucursal.component.html',
  styleUrl: './tiposucursal.component.css'
})
export class TiposucursalComponent {
  tituloModal: string;
  tituloBoton: string;
  itemGrilla: Sucursales; // cada item de la tabla
  listaGrilla: Sucursales[]; // tabla completa en donde se cargan los datos
  modalRef: NgbModalRef;
  formItemGrilla: FormGroup;
  formFiltro: FormGroup;
  Token: string;

  constructor(private tiposucursalService: TiposucursalService,
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
    this.tiposucursalService.listar(TipoLista).subscribe(
      response => {
        console.log('API response:', response);
        this.itemGrilla = new Sucursales();
        this.listaGrilla = response.Sucursales || [];
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
    this.itemGrilla = Object.assign({}, new Sucursales());
    this.modalRef = this.modalService.open(content, { size: 'sm', centered: true });
  }

  openEditar(content, item: Sucursales) {
    this.tituloModal = "Editar";
    this.tituloBoton = "Guardar";
    this.itemGrilla = Object.assign({}, item); // duplica el item para que no cambie por detras y modifiquemos este para enviar al back
    this.modalRef = this.modalService.open(content, { size: 'sm', centered: true });
  }

  openInhabilitar(contentInhabilitar, item: Sucursales) {
    this.tituloModal = "Inhabilitar";
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(contentInhabilitar, { size: 'sm', centered: true });
  }

  openHabilitar(contentHabilitar, item: Sucursales) {
    this.tituloModal = "Habilitar";
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(contentHabilitar, { size: 'sm', centered: true });
  }

  guardar(): void {
    if (this.itemGrilla.IdSucursal == null) {
      this.tiposucursalService.agregar(this.itemGrilla, this.Token)
        .subscribe(response => {
          this.listar(1);
          this.modalRef.close();
        }, error => {
          console.error('Error al agregar tipo de categoría:', error);
        })
      }
    else{
      this.tiposucursalService.editar(this.itemGrilla, this.Token)
      .subscribe(response => {
        this.listar(1);
        this.modalRef.close();
      }, error => {
        console.error('Error al modificar tipo de categoría:', error);
      })
    };
  }

  inhabilitar(): void {
    this.tiposucursalService.inhabilitar(this.itemGrilla, this.Token)
      .subscribe(response => {
        this.listar(1);
        this.modalRef.close();
      }, error => {
        console.error('Error al inhabilitar tipo de categoría:', error);
      });
  }

  habilitar(): void {
    this.tiposucursalService.habilitar(this.itemGrilla, this.Token)
      .subscribe(response => {
        this.listar(1);
        this.modalRef.close();
      }, error => {
        console.error('Error al habilitar tipo de categoría:', error);
      });
  }




}
