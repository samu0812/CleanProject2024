import { TestBed } from '@angular/core/testing';

import { TipopersonaService } from './tipopersona.service';

describe('TipopersonaService', () => {
  let service: TipopersonaService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(TipopersonaService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
