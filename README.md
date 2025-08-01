# 🚀 DoPilot

**Aplicativo mobile de gerenciamento de tarefas com arquitetura MVC + BLoC**

![Flutter](https://img.shields.io/badge/Flutter-3.29.3+-02569B?style=flat&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=flat&logo=dart)
![Material Design](https://img.shields.io/badge/Material%20Design-3-757575?style=flat&logo=material-design)

## 📱 Sobre o Projeto

O **DoPilot** é uma aplicação Flutter moderna para gerenciamento de tarefas, construída com **arquitetura MVC** e **gerenciamento de estado BLoC**, seguindo as melhores práticas do **Material Design 3**. O app permite aos usuários organizar suas tarefas diárias com uma interface intuitiva e elegante.

## 🏗️ Arquitetura

O projeto segue o padrão **MVC (Model-View-Controller)** com **BLoC** para gerenciamento de estado:

```
lib/
├── screen/                  # 📱 VIEW - Interface do Usuário
├── bloc/                    # 🎯 CONTROLLER - Gerenciamento de Estado (BLoC)
├── service/                 # 🔧 CONTROLLER - Lógica de Negócio  
├── repository/              # 💾 MODEL - Acesso a Dados
├── data/
│   ├── model/               # 📋 MODEL - Entidades (Equatable)
│   ├── dto/                 # 🔄 MODEL - DTOs (fromJson/toJson)
│   └── enum/                # 📝 MODEL - Enumerações
├── widgets/                 # 🧩 VIEW - Componentes Reutilizáveis
└── util/                    # 🛠️ Utilitários
```

### 🔄 Fluxo MVC + BLoC
```
View (Screen/Widget) → Controller (BLoC) → Service → Repository → Model/DTO
                    ↖                                              ↙
                      ← ← ← State Updates ← ← ← ← ← ← ← ← ← ← ← ←
```

### 🎯 Responsabilidades das Camadas

#### 📱 **View (Telas e Widgets)**
- Renderização da interface do usuário
- Captura de eventos de interação
- Exibição de estados visuais (loading, sucesso, erro)

#### 🎯 **Controller (BLoC + Service)**
- **BLoC**: Gerenciamento de estado reativo e eventos
- **Service**: Lógica de negócio, validações e orquestração

#### 📋 **Model (Repository + Data)**
- **Repository**: Acesso e persistência de dados
- **Model**: Entidades e estruturas de dados
- **DTO**: Serialização e comunicação com APIs

## 🎨 Design System

### Paleta de Cores
- **Roxo Principal**: `#7B2CBF` - Cor primária do app
- **Verde Sucesso**: `#20E6B8` - Tarefas concluídas
- **Laranja Aviso**: `#FF6B35` - Tarefas pendentes
- **Cinza Fundo**: `#F5F5F5` - Background das telas
- **Branco Cards**: `#FFFFFF` - Fundo dos cards

### Componentes
- ✅ **Cards** com bordas arredondadas (16px)
- ✅ **Sombras suaves** com baixa opacidade
- ✅ **Material Design 3** como base
- ✅ **Ícones Material Symbols** para consistência

## 🛠️ Tecnologias

### Core
- **Flutter** 3.29.3+ - Framework multiplataforma
- **Dart** 3.0+ - Linguagem de programação
- **Material Design 3** - Sistema de design

### Arquitetura & Padrões
- **MVC Pattern** - Arquitetura principal (Model-View-Controller)
- **flutter_bloc** - Gerenciamento de estado reativo (Controller layer)
- **equatable** - Comparações eficientes de objetos

## 📱 Plataformas Suportadas

- ✅ **iOS** 12.0+
- ✅ **Android** API 21+

## 🚀 Como Executar

### Pré-requisitos
- Flutter 3.29.3+ instalado
- Dart SDK 3.0+
- Xcode (para iOS) ou Android Studio ou VSC
- Dispositivo/Simulador configurado

### Comandos
```bash
# Clonar dependências
flutter pub get

# Executar no simulador/dispositivo
flutter run

# Build para iOS (sem assinatura)
flutter build ios --no-codesign

# Build para Android
flutter build apk

# Análise de código
flutter analyze
```

## 🏛️ Estrutura do Projeto

### 📂 Principais Diretórios

#### `/lib/screen/` - 📱 **VIEW Layer**
Telas da aplicação (View no padrão MVC):
- `HomeScreen` - Dashboard principal com integração BLoC
- Responsável apenas pela apresentação visual e captura de eventos

#### `/lib/bloc/` - 🎯 **CONTROLLER Layer (Estado)**
BLoCs responsáveis pelo gerenciamento de estado:
- `TaskBloc` - Controla estados das tarefas (loading, success, error)
- Recebe eventos da View e emite estados para atualização da UI

#### `/lib/service/` - 🔧 **CONTROLLER Layer (Negócio)**
Camada de lógica de negócio:
- `TaskService` - Orquestra operações, validações e cálculos
- Intermediário entre BLoC e Repository

#### `/lib/repository/` - 💾 **MODEL Layer (Dados)**
Camada de acesso aos dados:
- `TaskRepository` - Interface para APIs, Firebase ou dados locais
- Abstrai a fonte de dados para o Service

#### `/lib/data/` - 📋 **MODEL Layer (Estruturas)**
Estruturas de dados:
- `model/` - Entidades do domínio baseadas em Equatable
- `dto/` - Objetos de transferência com serialização JSON
- `enum/` - Enumerações tipadas (Priority, Category, Status)

#### `/lib/widgets/` - 🧩 **VIEW Layer (Componentes)**
Componentes reutilizáveis da interface:
- `StatsCardWidget` - Cards de estatísticas
- `TaskItemWidget` - Itens de tarefa com interações
- Widgets sem lógica de negócio, apenas apresentação

## 📋 Padrões de Desenvolvimento

### 🎯 MVC + BLoC Guidelines
1. **View**: Apenas renderização e eventos de UI
2. **Controller (BLoC)**: Gerenciamento de estado reativo
3. **Controller (Service)**: Lógica de negócio e validações
4. **Model**: Dados, DTOs e acesso à persistência

### 🔄 Fluxo de Dados Típico
```dart
// 1. User taps button (View)
onPressed: () => context.read<TaskBloc>().add(AddTaskEvent())

// 2. BLoC receives event (Controller - State)
TaskBloc.add(AddTaskEvent()) → emit(TaskLoadingState())

// 3. BLoC calls Service (Controller - Business)
final result = await taskService.addTask(task)

// 4. Service calls Repository (Model - Data)  
final savedTask = await taskRepository.save(task)

// 5. Data flows back through layers
Repository → Service → BLoC → View (UI Update)
```

## 🎓 Arquitetura para Ensino

Este projeto foi estruturado especificamente para **fins educacionais**, demonstrando:

- ✅ **Separação clara de responsabilidades** (MVC)
- ✅ **Gerenciamento de estado moderno** (BLoC)
- ✅ **Código limpo e documentado**
- ✅ **Padrões de nomenclatura consistentes**
- ✅ **Fluxo de dados unidirecional**
- ✅ **Testabilidade** (cada camada isolada)

---

