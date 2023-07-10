import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';

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
