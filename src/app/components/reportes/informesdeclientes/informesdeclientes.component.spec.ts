import { ComponentFixture, TestBed } from '@angular/core/testing';

import { InformesdeclientesComponent } from './informesdeclientes.component';

describe('InformesdeclientesComponent', () => {
  let component: InformesdeclientesComponent;
  let fixture: ComponentFixture<InformesdeclientesComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [InformesdeclientesComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(InformesdeclientesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
