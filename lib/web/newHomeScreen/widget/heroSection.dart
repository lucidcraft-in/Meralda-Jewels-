import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/textColor.dart';

class BuildHeroSection extends StatelessWidget {
  const BuildHeroSection({
    super.key,
    required this.isMobile,
    this.isTablet = false,
    required this.onExplorePlans,
  });

  final bool isMobile;
  final bool isTablet;
  final VoidCallback onExplorePlans;

  @override
  Widget build(BuildContext context) {
    final double height = isMobile
        ? 500
        : isTablet
            ? 600
            : 750;
    final double horizontalPadding = isMobile
        ? 20
        : isTablet
            ? 48
            : 80;
    final double verticalPadding = isMobile
        ? 30
        : isTablet
            ? 50
            : 60;

    final double screenWidth = MediaQuery.of(context).size.width;
    final bool useColumnLayout = isMobile || screenWidth < 900;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: useColumnLayout ? 900 : height,
      ),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=1600'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              const Color(0xFF1A4D3E).withOpacity(0.95),
              const Color(0xFF1A4D3E).withOpacity(0.65),
            ],
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: useColumnLayout
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GoldSavingsSection(onExplorePlans: onExplorePlans),
                      const SizedBox(height: 40),
                      const Center(child: HeroLeadForm()),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 5,
                        child:
                            GoldSavingsSection(onExplorePlans: onExplorePlans),
                      ),
                      const SizedBox(width: 50),
                      const Expanded(
                        flex: 4,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: HeroLeadForm(),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class GoldSavingsSection extends StatefulWidget {
  const GoldSavingsSection({super.key, required this.onExplorePlans});
  final VoidCallback onExplorePlans;

  @override
  State<GoldSavingsSection> createState() => _GoldSavingsSectionState();
}

class _GoldSavingsSectionState extends State<GoldSavingsSection>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<String> bulletPoints = [
    "100% BIS Hallmarked",
    "Guaranteed Purity",
    "Flexible Payment Options",
  ];

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 600;
    final bool isTablet = width >= 600 && width < 1024;

    final double titleSize = isMobile
        ? 34
        : isTablet
            ? 44
            : 52;
    final double subtitleSize = isMobile
        ? 13
        : isTablet
            ? 15
            : 16;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Tag
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: const Color.fromARGB(64, 212, 166, 116),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.auto_awesome,
                  color: Color(0xFFD4A574), size: 14),
              const SizedBox(width: 6),
              Text(
                'A Medley of Desires',
                style: TextStyle(
                  color: ColorConstant.whiteText,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Title
        Text(
          'Start Your Gold\nSavings Journey Today',
          style: TextStyle(
            fontFamily: "playfair",
            fontSize: titleSize,
            fontWeight: FontWeight.bold,
            color: ColorConstant.whiteText,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 16),

        // Subtitle
        Text(
          'Own your dream jewellery with easy monthly installments. Choose from our Aspire and Wishlist plans designed to make luxury accessible.',
          style: TextStyle(
            fontSize: subtitleSize,
            color: ColorConstant.whiteText,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 30),

        // Button with hover
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: widget.onExplorePlans,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
              decoration: BoxDecoration(
                color: _isHovered
                    ? const Color(0xFFC4925F)
                    : const Color(0xFFD4A574),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Explore Plans',
                    style: TextStyle(
                      color: Color(0xFF1A4D3E),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, color: Color(0xFF1A4D3E), size: 18),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),

        // Animated bullet tags
        Wrap(
          spacing: 20,
          runSpacing: 8,
          children: bulletPoints.map((text) {
            return AnimatedBuilder(
              animation: _animation,
              builder: (context, child) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.lerp(
                        const Color(0xFFD4A574).withOpacity(0.6),
                        const Color(0xFFD4A574),
                        _animation.value,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    text,
                    style: TextStyle(
                      color: ColorConstant.whiteText,
                      fontSize: isMobile ? 11 : 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class HeroLeadForm extends StatefulWidget {
  const HeroLeadForm({super.key});

  @override
  State<HeroLeadForm> createState() => _HeroLeadFormState();
}

class _HeroLeadFormState extends State<HeroLeadForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _msgCtrl = TextEditingController();
  String _selectedPlan = 'General Inquiry';
  bool _isSubmitting = false;
  bool _hoverSubmit = false;

  final List<String> _plans = [
    'General Inquiry',
    'Wishlist Plan',
    'Aspire Plan'
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _cityCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  Future<void> sendLeadToApi(
    String schemeName,
    String name,
    String phone,
    String message,
    String email,
    String city,
  ) async {
    final url = Uri.parse(
      "https://meralda-backend-api.vercel.app/api/add-lead",
    );

    final body = {
      "name": name,
      "phone": phone,
      "message": "Scheme: $schemeName. Message: $message",
      "email": email,
      "city": city,
    };

    try {
      await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );
    } catch (e) {
      debugPrint("Error sending lead: $e");
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      await sendLeadToApi(
        _selectedPlan,
        _nameCtrl.text.trim(),
        _phoneCtrl.text.trim(),
        _msgCtrl.text.trim(),
        _emailCtrl.text.trim(),
        _cityCtrl.text.trim(),
      );

      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
        showSuccessSnackBar(context);
        _nameCtrl.clear();
        _phoneCtrl.clear();
        _emailCtrl.clear();
        _cityCtrl.clear();
        _msgCtrl.clear();
        setState(() {
          _selectedPlan = 'General Inquiry';
        });
      }
    }
  }

  void showSuccessSnackBar(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const snackbarWidth = 420.0;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const SizedBox(
          width: snackbarWidth,
          child: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 22,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Request Submitted Successfully',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Our staff will contact you soon.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        margin: screenWidth > snackbarWidth + 40
            ? EdgeInsets.only(
                left: screenWidth - snackbarWidth - 24,
                bottom: 16,
                right: 16,
              )
            : const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A4D3E),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(fontSize: 12, color: Color(0xFF333333)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFF1A4D3E)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 400),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Are you interested...!',
              style: TextStyle(
                fontSize: 18,
                fontFamily: "playfair",
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A4D3E),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Submit details to explore saving plans.',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 12),
            _buildFieldLabel('Name *'),
            _buildTextField(_nameCtrl, 'Enter your name', validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Name is required';
              return null;
            }),
            const SizedBox(height: 10),
            _buildFieldLabel('Phone *'),
            _buildTextField(_phoneCtrl, 'Enter phone number',
                keyboardType: TextInputType.phone, validator: (v) {
              if (v == null || v.trim().isEmpty)
                return 'Phone number is required';
              return null;
            }),
            const SizedBox(height: 10),
            _buildFieldLabel('Email'),
            _buildTextField(_emailCtrl, 'Enter email address',
                keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 10),
            _buildFieldLabel('City'),
            _buildTextField(_cityCtrl, 'Enter city'),
            const SizedBox(height: 10),
            _buildFieldLabel('Select Scheme'),
            DropdownButtonFormField<String>(
              value: _selectedPlan,
              items: _plans.map((plan) {
                return DropdownMenuItem(
                  value: plan,
                  child: Text(plan,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF333333))),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedPlan = val;
                  });
                }
              },
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: Color(0xFF1A4D3E)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildFieldLabel('Message'),
            _buildTextField(_msgCtrl, 'Tell us how we can help you...',
                maxLines: 2),
            const SizedBox(height: 16),
            MouseRegion(
              onEnter: (_) => setState(() => _hoverSubmit = true),
              onExit: (_) => setState(() => _hoverSubmit = false),
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: _isSubmitting ? null : _submitForm,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _isSubmitting
                        ? Colors.grey
                        : _hoverSubmit
                            ? const Color(0xFF246956)
                            : const Color(0xFF1A4D3E),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
