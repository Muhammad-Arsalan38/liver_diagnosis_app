import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(
    MaterialApp(
      title: 'Liver Diagnosis',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SecondScreen(),
    ),
  );
}

// Color Scheme
const Color primaryColor = Color(0xFF1976D2);
const Color secondaryColor = Color(0xFF0097A7);
const Color backgroundColor = Color(0xFFF5F5F5);
const Color warningColor = Color(0xFFFFA000);
const Color dangerColor = Color(0xFFD32F2F);
const Color successColor = Color(0xFF388E3C);

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Liver Diagnosis'),
        centerTitle: true,
        elevation: 4,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        color: backgroundColor,
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: screenWidth * 0.5,
                  height: screenWidth * 0.4,
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.asset(
                      'assets/liver.png',
                      fit: BoxFit.contain,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            color: Colors.grey[100],
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.broken_image,
                                    size: 10,
                                    color: Colors.grey[250],
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Liver image not available',
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                        255,
                                        224,
                                        202,
                                        202,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    ),
                  ),
                ),

                Text(
                  'Liver Health Assessment',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Select your assessment method',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                SizedBox(height: 40),

                _buildActionButton(
                  context,
                  'Upload Ultrasound Image',
                  Icons.photo_library,
                  Colors.teal,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ImageUploadPage()),
                  ),
                ),
                SizedBox(height: 20),
                _buildActionButton(
                  context,
                  'Enter Clinical Values',
                  Icons.medical_services,
                  secondaryColor,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InputFormScreen()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String text,
    IconData icon,
    Color color,
    Function() onPressed,
  ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 24),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(text, style: TextStyle(fontSize: 18)),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
      ),
    );
  }
}

