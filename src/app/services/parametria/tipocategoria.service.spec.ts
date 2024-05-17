import { TestBed } from '@angular/core/testing';

import { TipoCategoriaService } from './tipocategoria.service';

describe('TipocategoriaService', () => {
  let service: TipoCategoriaService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(TipoCategoriaService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
