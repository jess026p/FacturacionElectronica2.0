import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';

export interface productos {
  codigo: string;
  nombre: string;
  precioU: string;
  descripcion: string;
  tarifaIVa: string;
  stock: string;
  descuento: string;
  categoria: string;
}
@Component({
  selector: 'app-productos',
  templateUrl: './productos.component.html',
  styleUrls: ['./productos.component.scss']
})
export class ProductosComponent implements OnInit {
  data: productos[] = [
    { codigo: '123456789', nombre: 'John', precioU: 'Doe', descripcion: 'Calle Principal 123', tarifaIVa: '555-1234', stock: '555-5678', descuento: 'johndoe@example.com',categoria:'mix' },
    // Añade más objetos de ejemplo para completar la tabla
  ];

  columnas: string[] = ['codigo', 'nombre', 'precioU', 'descripcion', 'tarifaIVa', 'stock', 'descuento', 'categoria','acciones'];

  formulario!: FormGroup;
  mostrarFormulario = false;

  constructor(private formBuilder: FormBuilder) {}

  ngOnInit() {
    this.formulario = this.formBuilder.group({
      codigo: ['', Validators.required],
      nombre: ['', Validators.required],
      precio: ['', Validators.required],
      descripcion: ['', Validators.required],
      tarifaIVa: ['', Validators.required],
      stock: ['', Validators.required],
      descuento: ['', Validators.required],
      categoria: ['', Validators.required]
     

    });
  }

  editarElemento(elemento: productos) {
    // Lógica para editar el elemento
  }

  eliminarElemento(elemento: productos) {
    // Lógica para eliminar el elemento
  }

  toggleForm() {
    this.mostrarFormulario = !this.mostrarFormulario;
  }

  submitForm() {
    if (this.formulario.valid) {
      // Realiza las acciones necesarias al guardar el formulario
      const nuevoProducto: productos = {
        codigo: '', // Asigna el valor correspondiente del formulario
        nombre: this.formulario.value.nombre,
        precioU: this.formulario.value.precioU,
        descripcion: this.formulario.value.descripcion,
        descuento: this.formulario.value.descuento,
        tarifaIVa: this.formulario.value.tarifaIVa,
        stock: this.formulario.value.stock,
        categoria: this.formulario.value.categoria
      };
      this.data.push(nuevoProducto);
      this.formulario.reset();
      this.toggleForm();
    }
  }
}
