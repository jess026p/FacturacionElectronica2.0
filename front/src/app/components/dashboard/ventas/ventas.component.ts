import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';

export interface Ventas {
  cantidad: string;
  descripcion: string;
  precioU: string;
  Tarifa: string;
  descuento: string;
  valorT: string;
}

export interface Persona {
  identificacion: string;
  nombre: string;
  apellido: string;
  direccion: string;
  telefono: string;
  celular: string;
  correoElectronico: string;
}

@Component({
  selector: 'app-ventas',
  templateUrl: './ventas.component.html',
  styleUrls: ['./ventas.component.scss']
})
export class VentasComponent {
  formulario: FormGroup;
  mostrarFormulario = false;
  data: Ventas[] = [
    { cantidad: '123456789', descripcion: 'John', precioU: 'Doe', Tarifa: 'Calle Principal 123', descuento: '555-1234', valorT: '555-5678' },
    // Añade más objetos de ejemplo para completar la tabla
  ];
  columnas: string[] = ['cantidad', 'descripcion', 'precioU', 'tarifa', 'descuento', 'valorT', 'acciones'];

  constructor(private formBuilder: FormBuilder) {
    this.formulario = this.formBuilder.group({
      identificacion: ['', Validators.required],
      nombre: ['', Validators.required],
      apellido: ['', Validators.required],
      direccion: ['', Validators.required],
      telefono: ['', Validators.required],
      celular: ['', Validators.required],
      correoElectronico: ['', [Validators.required, Validators.email]],
    });
  }

  toggleForm() {
    this.mostrarFormulario = !this.mostrarFormulario;
  }

  submitForm() {
    if (this.formulario.valid) {
      const nuevoCliente: Persona = {
        identificacion: this.formulario.value.identificacion,
        nombre: this.formulario.value.nombre,
        apellido: this.formulario.value.apellido,
        direccion: this.formulario.value.direccion,
        telefono: this.formulario.value.telefono,
        celular: this.formulario.value.celular,
        correoElectronico: this.formulario.value.correoElectronico,
      };
      // Aquí puedes hacer lo que necesites con el nuevo cliente, como agregarlo a una lista
      console.log(nuevoCliente);
      this.formulario.reset();
      this.mostrarFormulario = false;
    }
  }

  editarElemento(elemento: Ventas) {
    // Lógica para editar el elemento
  }

  eliminarElemento(elemento: Ventas) {
    // Lógica para eliminar el elemento
  }
}
