import { TestBed } from '@angular/core/testing';

import { TipoformadepagoService } from './tipoformadepago.service';

describe('TipoformadepagoService', () => {
  let service: TipoformadepagoService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(TipoformadepagoService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
