import { Component, OnInit } from '@angular/core';
import { ClientesService } from './services/clientes.service';
import { MatSnackBar } from '@angular/material/snack-bar';
import {
  FormBuilder,
  FormControl,
  FormGroup,
  Validators,
} from '@angular/forms';
import { Observable } from 'rxjs';

export interface Persona {
  id: number;
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
  styleUrls: ['./clientes.component.scss'],
})
export class ClientesComponent implements OnInit {
  data: Persona[] = [];

  columnas: string[] = [
    'identificacion',
    'nombre',
    'apellido',
    'direccion',
    'telefono',
    'celular',
    'correoElectronico',
    'acciones',
  ];
  filtroCliente: FormControl = new FormControl();
  formulario!: FormGroup;
  mostrarFormulario = false;
  clienteSeleccionado: Persona | null = null;

  constructor(
    private formBuilder: FormBuilder,
    private personasService: ClientesService,
    private snackBar: MatSnackBar
  ) {}

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
    this.obtenerPersonas();
    this.filtroCliente.valueChanges.subscribe((valor: string) => {
      this.data = this.data.filter((cliente: Persona) =>
        cliente.nombre.toLowerCase().includes(valor.toLowerCase()) ||
        cliente.identificacion.includes(valor)
      );
    });
  }

  obtenerPersonas(): void {
    this.personasService.obtenerClientes().subscribe(
      (response: any[]) => {
        this.data = response.map((persona: any) => ({
          id: persona.id,
          identificacion: persona.Identificacion,
          tipoIdentificacion: persona.TipoIdentificacion,
          nombre: persona.RazonSocial,
          apellido: persona.NombreComercial,
          direccion: persona.Direccion,
          telefono: persona.Telefono || '',
          celular: persona.Celular,
          correoElectronico: persona.Correo,
        }));
      },
      (error) => {
        console.error(error);
      }
    );
  }

  editarElemento(elemento: Persona) {
    this.clienteSeleccionado = elemento;
    this.mostrarFormulario = true;
    this.formulario.patchValue(elemento);
  }

  eliminarElemento(elemento: Persona) {
    const confirmarEliminacion = confirm('¿Estás seguro de que deseas eliminar este cliente?');
    if (confirmarEliminacion) {
      this.personasService.eliminarCliente(elemento.id).subscribe(
        () => {
          this.data = this.data.filter((item) => item.id !== elemento.id);
          this.snackBar.open('Cliente eliminado correctamente', 'Cerrar', {
            duration: 3000,
          });
        },
        (error) => {
          console.error('Error al eliminar el cliente', error);
          this.snackBar.open('Error al eliminar el cliente', 'Cerrar', {
            duration: 3000,
          });
        }
      );
    }
  }


  toggleForm() {
    this.mostrarFormulario = !this.mostrarFormulario;
  }

  submitForm() {
    if (this.formulario.valid) {
      const formularioValues = this.formulario.value;
      const cliente: Persona = {
        id: this.clienteSeleccionado ? this.clienteSeleccionado.id : 0,
        identificacion: formularioValues.identificacion,
        tipoIdentificacion: '',
        nombre: formularioValues.nombre,
        apellido: formularioValues.apellido,
        direccion: formularioValues.direccion,
        telefono: formularioValues.telefono,
        celular: formularioValues.celular,
        correoElectronico: formularioValues.correoElectronico,
      };

      if (this.clienteSeleccionado) {
        // Actualizar el cliente existente
        this.personasService.actualizarCliente(cliente.id,cliente).subscribe(
          (response) => {
            console.log('Cliente actualizado exitosamente', response);
            this.obtenerPersonas();
            this.formulario.reset();
            this.clienteSeleccionado = null;
            this.toggleForm();
          },
          (error) => {
            console.error('Error al actualizar el cliente', error);
          }
        );
      } else {
        // Crear un nuevo cliente
        this.personasService.crearCliente(cliente).subscribe(
          (response) => {
            console.log('Cliente creado exitosamente', response);
            this.obtenerPersonas();
            this.formulario.reset();
            this.toggleForm();
          },
          (error) => {
            console.error('Error al crear el cliente', error);
          }
        );
      }
    }
  }


  myControl = new FormControl<Persona | null>(null);
  options: Persona[] = [];
  filteredOptions: Observable<Persona[]> | undefined;
}
