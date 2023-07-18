import { Component, OnInit } from '@angular/core';

import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { Observable, map, startWith } from 'rxjs';

export interface Trabajador {
  identificacion: string;
  nombre: string;
  apellido: string;
  direccion: string;
  usuario: string;
  contrasena: string;
  correoElectronico: string;
}

@Component({
  selector: 'app-trabajador',
  templateUrl: './trabajador.component.html',
  styleUrls: ['./trabajador.component.scss']
})
export class TrabajadorComponent implements OnInit {

  myControl = new FormControl<string | Trabajador>('');
  options: Trabajador[] = [
    { identificacion: '12344', nombre: '', apellido: '', direccion: '',
      usuario: '', contrasena: '', correoElectronico:''},
      { identificacion: '12344', nombre: '', apellido: '', direccion: '',
      usuario: '', contrasena: '', correoElectronico:''},
  ];
  filteredOptions: Observable<Trabajador[]> | undefined;

  data: Trabajador[] = [
    { identificacion: '123456789', nombre: 'John', apellido: 'Doe', direccion: 'Calle Principal 123', usuario: '555-1234', contrasena: '555-5678', correoElectronico: 'johndoe@example.com' },
    // Añade más objetos de ejemplo para completar la tabla
  ];
  columnas: string[] = ['identificacion', 'nombre', 'apellido', 'direccion', 'usuario', 'contrasena', 'correoElectronico', 'acciones'];

  formulario!: FormGroup;
  mostrarFormulario = false;
  constructor(private formBuilder: FormBuilder) {}

  ngOnInit(): void {
    
    this.formulario = this.formBuilder.group({
      identificacion: ['', Validators.required],
      nombre: ['', Validators.required],
      apellido: ['', Validators.required],
      direccion: ['', Validators.required],
      usuario: ['', Validators.required],
      contrasena: ['', Validators.required],
      correoElectronico: ['', [Validators.required, Validators.email]],
    
  });
  this.filteredOptions = this.formulario.get('identificacion')?.valueChanges.pipe(
    startWith(''),
    map((value: { codigo: any; }) => {
      const identificacion = typeof value === 'string' ? value : value?.codigo;
      return identificacion ? this._filterCodigo(identificacion as string) : this.options.slice();
    })
  );
}

displayFn(trabajador: Trabajador): string {
  return trabajador && trabajador.identificacion ? trabajador.identificacion : '';
}
private _filterCodigo(identificacion: string): Trabajador[] {
  const filterValue = identificacion.toLowerCase();

  return this.options.filter(option => option.identificacion.toLowerCase().includes(filterValue));

  }
  
  editarElemento(elemento: Trabajador) {
    // Lógica para editar el elemento
  }

  eliminarElemento(elemento: Trabajador) {
    // Lógica para eliminar el elemento
  }

  toggleForm() {
    this.mostrarFormulario = !this.mostrarFormulario;
  }
  selectOption(option: Trabajador) {
    this.myControl.setValue(option);
  }
  submitForm() {
    if (this.formulario.valid) {
      // Realiza las acciones necesarias al guardar el formulario
      const nuevaPersona: Trabajador = {
        identificacion: '', // Asigna el valor correspondiente del formulario
        nombre: this.formulario.value.nombre,
        apellido: this.formulario.value.apellido,
        direccion: this.formulario.value.direccion,
        usuario: this.formulario.value.telefono,
        contrasena: this.formulario.value.celular,
        correoElectronico: this.formulario.value.correoElectronico
      };
      this.data.push(nuevaPersona);
      this.formulario.reset();
      this.toggleForm();
    }
  }

}
