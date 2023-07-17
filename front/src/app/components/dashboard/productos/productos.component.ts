import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { Observable } from 'rxjs';
import { map, startWith } from 'rxjs/operators';
import { ProductoService } from './services/producto.service';

export interface Producto {
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

  myControl = new FormControl<string | Producto>('');
  options: Producto[] = [
    { codigo: '12344', nombre: '', descripcion: '', precioU: '', tarifaIVa: '', stock: '', descuento: '', categoria: '' },
    { codigo: '23422', nombre: '', descripcion: '', precioU: '', tarifaIVa: '', stock: '', descuento: '', categoria: '' },
  ];
  filteredOptions: Observable<Producto[]> | undefined;
  productos: Producto[] = [];
  data: Producto[] = []; // Variable 'data' declarada aquí

  columnas: string[] = ['codigo', 'nombre', 'precioU', 'descripcion', 'tarifaIVa', 'stock', 'descuento', 'categoria', 'acciones'];

  formulario!: FormGroup;
  mostrarFormulario = false;

  constructor(private formBuilder: FormBuilder, private productoService: ProductoService) { }

  ngOnInit() {
    this.formulario = this.formBuilder.group({
      codigo: ['', Validators.required],
      nombre: ['', Validators.required],
      precioU: ['', Validators.required],
      descripcion: ['', Validators.required],
      tarifaIVa: ['', Validators.required],
      stock: ['', Validators.required],
      descuento: ['', Validators.required],
      categoria: ['', Validators.required]
    });

    this.filteredOptions = this.myControl.valueChanges.pipe(
      startWith(''),
      map(value => {
        const codigo = typeof value === 'string' ? value : value?.codigo;
        return codigo ? this._filterCodigo(codigo as string) : this.options.slice();
      })
    );

    this.obtenerProductos();
  }

  displayFn(producto: Producto): string {
    return producto && producto.codigo ? producto.codigo : '';
  }

  private _filterCodigo(codigo: string): Producto[] {
    const filterValue = codigo.toLowerCase();
    return this.options.filter(option => option.codigo.toLowerCase().includes(filterValue));
  }

  editarElemento(elemento: Producto) {
    // Lógica para editar el elemento
  }


  toggleForm() {
    this.mostrarFormulario = !this.mostrarFormulario;
  }

  selectOption(option: Producto) {
    this.myControl.setValue(option);
  }

  submitForm() {
    if (this.formulario.valid) {
      const nuevoProducto: Producto = {
        codigo: this.formulario.value.codigo,
        nombre: this.formulario.value.nombre,
        precioU: this.formulario.value.precioU,
        descripcion: this.formulario.value.descripcion,
        tarifaIVa: this.formulario.value.tarifaIVa,
        stock: this.formulario.value.stock,
        descuento: this.formulario.value.descuento,
        categoria: this.formulario.value.categoria
      };
      this.productos.push(nuevoProducto);
      this.data.push(nuevoProducto); // Agrega el nuevo producto a la variable 'data'
      this.formulario.reset();
      this.toggleForm();
    }
  }

  obtenerProductos() {
    this.productoService.obtenerProductos().subscribe(
      response => {
        this.productos = response.map((producto: any) => ({
          codigo: producto.Codigo,
          nombre: producto.Nombre,
          precioU: producto.CostoUnitario,
          descripcion: producto.InfoAdicional,
          tarifaIVa: producto.IdTarifaImpuestoIVACompr,
          stock: producto.stock,
          descuento: producto.descuento,
          categoria: producto.IdCategoria
        }));
        this.data = this.productos; // Asigna los productos a la variable 'data'
      },
      error => {
        console.error(error);
      }
    );
  }

  searchProductos(event: Event) {
    const searchTerm = (event.target as HTMLInputElement).value.toLowerCase();
    this.data = this.productos.filter(producto =>
      producto.nombre.toLowerCase().includes(searchTerm) ||
      producto.descripcion.toLowerCase().includes(searchTerm) ||
      producto.codigo.toLowerCase().includes(searchTerm)
    );
  }

  eliminarElemento(elemento: Producto) {
    this.productoService.eliminarProducto(elemento.codigo).subscribe(
      () => {
        this.data = this.data.filter(item => item.codigo !== elemento.codigo);
      },
      error => {
        console.error(error);
      }
    );
  }
}
