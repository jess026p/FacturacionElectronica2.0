import { ComponentFixture, TestBed } from '@angular/core/testing';

import { EmpresaComponent } from './empresa.component';

describe('EmpresaComponent', () => {
  let component: EmpresaComponent;
  let fixture: ComponentFixture<EmpresaComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [EmpresaComponent]
    });
    fixture = TestBed.createComponent(EmpresaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
