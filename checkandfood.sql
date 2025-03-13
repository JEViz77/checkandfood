-- Crear la base de datos checkandfood
CREATE DATABASE checkandfood;
USE checkandfood;

-- Tabla de clientes
CREATE TABLE clientes (
    cliente_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(15),
    direccion VARCHAR(255),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de restaurantes
CREATE TABLE restaurantes (
    restaurante_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(15),
    descripcion TEXT,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de mesas
CREATE TABLE mesas (
    mesa_id INT AUTO_INCREMENT PRIMARY KEY,
    restaurante_id INT,
    capacidad INT NOT NULL,
    estado ENUM('disponible', 'ocupada', 'reservada') DEFAULT 'disponible',
    FOREIGN KEY (restaurante_id) REFERENCES restaurantes(restaurante_id) ON DELETE CASCADE
);

-- Tabla de reservas
CREATE TABLE reservas (
    reserva_id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT,
    restaurante_id INT,
    mesa_id INT,
    fecha_reserva DATETIME NOT NULL,
    estado ENUM('pendiente', 'confirmada', 'cancelada') DEFAULT 'pendiente',
    FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id) ON DELETE CASCADE,
    FOREIGN KEY (restaurante_id) REFERENCES restaurantes(restaurante_id) ON DELETE CASCADE,
    FOREIGN KEY (mesa_id) REFERENCES mesas(mesa_id) ON DELETE CASCADE
);

-- Tabla de usuarios (para login)
CREATE TABLE usuarios (
    usuario_id INT AUTO_INCREMENT PRIMARY KEY,
    correo VARCHAR(100) UNIQUE NOT NULL,
    contrasena VARCHAR(255) NOT NULL,
    tipo_usuario ENUM('cliente', 'restaurante') NOT NULL,
    id_usuario INT NOT NULL,  -- Puede ser cliente_id o restaurante_id
    FOREIGN KEY (id_usuario) REFERENCES clientes(cliente_id) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES restaurantes(restaurante_id) ON DELETE CASCADE
);