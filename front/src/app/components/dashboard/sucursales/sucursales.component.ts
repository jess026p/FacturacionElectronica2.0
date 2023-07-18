import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { Observable, map, startWith } from 'rxjs';

export interface Sucursales {
  identificacion: string;
  nombre: string;
  descripcion: string;
  telefono: string;
  direccion: string;
  }

@Component({
  selector: 'app-sucursales',
  templateUrl: './sucursales.component.html',
  styleUrls: ['./sucursales.component.scss']
})
export class SucursalesComponent implements OnInit{

  myControl = new FormControl<string | Sucursales>('');
  options: Sucursales[] = [
    { identificacion: 'hola', nombre: '',descripcion: '', telefono: '',  direccion: '' },
    { identificacion: 'weno', nombre: '', descripcion: '', telefono: '',  direccion: '' }

  ];
  filteredOptions: Observable<Sucursales[]> | undefined;


  data: Sucursales[] = [
    { identificacion: '123456789', nombre: 'John', descripcion: 'Doe', direccion: 'Calle Principal 123', telefono: '555-5678' },
    // Añade más objetos de ejemplo para completar la tabla
  ];

  columnas: string[] = ['identificacion', 'nombre', 'descripcion', 'direccion', 'telefono', 'acciones'];

  formulario!: FormGroup;
  mostrarFormulario = false;
  constructor(private formBuilder: FormBuilder) {}

  ngOnInit(): void {
    this.formulario = this.formBuilder.group({
      identificacion: ['', Validators.required],
      nombre: ['', Validators.required],
      descripcion: ['', Validators.required],
      direccion: ['', Validators.required],
      telefono: ['', Validators.required],
      
    
  });
  this.filteredOptions = this.formulario.get('identificacion')?.valueChanges.pipe(
    startWith(''),
    map(value => {
      const codigo = typeof value === 'string' ? value : value?.codigo;
      return codigo ? this._filterCodigo(codigo as string) : this.options.slice();
    })
  );
}

displayFn(sucursales: Sucursales): string {
  return sucursales && sucursales.identificacion ? sucursales.identificacion : '';
}
private _filterCodigo(identificacion: string): Sucursales[] {
  const filterValue = identificacion.toLowerCase();

  return this.options.filter(option => option.identificacion.toLowerCase().includes(filterValue));






  }

editarElemento(elemento: Sucursales) {
    // Lógica para editar el elemento
  }

  eliminarElemento(elemento: Sucursales) {
    // Lógica para eliminar el elemento
  }

  toggleForm() {
    this.mostrarFormulario = !this.mostrarFormulario;
  }
  selectOption(option: Sucursales) {
    this.myControl.setValue(option);
  }
  submitForm() {
    if (this.formulario.valid) {
      // Realiza las acciones necesarias al guardar el formulario
      const nuevaPersona: Sucursales = {
        identificacion: '', // Asigna el valor correspondiente del formulario
        nombre: this.formulario.value.nombre,
        descripcion: this.formulario.value.apellido,
        direccion: this.formulario.value.direccion,
        telefono: this.formulario.value.telefono
      
      };
      this.data.push(nuevaPersona);
      this.formulario.reset();
      this.toggleForm();
    }
  }

}
