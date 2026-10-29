import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/utils/validators.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/fade_in.dart';
import 'auth_view_model.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _form = GlobalKey<FormState>();

  final _email = TextEditingController();
  final _password = TextEditingController();

  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _remember = true;
  bool _obscure = true;

  late final AnimationController _animation;

  @override
  void initState() {
    super.initState();

    _animation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (context.reduceMotion || !TickerMode.valuesOf(context).enabled) {
      _animation.stop();
    }else if (!_animation.isAnimating) {
      _animation.repeat();
    }
  }

  void _submit() {
    if (ref.read(authProvider).busy) return;
    if (!(_form.currentState?.validate() ?? false)) return;

    FocusManager.instance.primaryFocus?.unfocus();

    ref
        .read(authProvider.notifier)
        .signIn(_email.text.trim(), _password.text, remember: _remember);
  }

  @override
  void dispose() {
    _animation.dispose();
    _email.dispose();
    _password.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final colors = Theme.of(context).colorScheme;

    return PopScope(
      canPop: !auth.busy,
      child: Scaffold(
        backgroundColor: colors.surface,
        body: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: ExcludeSemantics(
                  child: _GalaxyBackground(animation: _animation),
                ),
              ),
            ),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxHeight < 680;
                  final verticalPadding = compact ? 16.0 : 28.0;

                  return SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: verticalPadding,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: math.max(
                          0.0,
                          constraints.maxHeight - verticalPadding * 2,
                        ),
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 440),
                          child: FadeIn(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildBrand(context),
                                SizedBox(height: compact ? 22 : 30),
                                _buildFormCard(context, auth),
                                const SizedBox(height: 16),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Text(
                                    AppStrings.demoNotice,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(height: 1.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrand(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: colors.primary,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.onPrimary.withValues(alpha: 0.12)),
          ),
          child: Icon(
            Icons.auto_awesome_rounded,
            size: 22,
            color: colors.onPrimary,
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.appName,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(AppStrings.tagline, style: theme.textTheme.labelSmall),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard(BuildContext context, AuthState auth) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final dark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: dark ? 0.92 : 0.94),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colors.primary.withValues(alpha: dark ? 0.25 : 0.16),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: dark ? 0.12 : 0.04),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: AutofillGroup(
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'WELCOME TO ORBIT',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 9),
              Text(
                AppStrings.welcome,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                  letterSpacing: -0.7,
                ),
              ),
              const SizedBox(height: 9),
              Text(
                AppStrings.loginSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
              ),
              const SizedBox(height: 20),
              Divider(
                height: 1,
                color: colors.outlineVariant.withValues(alpha: 0.45),
              ),
              const SizedBox(height: 20),

              _fieldLabel(context, AppStrings.email),
              const SizedBox(height: 7),
              TextFormField(
                controller: _email,
                focusNode: _emailFocus,
                enabled: !auth.busy,
                validator: Validators.email,
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                autocorrect: false,
                enableSuggestions: false,
                style: theme.textTheme.bodyLarge,
                onFieldSubmitted: (_) {
                  _passwordFocus.requestFocus();
                },
                onTapOutside: (_) {
                  _emailFocus.unfocus();
                },
                decoration: _inputDecoration(
                  context,
                  hint: AppStrings.emailHint,
                  icon: Icons.alternate_email_rounded,
                ),
              ),
              const SizedBox(height: 16),

              _fieldLabel(context, AppStrings.password),
              const SizedBox(height: 7),
              TextFormField(
                controller: _password,
                focusNode: _passwordFocus,
                enabled: !auth.busy,
                validator: Validators.password,
                obscureText: _obscure,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                enableSuggestions: false,
                autocorrect: false,
                maxLength: 72,
                style: theme.textTheme.bodyLarge,
                onFieldSubmitted: (_) => _submit(),
                onTapOutside: (_) {
                  _passwordFocus.unfocus();
                },
                decoration:
                    _inputDecoration(
                      context,
                      hint: AppStrings.passwordHint,
                      icon: Icons.lock_outline_rounded,
                    ).copyWith(
                      counterText: '',
                      suffixIcon: IconButton(
                        tooltip: _obscure
                            ? AppStrings.showPassword
                            : AppStrings.hidePassword,
                        onPressed: auth.busy
                            ? null
                            : () {
                                setState(() {
                                  _obscure = !_obscure;
                                });
                              },
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 19,
                        ),
                      ),
                    ),
              ),
              const SizedBox(height: 5),

              CheckboxListTile(
                value: _remember,
                contentPadding: EdgeInsets.zero,
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(
                  AppStrings.remember,
                  style: theme.textTheme.bodyMedium,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onChanged: auth.busy
                    ? null
                    : (value) {
                        setState(() {
                          _remember = value ?? false;
                        });
                      },
              ),

              AnimatedSize(
                duration: context.reduceMotion
                    ? Duration.zero
                    : const Duration(milliseconds: 180),
                alignment: Alignment.topLeft,
                child: auth.error == null
                    ? const SizedBox(width: double.infinity)
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Semantics(
                          liveRegion: true,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: colors.error.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: colors.error.withValues(alpha: 0.16),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                  size: 16,
                                  color: colors.error,
                                ),
                                const SizedBox(width: 7),
                                Expanded(
                                  child: Text(
                                    auth.error!,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colors.error,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),

              const SizedBox(height: 6),
              AppButton(
                label: AppStrings.signIn,
                icon: Icons.arrow_forward_rounded,
                busy: auth.busy,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fieldLabel(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelLarge
          ?.copyWith(fontWeight: FontWeight.w600),
    );
  }

  InputDecoration _inputDecoration(
    BuildContext context, {
    required String hint,
    required IconData icon,
  }) {
    final colors = Theme.of(context).colorScheme;

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(13),
      borderSide: BorderSide(
        color: colors.outlineVariant.withValues(alpha: 0.65),
      ),
    );

    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, size: 18, color: colors.onSurfaceVariant),
      filled: true,
      fillColor: colors.surfaceContainerLow,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: border,
      enabledBorder: border,
      disabledBorder: border.copyWith(
        borderSide: BorderSide(
          color: colors.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      focusedBorder: border.copyWith(
        borderSide: BorderSide(color: colors.primary, width: 1.3),
      ),
      errorBorder: border.copyWith(borderSide: BorderSide(color: colors.error)),
      focusedErrorBorder: border.copyWith(
        borderSide: BorderSide(color: colors.error, width: 1.3),
      ),
    );
  }
}

class _GalaxyBackground extends StatelessWidget {
  const _GalaxyBackground({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dark = Theme.of(context).brightness == Brightness.dark;

    return RepaintBoundary(
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: dark
                    ? [
                        const Color(0xFF090D1C),
                        colors.surface,
                        const Color(0xFF151027),
                      ]
                    : [
                        Color.alphaBlend(
                          const Color(0xFF818CF8).withValues(alpha: 0.08),
                          colors.surface,
                        ),
                        colors.surface,
                        Color.alphaBlend(
                          const Color(0xFFA78BFA).withValues(alpha: 0.08),
                          colors.surface,
                        ),
                      ],
              ),
            ),
          ),
          Positioned(
            top: -130,
            right: -150,
            child: _NebulaGlow(
              size: 450,
              color: const Color(0xFF818CF8),
              opacity: dark ? 0.20 : 0.10,
            ),
          ),
          Positioned(
            bottom: -160,
            left: -150,
            child: _NebulaGlow(
              size: 460,
              color: const Color(0xFFA855F7),
              opacity: dark ? 0.17 : 0.08,
            ),
          ),
          Positioned(
            top: 80,
            left: -180,
            child: _NebulaGlow(
              size: 320,
              color: const Color(0xFF38BDF8),
              opacity: dark ? 0.09 : 0.04,
            ),
          ),
          RepaintBoundary(
            child: CustomPaint(
              painter: _GalaxyPainter(
                animation: animation,
                starColor: dark
                    ? const Color(0xFFE0E7FF)
                    : const Color(0xFF6366A0),
                orbitColor: dark ? const Color(0xFFA5B4FC) : colors.primary,
                dark: dark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NebulaGlow extends StatelessWidget {
  const _NebulaGlow({
    required this.size,
    required this.color,
    required this.opacity,
  });

  final double size;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: opacity),
              color.withValues(alpha: opacity * 0.35),
              color.withValues(alpha: 0),
            ],
            stops: const [0, 0.45, 1],
          ),
        ),
      ),
    );
  }
}

