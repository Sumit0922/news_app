import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orbit_news/widgets/app_button.dart';
import 'package:orbit_news/widgets/app_text.dart';
import 'package:orbit_news/widgets/fade_in.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/utils/validators.dart';
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

  final _remember = ValueNotifier<bool>(true);
  final _obscure = ValueNotifier<bool>(true);

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

    if (context.reduceMotion) {
      _animation.stop();
    } else if (!_animation.isAnimating) {
      _animation.repeat();
    }
  }

  void _submit() {
    if (ref.read(authProvider).busy) return;
    if (!(_form.currentState?.validate() ?? false)) return;

    FocusScope.of(context).unfocus();

    ref
        .read(authProvider.notifier)
        .signIn(_email.text, _password.text, remember: _remember.value);
  }

  @override
  void dispose() {
    _animation.dispose();
    _email.dispose();
    _password.dispose();
    _remember.dispose();
    _obscure.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authProvider);
    final colors = context.colors;

    return Scaffold(
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
                final keyboardOpen =
                    MediaQuery.viewInsetsOf(context).bottom > 0;

                final compact = constraints.maxHeight < 650 || keyboardOpen;

                final verticalPadding = compact ? 16.0 : 24.0;

                return SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
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
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: FadeIn(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          colors.primary,
                                          Color.lerp(
                                            colors.primary,
                                            colors.tertiary,
                                            0.6,
                                          )!,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: colors.primary.withValues(
                                            alpha: 0.25,
                                          ),
                                          blurRadius: 20,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.newspaper_rounded,
                                      color: colors.onPrimary,
                                      size: 25,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  const Expanded(
                                    child: AppText(
                                      AppStrings.appName,
                                      variant: AppTextStyle.heading,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: compact ? 24 : 36),
                              Container(
                                width: 32,
                                height: 3,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [colors.primary, colors.tertiary],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                AppStrings.welcome,
                                style: context.textTheme.headlineMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.8,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              const AppText(
                                AppStrings.loginSubtitle,
                                variant: AppTextStyle.small,
                              ),
                              SizedBox(height: compact ? 20 : 28),
                              AutofillGroup(
                                child: Form(
                                  key: _form,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      TextFormField(
                                        controller: _email,
                                        enabled: !state.busy,
                                        validator: Validators.email,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textInputAction: TextInputAction.next,
                                        autofillHints: const [
                                          AutofillHints.email,
                                        ],
                                        autocorrect: false,
                                        decoration: _inputDecoration(
                                          context,
                                          label: AppStrings.email,
                                          hint: AppStrings.emailHint,
                                          icon: Icons.alternate_email_rounded,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      ValueListenableBuilder<bool>(
                                        valueListenable: _obscure,
                                        builder: (context, obscure, child) {
                                          return TextFormField(
                                            controller: _password,
                                            enabled: !state.busy,
                                            validator: Validators.password,
                                            obscureText: obscure,
                                            textInputAction:
                                                TextInputAction.done,
                                            onFieldSubmitted: (_) => _submit(),
                                            autofillHints: const [
                                              AutofillHints.password,
                                            ],
                                            enableSuggestions: false,
                                            autocorrect: false,
                                            maxLength: 72,
                                            decoration:
                                                _inputDecoration(
                                                  context,
                                                  label: AppStrings.password,
                                                  hint: AppStrings.passwordHint,
                                                  icon: Icons
                                                      .lock_outline_rounded,
                                                ).copyWith(
                                                  counterText: '',
                                                  suffixIcon: IconButton(
                                                    tooltip: obscure
                                                        ? AppStrings
                                                              .showPassword
                                                        : AppStrings
                                                              .hidePassword,
                                                    onPressed: state.busy
                                                        ? null
                                                        : () {
                                                            _obscure.value =
                                                                !obscure;
                                                          },
                                                    icon: Icon(
                                                      obscure
                                                          ? Icons
                                                                .visibility_outlined
                                                          : Icons
                                                                .visibility_off_outlined,
                                                      size: 21,
                                                    ),
                                                  ),
                                                ),
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 4),
                                      ValueListenableBuilder<bool>(
                                        valueListenable: _remember,
                                        builder: (context, remember, child) {
                                          return CheckboxListTile(
                                            value: remember,
                                            contentPadding: EdgeInsets.zero,
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            title: const AppText(
                                              AppStrings.remember,
                                              variant: AppTextStyle.small,
                                            ),
                                            onChanged: state.busy
                                                ? null
                                                : (value) {
                                                    _remember.value =
                                                        value ?? false;
                                                  },
                                          );
                                        },
                                      ),
                                      if (state.error != null)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 12,
                                          ),
                                          child: Semantics(
                                            liveRegion: true,
                                            child: AppText(
                                              state.error!,
                                              variant: AppTextStyle.small,
                                              color: colors.error,
                                            ),
                                          ),
                                        ),
                                      const SizedBox(height: 8),
                                      AppButton(
                                        label: AppStrings.signIn,
                                        icon: Icons.arrow_forward_rounded,
                                        busy: state.busy,
                                        onPressed: _submit,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const AppText(
                                AppStrings.demoNotice,
                                variant: AppTextStyle.caption,
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
    );
  }

  InputDecoration _inputDecoration(
    BuildContext context, {
    required String label,
    required String hint,
    required IconData icon,
  }) {
    final colors = context.colors;
    final radius = BorderRadius.circular(16);

    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, size: 21),
      filled: true,
      fillColor: Color.alphaBlend(
        colors.primary.withValues(alpha: 0.035),
        colors.surface,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(borderRadius: radius),
      enabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(
          color: colors.outlineVariant.withValues(alpha: 0.7),
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(
          color: colors.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: colors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: colors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: colors.error, width: 1.5),
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

    for (var i = 0; i < _stars.length; i++) {
      final star = _stars[i];

      final position = Offset(
        star.dx * size.width,
        star.dy * size.height + math.sin(phase + i * 0.7) * 2,
      );

      final twinkle = 0.5 + 0.5 * math.sin(phase * 2 + i * 1.7);

      final behindForm =
          star.dx > 0.12 && star.dx < 0.88 && star.dy > 0.22 && star.dy < 0.80;

      final visibility = behindForm ? 0.18 : 1.0;

      final opacity = (dark ? 0.20 : 0.12) + twinkle * (dark ? 0.50 : 0.25);

      final radius = i % 9 == 0
          ? 1.7
          : i % 3 == 0
          ? 1.1
          : 0.7;

      paint
        ..style = PaintingStyle.fill
        ..color = starColor.withValues(alpha: opacity * visibility);

      canvas.drawCircle(position, radius, paint);

      if (i % 13 == 0 && !behindForm) {
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
