import { Component } from '@angular/core';
import { NgbModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { FormBuilder, FormGroup, Validators, FormControl } from '@angular/forms';
import { TipoFacturas } from '../../../models/parametria/tipofactura';
import { TipofacturaService } from '../../../services/parametria/tipofactura.service';

@Component({
  selector: 'app-tipofactura',
  templateUrl: './tipofactura.component.html',
  styleUrl: './tipofactura.component.css'
})
export class TipofacturaComponent {

  itemGrilla: TipoFacturas; // cada item de la tabla
  listaGrilla: TipoFacturas[] = []; // tabla completa en donde se cargan los datos
  modalRef: NgbModalRef;
  formItemGrilla: FormGroup;
  formFiltro: FormGroup;
  Token: string;

  constructor(
    private tipofacturaService: TipofacturaService,
    private modalService: NgbModal,
    private formBuilder: FormBuilder
  ) {}

  ngOnInit(): void {
    this.Token = localStorage.getItem('Token');
    this.listar(1);
    this.formItemGrilla = this.formBuilder.group({
      descripcion: new FormControl('', [Validators.required])
    });

    this.formFiltro = this.formBuilder.group({
      idFiltro: new FormControl('', [Validators.required])
    });
  }

  listar(TipoLista: number): void { // 1 habilitados, 2 inhabilitados y 3 todos
    this.tipofacturaService.listar(TipoLista)
      .subscribe(response => {
        console.log(response)
        this.listaGrilla = response.TipoFacturas || [];
      }, error => {
        console.error('Error al cargar tipos de categoría:', error);
      });
  }
}

