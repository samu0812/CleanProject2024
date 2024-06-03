import { ComponentFixture, TestBed } from '@angular/core/testing';

import { TipodocumentacionComponent } from './tipodocumentacion.component';

describe('TipodocumentacionComponent', () => {
  let component: TipodocumentacionComponent;
  let fixture: ComponentFixture<TipodocumentacionComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [TipodocumentacionComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(TipodocumentacionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