class ImageUploadPage extends StatefulWidget {
  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  File? _image;
  bool _isProcessing = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _processImage() {
    setState(() => _isProcessing = true);
    Future.delayed(Duration(seconds: 2), () {
      setState(() => _isProcessing = false);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => ResultsScreen(
                result: DiagnosisResult(
                  riskLevel: RiskLevel.moderate,
                  parameters: {
                    'Age': '45',
                    'Direct_Bilrubin': '0.5',
                    'Alkaline_Phosphotase': '120',
                    'Alamine_Aminotransferase': '35',
                    'Aspartate_Aminatransferase': '40',
                    'Albumin': '4.2',
                    'Albumin_and_Globulin_Ratio': '1.5',
                  },
                  recommendations:
                      'Follow up with hepatologist. Reduce alcohol intake and maintain healthy diet.',
                ),
              ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ultrasound Analysis'),
        backgroundColor: primaryColor,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        color: backgroundColor,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(Icons.biotech, color: primaryColor, size: 36),
                    SizedBox(height: 12),
                    Text(
                      'Upload Liver Ultrasound',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'For best results, use a clear transverse view of the liver',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            Expanded(
              child:
                  _image == null
                      ? InkWell(
                        onTap: _pickImage,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.add_photo_alternate,
                                  size: 60,
                                  color: primaryColor.withOpacity(0.7),
                                ),
                              ),
                              SizedBox(height: 24),
                              Text(
                                'Tap to select an image',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Upload a clear ultrasound image',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Image.file(
                                _image!,
                                fit: BoxFit.contain,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                              Positioned(
                                bottom: 16,
                                right: 16,
                                child: FloatingActionButton(
                                  mini: true,
                                  backgroundColor: primaryColor,
                                  onPressed: _pickImage,
                                  child: Icon(Icons.edit),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
            ),
            SizedBox(height: 24),

            if (_image != null && !_isProcessing)
              ElevatedButton.icon(
                icon: Icon(Icons.analytics, size: 24),
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text('Analyze Image', style: TextStyle(fontSize: 18)),
                ),
                onPressed: _processImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
              ),
            if (_isProcessing)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          secondaryColor,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Analyzing image...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: secondaryColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Please wait while we process your ultrasound',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            if (_image == null && !_isProcessing)
              ElevatedButton.icon(
                icon: Icon(Icons.upload_file, size: 24),
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text('Select Image', style: TextStyle(fontSize: 18)),
                ),
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class InputFormScreen extends StatefulWidget {
  @override
  _InputFormScreenState createState() => _InputFormScreenState();
}

class _InputFormScreenState extends State<InputFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _directBilrubinController = TextEditingController();
  final _alkalinePhosphotaseController = TextEditingController();
  final _alamineAminotransferaseController = TextEditingController();
  final _aspartateAminatransferaseController = TextEditingController();
  final _albuminController = TextEditingController();
  final _albuminGlobulinRatioController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _ageController.dispose();
    _directBilrubinController.dispose();
    _alkalinePhosphotaseController.dispose();
    _alamineAminotransferaseController.dispose();
    _aspartateAminatransferaseController.dispose();
    _albuminController.dispose();
    _albuminGlobulinRatioController.dispose();
    super.dispose();
  }

  String? _validateAge(String? value) {
    if (value == null || value.isEmpty) return 'Required';
    final age = int.tryParse(value);
    if (age == null) return 'Enter valid number';
    if (age < 0 || age > 120) return 'Enter valid age (0-120)';
    return null;
  }

  String? _validateDirectBilrubin(String? value) {
    if (value == null || value.isEmpty) return 'Required';
    final val = double.tryParse(value);
    if (val == null) return 'Enter valid number';
    if (val < 0) return 'Must be positive';
    return null;
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    Future.delayed(Duration(seconds: 1), () {
      setState(() => _isSubmitting = false);

      final alamineAminotransferase =
          double.tryParse(_alamineAminotransferaseController.text) ?? 0;
      final aspartateAminatransferase =
          double.tryParse(_aspartateAminatransferaseController.text) ?? 0;

      RiskLevel riskLevel;
      if (alamineAminotransferase > 100 || aspartateAminatransferase > 100) {
        riskLevel = RiskLevel.high;
      } else if (alamineAminotransferase > 50 ||
          aspartateAminatransferase > 50) {
        riskLevel = RiskLevel.moderate;
      } else {
        riskLevel = RiskLevel.low;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => ResultsScreen(
                result: DiagnosisResult(
                  riskLevel: riskLevel,
                  parameters: {
                    'Age': _ageController.text,
                    'Direct_Bilrubin': _directBilrubinController.text,
                    'Alkaline_Phosphotase': _alkalinePhosphotaseController.text,
                    'Alamine_Aminotransferase':
                        _alamineAminotransferaseController.text,
                    'Aspartate_Aminatransferase':
                        _aspartateAminatransferaseController.text,
                    'Albumin': _albuminController.text,
                    'Albumin_and_Globulin_Ratio':
                        _albuminGlobulinRatioController.text,
                  },
                  recommendations: _getRecommendations(riskLevel),
                ),
              ),
        ),
      );
    });
  }

  String _getRecommendations(RiskLevel riskLevel) {
    switch (riskLevel) {
      case RiskLevel.low:
        return 'Liver enzyme levels appear normal. Maintain regular checkups and healthy lifestyle.';
      case RiskLevel.moderate:
        return 'Mild liver enzyme elevation detected. Consult hepatologist. Reduce alcohol and maintain healthy diet.';
      case RiskLevel.high:
        return 'Significant liver enzyme elevation detected. Urgent consultation with hepatologist recommended. Further diagnostic tests may be needed.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clinical Assessment'),
        backgroundColor: primaryColor,
      ),
      body: Container(
        color: backgroundColor,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Liver Parameters',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: 16),
                _buildNumberInputField(
                  label: 'Age',
                  controller: _ageController,
                  validator: _validateAge,
                  icon: Icons.person,
                  tooltip: 'Patient age in years',
                ),
                _buildNumberInputField(
                  label: 'Direct_Bilrubin',
                  controller: _directBilrubinController,
                  validator: _validateDirectBilrubin,
                  icon: Icons.water,
                  tooltip: 'Normal < 0.3',
                ),
                _buildNumberInputField(
                  label: 'Alkaline_Phosphotase',
                  controller: _alkalinePhosphotaseController,
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                  icon: Icons.science,
                  tooltip: 'Normal 44-147',
                ),
                _buildNumberInputField(
                  label: 'Alamine_Aminotransferase',
                  controller: _alamineAminotransferaseController,
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                  icon: Icons.show_chart,
                  tooltip: 'Normal 7-56',
                ),
                _buildNumberInputField(
                  label: 'Aspartate_Aminatransferase',
                  controller: _aspartateAminatransferaseController,
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                  icon: Icons.graphic_eq,
                  tooltip: 'Normal 5-40',
                ),
                _buildNumberInputField(
                  label: 'Albumin',
                  controller: _albuminController,
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                  icon: Icons.bloodtype,
                  tooltip: 'Normal 3.4-5.4',
                ),
                _buildNumberInputField(
                  label: 'Albumin_and_Globulin_Ratio',
                  controller: _albuminGlobulinRatioController,
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                  icon: Icons.compare,
                  tooltip: 'Normal 0.8-2.0',
                ),
                SizedBox(height: 24),
                if (_isSubmitting)
                  Center(child: CircularProgressIndicator())
                else
                  ElevatedButton.icon(
                    icon: Icon(Icons.analytics),
                    label: Text('Analyze Results'),
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNumberInputField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?)? validator,
    required IconData icon,
    String? tooltip,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Enter $label',
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(),
          suffixIcon:
              tooltip != null
                  ? Tooltip(
                    message: tooltip,
                    child: Icon(Icons.info_outline, size: 20),
                  )
                  : null,
        ),
        validator: validator,
      ),
    );
  }
}

class ResultsScreen extends StatelessWidget {
  final DiagnosisResult result;

