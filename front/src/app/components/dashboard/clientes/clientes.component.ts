import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';

export interface Persona {
  identificacion: string;
  tipoIdentificacion: string;
  nombre: string;
  apellido: string;
  direccion: string;
  telefono: string;
  celular: string;
  correoElectronico: string;
}

@Component({
  selector: 'app-clientes',
  templateUrl: './clientes.component.html',
  styleUrls: ['./clientes.component.scss']
})
export class ClientesComponent implements OnInit {
  data: Persona[] = [
    { identificacion: '123456789',tipoIdentificacion:'ruc', nombre: 'John', apellido: 'Doe', direccion: 'Calle Principal 123', telefono: '555-1234', celular: '555-5678', correoElectronico: 'johndoe@example.com' },
    // Añade más objetos de ejemplo para completar la tabla
  ];

  columnas: string[] = ['identificacion', 'nombre', 'apellido', 'direccion', 'telefono', 'celular', 'correoElectronico', 'acciones'];

  formulario!: FormGroup;
  mostrarFormulario = false;

  constructor(private formBuilder: FormBuilder) {}

  ngOnInit() {
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

  editarElemento(elemento: Persona) {
    // Lógica para editar el elemento
  }

  eliminarElemento(elemento: Persona) {
    // Lógica para eliminar el elemento
  }

  toggleForm() {
    this.mostrarFormulario = !this.mostrarFormulario;
  }

  submitForm() {
    if (this.formulario.valid) {
      // Realiza las acciones necesarias al guardar el formulario
      const nuevaPersona: Persona = {
        identificacion: this.formulario.value.identificacion,
        tipoIdentificacion: this.formulario.value.tipoIdentificacion,
        nombre: this.formulario.value.nombre,
        apellido: this.formulario.value.apellido,
        direccion: this.formulario.value.direccion,
        telefono: this.formulario.value.telefono,
        celular: this.formulario.value.celular,
        correoElectronico: this.formulario.value.correoElectronico
      };
      this.data.push(nuevaPersona);
      this.formulario.reset();
      this.toggleForm();
    }
  }
}
