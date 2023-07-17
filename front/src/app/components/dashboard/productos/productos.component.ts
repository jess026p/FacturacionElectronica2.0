import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { Observable, map, startWith } from 'rxjs';

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

  myControl = new FormControl<string | productos>('');
  options: productos[] = [
    { codigo: '12344', nombre: '', descripcion: '', precioU: '',
      tarifaIVa: '', stock: '', descuento:'',categoria:'' },
      { codigo: '23422', nombre: '', descripcion: '', precioU: '',
      tarifaIVa: '', stock: '', descuento:'',categoria:'' },
  ];
  filteredOptions: Observable<productos[]> | undefined;

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
  
    this.filteredOptions = this.formulario.get('codigo')?.valueChanges.pipe(
      startWith(''),
      map(value => {
        const codigo = typeof value === 'string' ? value : value?.codigo;
        return codigo ? this._filterCodigo(codigo as string) : this.options.slice();
      })
    );
  }
  
  displayFn(productos: productos): string {
    return productos && productos.codigo ? productos.codigo : '';
  }
  private _filterCodigo(codigo: string): productos[] {
    const filterValue = codigo.toLowerCase();
  
    return this.options.filter(option => option.codigo.toLowerCase().includes(filterValue));
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

  selectOption(option: productos) {
    this.myControl.setValue(option);
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