class _GalaxyPainter extends CustomPainter {
  _GalaxyPainter({
    required this.animation,
    required this.starColor,
    required this.orbitColor,
    required this.dark,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color starColor;
  final Color orbitColor;
  final bool dark;

  static final List<Offset> _stars = List.generate(100, (index) {
    final random = math.Random(index * 97 + 11);

    return Offset(random.nextDouble(), random.nextDouble());
  }, growable: false);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    canvas.save();
    canvas.clipRect(Offset.zero & size);

    final phase = animation.value * math.pi * 2;
    final paint = Paint();

    for (var index = 0; index < _stars.length; index++) {
      final star = _stars[index];

      final position = Offset(
        star.dx * size.width,
        star.dy * size.height + math.sin(phase + index * 0.7) * 2,
      );

      final twinkle = 0.5 + 0.5 * math.sin(phase * 2 + index * 1.7);

      final behindForm =
          star.dx > 0.12 && star.dx < 0.88 && star.dy > 0.22 && star.dy < 0.80;

      final visibility = behindForm ? 0.18 : 1.0;

      final opacity = (dark ? 0.20 : 0.12) + twinkle * (dark ? 0.50 : 0.25);

      final radius = index % 9 == 0
          ? 1.7
          : index % 3 == 0
          ? 1.1
          : 0.7;

      paint
        ..style = PaintingStyle.fill
        ..color = starColor.withValues(alpha: opacity * visibility);

      canvas.drawCircle(position, radius, paint);

      if (index % 13 == 0 && !behindForm) {
        _drawSparkle(canvas, position, radius * 3, opacity * 0.6);
      }
    }

    _drawOrbit(
      canvas,
      center: Offset(size.width * 0.90, size.height * 0.10),
      radiusX: size.width * 0.36,
      radiusY: size.width * 0.14,
      rotation: -0.45,
      phase: phase,
    );

    _drawOrbit(
      canvas,
      center: Offset(size.width * 0.08, size.height * 0.93),
      radiusX: size.width * 0.40,
      radiusY: size.width * 0.16,
      rotation: -0.40,
      phase: -phase + math.pi,
    );

    canvas.restore();
  }

  void _drawSparkle(
    Canvas canvas,
    Offset center,
    double radius,
    double opacity,
  ) {
    final paint = Paint()
      ..color = starColor.withValues(alpha: opacity)
      ..strokeWidth = 0.8
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      center.translate(-radius, 0),
      center.translate(radius, 0),
      paint,
    );

    canvas.drawLine(
      center.translate(0, -radius),
      center.translate(0, radius),
      paint,
    );
  }