  const ResultsScreen({Key? key, required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diagnosis Results'),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // Implement share functionality
            },
          ),
        ],
      ),
      body: Container(
        color: backgroundColor,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: _getRiskColor(result.riskLevel),
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(_getRiskIcon(result.riskLevel), size: 28),
                          SizedBox(width: 10),
                          Text(
                            _getRiskTitle(result.riskLevel),
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        _getRiskDescription(result.riskLevel),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              Text(
                'Assessment Parameters',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              SizedBox(height: 10),
              Card(
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Table(
                    columnWidths: {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(3),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(color: Colors.grey[200]),
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              'Parameter',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              'Value',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      ...result.parameters.entries.map((entry) {
                        return TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              
                              child: Text(entry.key),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(entry.value),
                            ),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              Text(
                'Recommendations',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              SizedBox(height: 10),
              Card(
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(result.recommendations),
                ),
              ),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: Text('Return to Home'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InputFormScreen()),
                  );
                },
                child: Text('New Assessment'),
                style: OutlinedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getRiskColor(RiskLevel level) {
    switch (level) {
      case RiskLevel.low:
        return successColor;
      case RiskLevel.moderate:
        return warningColor;
      case RiskLevel.high:
        return dangerColor;
    }
  }

  IconData _getRiskIcon(RiskLevel level) {
    switch (level) {
      case RiskLevel.low:
        return Icons.check_circle;
      case RiskLevel.moderate:
        return Icons.warning;
      case RiskLevel.high:
        return Icons.error;
    }
  }

  String _getRiskTitle(RiskLevel level) {
    switch (level) {
      case RiskLevel.low:
        return 'Low Risk';
      case RiskLevel.moderate:
        return 'Moderate Risk';
      case RiskLevel.high:
        return 'High Risk';
    }
  }

  String _getRiskDescription(RiskLevel level) {
    switch (level) {
      case RiskLevel.low:
        return 'No significant abnormalities detected';
      case RiskLevel.moderate:
        return 'Mild abnormalities requiring attention';
      case RiskLevel.high:
        return 'Significant abnormalities requiring medical attention';
    }
  }
}

enum RiskLevel { low, moderate, high }

class DiagnosisResult {
  final RiskLevel riskLevel;
  final Map<String, String> parameters;
  final String recommendations;

  DiagnosisResult({
    required this.riskLevel,
    required this.parameters,
    required this.recommendations,
  });
}
