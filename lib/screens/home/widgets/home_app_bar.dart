import 'package:app_dopilot/models/bottom_sheet_option.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import '../../../utils/colors.dart';

/// AppBar customizado para a tela inicial
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {

  const HomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryPurple,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 100.0,
      title: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: SvgPicture.asset(
              'assets/images/logo.svg',
              width: 48,
              height: 48,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DoPilot',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.cardWhite,
                  ),
                ),
                Text(
                  'Olá, João da Silva',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColors.cardWhite),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showUserMenuBottomSheet(context),
            child: _buildAvatar(
              'https://i.pinimg.com/474x/8c/da/8c/8cda8ca891afa64893369e592fd94822.jpg',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100.0);

  /// Constrói o avatar com base na URL da foto do usuário
  Widget _buildAvatar(String? photoUrl) {
    if (photoUrl != null && photoUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 25,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: photoUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                Icon(Icons.person, color: AppColors.cardWhite, size: 30),
            errorWidget: (context, url, error) =>
                Icon(Icons.person, color: AppColors.primaryPurple, size: 30),
          ),
        ),
      );
    }

    return CircleAvatar(
      radius: 25,
      child: Icon(Icons.person, color: AppColors.cardWhite, size: 30),
    );
  }

  /// Mostrar bottom sheet com opções do usuário
  Future<void> _showUserMenuBottomSheet(BuildContext context) async {
    final options = [
      BottomSheetOption<String>(
        value: 'profile',
        title: 'Perfil',
        subtitle: 'Ver e editar informações do perfil',
        icon: Icons.person_outline,
        color: AppColors.primaryPurple,
      ),
      BottomSheetOption<String>(
        value: 'settings',
        title: 'Configurações',
        subtitle: 'Preferências e configurações do app',
        icon: Icons.settings_outlined,
        color: AppColors.primaryPurple,
      ),
      BottomSheetOption<String>(
        value: 'logout',
        title: 'Sair',
        subtitle: 'Fazer logout da conta',
        icon: Icons.logout,
        color: Colors.red[600],
      ),
    ];

    final String? selectedOption =
        await _showOptionsBottomSheet<String>(
          context: context,
          title: 'Menu do Usuário',
          subtitle: 'Escolha uma opção',
          options: options,
        );

    if (selectedOption != null) {
      switch (selectedOption) {
        case 'profile':
          _showProfile();
          break;
        case 'settings':
          _showSettings();
          break;
        case 'logout':
          _logout();
          break;
      }
    }
  }

  /// Mostrar bottom sheet com lista de opções
  Future<T?> _showOptionsBottomSheet<T>({
    required BuildContext context,
    required String title,
    String? subtitle,
    required List<BottomSheetOption<T>> options,
    bool showCancel = true,
    String cancelText = 'Cancelar',
  }) async {
    return await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bottomSheetContext) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                _buildHandleBar(),
                const SizedBox(height: 20),

                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Subtitle
                if (subtitle != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // Options
                ...options.map((option) => _buildOptionTile(
                  context: bottomSheetContext,
                  option: option,
                )),

                // Cancel button
                if (showCancel) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.of(bottomSheetContext).pop(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        cancelText,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],

                // Bottom padding for safe area
                SizedBox(height: MediaQuery.of(context).padding.bottom),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Construir handle bar (barra no topo do bottom sheet)
  static Widget _buildHandleBar() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  /// Construir tile de opção
  Widget _buildOptionTile<T>({
    required BuildContext context,
    required BottomSheetOption<T> option,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => Navigator.of(context).pop(option.value),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[200]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              if (option.icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (option.color ?? AppColors.primaryPurple).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    option.icon,
                    color: option.color ?? AppColors.primaryPurple,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
              ],

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (option.subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        option.subtitle!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProfile() {
    // Implementar lógica para mostrar perfil do usuário
  }

  void _showSettings() {
    // Implementar lógica para mostrar configurações do usuário
  }

  void _logout() {
    // Implementar lógica para logout do usuário
  }
}
