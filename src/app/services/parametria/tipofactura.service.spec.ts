import { TestBed } from '@angular/core/testing';

import { TipofacturaService } from './tipofactura.service';

describe('TipofacturaService', () => {
  let service: TipofacturaService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(TipofacturaService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
