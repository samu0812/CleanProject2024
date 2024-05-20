import { TestBed } from '@angular/core/testing';

import { TipoproductoService } from './tipoproducto.service';

describe('TipoproductoService', () => {
  let service: TipoproductoService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(TipoproductoService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
