import { ComponentFixture, TestBed } from '@angular/core/testing';

import { InformesdeproductoComponent } from './informesdeproducto.component';

describe('InformesdeproductoComponent', () => {
  let component: InformesdeproductoComponent;
  let fixture: ComponentFixture<InformesdeproductoComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [InformesdeproductoComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(InformesdeproductoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
