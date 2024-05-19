import { Component, OnInit } from '@angular/core';
import { TipoCategoriaService } from '../../../services/parametria/tipocategoria.service';
import { TipoCategoria } from '../../../models/parametria/tipoCategoria'
import { NgbModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { FormBuilder, FormGroup, Validators, FormControl, FormArray } from '@angular/forms';

@Component({
  selector: 'app-tipocategoria',
  templateUrl: './tipocategoria.component.html',
  styleUrls: ['./tipocategoria.component.css']
})
export class TipocategoriaComponent implements OnInit {
  tituloModal: string;
  tituloBoton: string;
  itemGrilla: TipoCategoria; // cada item de la tabla
  listaGrilla: TipoCategoria[]; // tabla completa en donde se cargan los datos
  modalRef: NgbModalRef;
  formItemGrilla: FormGroup;
  formFiltro: FormGroup;
  Token: string;

  constructor(private tipoCategoriaService: TipoCategoriaService,
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
    this.tipoCategoriaService.listar(TipoLista).subscribe(
      response => {
        console.log('API response:', response);
        this.itemGrilla = new TipoCategoria();
        this.listaGrilla = response.TipoCategoria || [];
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
    this.itemGrilla = Object.assign({}, new TipoCategoria());
    this.modalRef = this.modalService.open(content, { size: 'sm', centered: true });
  }

  openEditar(content, item: TipoCategoria) {
    this.tituloModal = "Editar";
    this.tituloBoton = "Guardar";
    this.itemGrilla = Object.assign({}, item); // duplica el item para que no cambie por detras y modifiquemos este para enviar al back
    this.modalRef = this.modalService.open(content, { size: 'sm', centered: true });
  }

  openInhabilitar(contentInhabilitar, item: TipoCategoria) {
    this.tituloModal = "Inhabilitar";
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(contentInhabilitar, { size: 'sm', centered: true });
  }

  openHabilitar(contentHabilitar, item: TipoCategoria) {
    this.tituloModal = "Habilitar";
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(contentHabilitar, { size: 'sm', centered: true });
  }

  guardar(): void {
    if (this.itemGrilla.IdTipoCategoria == null) {
      this.tipoCategoriaService.agregar(this.itemGrilla, this.Token)
        .subscribe(response => {
          this.listar(1);
          this.modalRef.close();
        }, error => {
          console.error('Error al agregar tipo de categoría:', error);
        })
      }
    else{
      this.tipoCategoriaService.editar(this.itemGrilla, this.Token)
      .subscribe(response => {
        this.listar(1);
        this.modalRef.close();
      }, error => {
        console.error('Error al modificar tipo de categoría:', error);
      })
    };
  }

  inhabilitar(): void {
    this.tipoCategoriaService.inhabilitar(this.itemGrilla, this.Token)
      .subscribe(response => {
        this.listar(1);
        this.modalRef.close();
      }, error => {
        console.error('Error al inhabilitar tipo de categoría:', error);
      });
  }

  habilitar(): void {
    this.tipoCategoriaService.habilitar(this.itemGrilla, this.Token)
      .subscribe(response => {
        this.listar(1);
      }, error => {
        console.error('Error al habilitar tipo de categoría:', error);
      });
  }




}