  void _drawOrbit(
    Canvas canvas, {
    required Offset center,
    required double radiusX,
    required double radiusY,
    required double rotation,
    required double phase,
  }) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);

    final orbit = Rect.fromCenter(
      center: Offset.zero,
      width: radiusX * 2,
      height: radiusY * 2,
    );

    canvas.drawOval(
      orbit,
      Paint()
        ..color = orbitColor.withValues(alpha: dark ? 0.14 : 0.09)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );

    canvas.drawArc(
      orbit,
      phase - 0.55,
      0.55,
      false,
      Paint()
        ..color = orbitColor.withValues(alpha: dark ? 0.35 : 0.20)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..strokeCap = StrokeCap.round,
    );

    final planet = Offset(math.cos(phase) * radiusX, math.sin(phase) * radiusY);

    canvas.drawCircle(
      planet,
      9,
      Paint()
        ..shader = RadialGradient(
          colors: [
            orbitColor.withValues(alpha: dark ? 0.35 : 0.20),
            orbitColor.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: planet, radius: 9)),
    );

    canvas.drawCircle(
      planet,
      2.5,
      Paint()..color = orbitColor.withValues(alpha: dark ? 0.9 : 0.65),
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _GalaxyPainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.starColor != starColor ||
        oldDelegate.orbitColor != orbitColor ||
        oldDelegate.dark != dark;
  }
}
