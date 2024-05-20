import { TestBed } from '@angular/core/testing';

import { TipomedidaService } from './tipomedida.service';

describe('TipomedidaService', () => {
  let service: TipomedidaService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(TipomedidaService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
