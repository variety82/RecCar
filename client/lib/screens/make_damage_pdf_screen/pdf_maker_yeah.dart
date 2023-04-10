import 'dart:typed_data';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;


class PdfMakerScreen extends StatefulWidget {
  final String title;
  final Map<String, dynamic> detailRentInfo;
  final Map<String, dynamic> simpleDamageInfo;

  const PdfMakerScreen({
    required this.detailRentInfo,
    required this.simpleDamageInfo,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  State<PdfMakerScreen> createState() => _PdfMakerScreenState();
}

class _PdfMakerScreenState extends State<PdfMakerScreen> {
  List<Map<String, dynamic>> finalInfoList = [];
  List<Map<String, dynamic>> initialDetectionInfos = [];
  List<Map<String, dynamic>> latterDetectionInfos = [
    {'detectionInfoId': '507', 'part': 'front', 'damageDate': '2023-04-06', 'memo': '살려줘', 'damageImageUrl': 'https://herosbucket.s3.ap-northeast-2.amazonaws.com/hero/user_j y_2023-04-06_13-22-30_1.jpg', 'former': false, 'scratch': 0, 'breakage': 3, 'crushed': 4, 'separated': 0},
    {'detectionInfoId': '507', 'part': 'front', 'damageDate': '2023-04-06', 'memo': '살려줘', 'damageImageUrl': 'https://herosbucket.s3.ap-northeast-2.amazonaws.com/hero/user_j y_2023-04-06_13-22-30_1.jpg', 'former': false, 'scratch': 0, 'breakage': 3, 'crushed': 4, 'separated': 0},
    {'detectionInfoId': '507', 'part': 'front', 'damageDate': '2023-04-06', 'memo': '살려줘', 'damageImageUrl': 'https://herosbucket.s3.ap-northeast-2.amazonaws.com/hero/user_j y_2023-04-06_13-22-30_1.jpg', 'former': false, 'scratch': 0, 'breakage': 3, 'crushed': 4, 'separated': 0},
    {'detectionInfoId': '507', 'part': 'front', 'damageDate': '2023-04-06', 'memo': '살려줘', 'damageImageUrl': 'https://herosbucket.s3.ap-northeast-2.amazonaws.com/hero/user_j y_2023-04-06_13-22-30_1.jpg', 'former': false, 'scratch': 0, 'breakage': 3, 'crushed': 4, 'separated': 0},
  ];
  List<Map<String, dynamic>> testList = [];
  bool _isLoading = true;

  Future<List<Map<String, dynamic>>> changeImageToMemory(String dataCase) async {
    List<Map<String, dynamic>> damageInfoList = [];
    print(widget.detailRentInfo[dataCase]);

    if (widget.detailRentInfo[dataCase].isNotEmpty) {
      for (int i = 0; i < widget.detailRentInfo[dataCase].length; i++) {
        final response = await http.get(Uri.parse(widget.detailRentInfo[dataCase][i]['damageImageUrl']));
        final imageData = response.bodyBytes;
        final image = pw.MemoryImage(imageData);

        Map<String, dynamic> damageInfo = {
          'part': widget.detailRentInfo[dataCase][i]['part'],
          'damageDate': widget.detailRentInfo[dataCase][i]['damageDate'],
          'memo': widget.detailRentInfo[dataCase][i]['memo'] == '' ? '없음' : widget.detailRentInfo[dataCase][i]['memo'],
          'scratch':widget.detailRentInfo[dataCase][i]['scratch'],
          'crushed': widget.detailRentInfo[dataCase][i]['crushed'],
          'breakage': widget.detailRentInfo[dataCase][i]['breakage'],
          'separated': widget.detailRentInfo[dataCase][i]['separated'],
          'former': widget.detailRentInfo[dataCase][i]['former'],
          'damageImage': image,
        };
        damageInfoList.add(damageInfo);
      }
      return damageInfoList;
    } else {
      return [];
    }
  }

  Future<void> fetchData() async {
    await Future.delayed(const Duration(milliseconds: 10));
    initialDetectionInfos = await changeImageToMemory('initialDetectionInfos');
    latterDetectionInfos = await changeImageToMemory('latterDetectionInfos');
    // testList = await changeImageToMemory('latterDetectionInfos');
    // // initialDetectionInfos.addAll(latterDetectionInfos);
    finalInfoList.addAll(initialDetectionInfos);
    finalInfoList.addAll(latterDetectionInfos);
    print(initialDetectionInfos);
    print(latterDetectionInfos);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isLoading = false;
    });
  }

  String damageView(Map<String, dynamic> damageInfo) {
    List<String> damagedParts = [];
    print(damageInfo);
    // carDamageList의 인덱스 2, 3, 4, 5의 값을 검사하여 damagedParts 리스트에 추가
    if (damageInfo["scratch"]! > 0) {
      damagedParts.add("스크래치");
    }
    if (damageInfo["crushed"]! > 0) {
      damagedParts.add("찌그러짐");
    }
    if (damageInfo["breakage"]! > 0) {
      damagedParts.add("파손");
    }
    if (damageInfo["separated"]! > 0) {
      damagedParts.add("이격");
    }

    if (damagedParts.length > 1) {
      return damagedParts.join(', ');
    } else if (damagedParts.isNotEmpty) {
      return damagedParts[0];
    } else {
      return '없음';
    }
  }

  String damagePartView(Map<String, dynamic> damageInfo) {
    if (damageInfo['part'] == 'front') {
      return '앞펜더/앞범퍼/전조등';
    } else if (damageInfo['part'] == 'side') {
      return '옆면/사이드/스텝';
    } else if (damageInfo['part'] == 'back') {
      return '뒷펜더/뒷범퍼/후미등';
    } else if (damageInfo['part'] == 'wheel') {
      return '타이어/휠';
    } else {
      return '미정';
    }
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 24,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
            backgroundColor: Theme.of(context).primaryColor, title: Text('PDF 미리 보기', style: TextStyle(color: Colors.white, fontSize: 14,),),),
          body: _isLoading ? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,)) : PdfPreview(
            build: (format) => _generatePdf(format),
          ),
        ));
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdfTheme = pw.ThemeData.withFont(
      base: pw.Font.ttf(await rootBundle.load('lib/assets/fonts/Pretendard-Regular.ttf')),
      bold: pw.Font.ttf(await rootBundle.load('lib/assets/fonts/Pretendard-Bold.ttf')),
    );
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true, theme: pdfTheme);
    final pageFormat = PdfPageFormat.a4;
    final logoImage = await rootBundle.load('lib/assets/images/logo/reccar_logo_png_ver.PNG');
    final imageLogo = pw.MemoryImage(logoImage.buffer.asUint8List());

    pdf.addPage(
      pw.Page(
        pageFormat: pageFormat,
        build: (context) {
          return pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Column(
                children: [
                  pw.Text('렌터카 손상 보고서', style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold,
                  ),),
                  pw.SizedBox(
                    width: 20,
                    height: 28,
                  ),
                  pw.Container(
                    width: 40,
                    height: 40,
                    child: pw.FittedBox(
                      child: pw.Image(imageLogo),
                    ),
                  ),
                ]
              ),
              // pw.SizedBox(height: 20),

              pw.Column(
                children: [
                  pw.Table(
                    border: pw.TableBorder.all(color: PdfColors.black),
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            child: pw.Text(
                              '이용 정보',
                              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            padding: pw.EdgeInsets.all(10),
                          ),
                        ],
                      ),
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            child: pw.Text(
                              '대여 일자',
                            ),
                            padding: pw.EdgeInsets.all(10),
                          ),
                          pw.Padding(
                            child: pw.Text(
                              widget.detailRentInfo['rentalDate'],
                            ),
                            padding: pw.EdgeInsets.all(10),
                          ),
                        ],
                      ),
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            child: pw.Text(
                              '반납 일자',
                            ),
                            padding: pw.EdgeInsets.all(10),
                          ),
                          pw.Padding(
                            child: pw.Text(
                              widget.detailRentInfo['returnDate'],
                            ),
                            padding: pw.EdgeInsets.all(10),
                          ),
                        ],
                      ),
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            child: pw.Text(
                              '대여 업체',
                            ),
                            padding: pw.EdgeInsets.all(10),
                          ),
                          pw.Padding(
                            child: pw.Text(
                              widget.detailRentInfo['rentalCompany'],
                            ),
                            padding: pw.EdgeInsets.all(10),
                          ),
                        ],
                      ),
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            child: pw.Text(
                              '제조사',
                            ),
                            padding: pw.EdgeInsets.all(10),
                          ),
                          pw.Padding(
                            child: pw.Text(
                              widget.detailRentInfo['carManufacturer'],
                            ),
                            padding: pw.EdgeInsets.all(10),
                          ),
                        ],
                      ),
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            child: pw.Text(
                              '차종',
                            ),
                            padding: pw.EdgeInsets.all(10),
                          ),
                          pw.Padding(
                            child: pw.Text(
                              widget.detailRentInfo['carModel'],
                            ),
                            padding: pw.EdgeInsets.all(10),
                          ),
                        ],
                      ),
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            child: pw.Text(
                              '차량 번호',
                            ),
                            padding: pw.EdgeInsets.all(10),
                          ),
                          pw.Padding(
                            child: pw.Text(
                              widget.detailRentInfo['carNumber'],
                            ),
                            padding: pw.EdgeInsets.all(10),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text('* 주의: 본 문서는 참고용으로 봐주시기 바랍니다.', style: pw.TextStyle(fontSize: 14, color: PdfColor.fromInt(0xFFFF0000),
                  ),),
                ]
              )
            ],
          );
        },
      ),
    );


    pdf.addPage(pw.MultiPage(
      build: (context) => [
        for (final data in finalInfoList)
          pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(data['former'] ? '대여 직후 손상 상세' : '반납 직전 손상 상세', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold,
              ),),
              pw.SizedBox(
                height: 24,
              ),
              pw.Column(
                children: [
                  pw.Text('손상 이미지', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold,
                  ),),
                  pw.Image(data['damageImage']),
                  pw.Padding(
                    padding: pw.EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                      children: [
                        pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Container(
                              width: 10,
                              height: 10,
                              decoration: pw.BoxDecoration(
                                shape: pw.BoxShape.circle,
                                color: PdfColor.fromInt(
                                  (240 << 16) + (15 << 8) + 145,
                                ),
                              ),
                            ),
                            pw.SizedBox(
                              width: 4,
                            ),
                            pw.Text(
                              '스크래치',
                              style: pw.TextStyle(
                                fontSize: 14,
                                color: PdfColor.fromInt(
                                  (240 << 16) + (15 << 8) + 145,
                                ),
                                fontWeight: pw.FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Container(
                              width: 10,
                              height: 10,
                              decoration: pw.BoxDecoration(
                                shape: pw.BoxShape.circle,
                                color: PdfColor.fromInt(
                                  (64 << 16) + (64 << 8) + 64,
                                ),
                              ),
                            ),
                            pw.SizedBox(
                              width: 4,
                            ),
                            pw.Text(
                              '찌그러짐',
                              style: pw.TextStyle(
                                fontSize: 14,
                                color: PdfColor.fromInt(
                                  (64 << 16) + (64 << 8) + 64,
                                ),
                                fontWeight: pw.FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Container(
                              width: 10,
                              height: 10,
                              decoration: pw.BoxDecoration(
                                shape: pw.BoxShape.circle,
                                color: PdfColor.fromInt(
                                  (75 << 16) + (150 << 8) + 200,
                                )
                              ),
                            ),
                            pw.SizedBox(
                              width: 4,
                            ),
                            pw.Text(
                              '파손',
                              style: pw.TextStyle(
                                fontSize: 14,
                                color: PdfColor.fromInt(
                                  (75 << 16) + (150 << 8) + 200,
                                ),
                                fontWeight: pw.FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ]
              ),
              pw.SizedBox(height: 12,),
              pw.Column(
                children: [
                  pw.Text('손상 상세 정보', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold,
                  ),),
                  pw.SizedBox(
                    height: 14,
                  ),
                  pw.Table(
                    border: pw.TableBorder.all(color: PdfColors.black),
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            child: pw.Text(
                              '손상 등록 일자',
                            ),
                            padding: pw.EdgeInsets.all(10),
                          ),
                          pw.Padding(
                            child: pw.Text(
                              data['damageDate'],
                            ),
                            padding: pw.EdgeInsets.all(10),
                          ),
                        ],
                      ),
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            child: pw.Text(
                              '손상 종류',
                            ),
                            padding: pw.EdgeInsets.all(10),
                          ),
                          pw.Padding(
                            child: pw.Text(
                              damageView(data),
                            ),
                            padding: pw.EdgeInsets.all(10),
                          ),
                        ],
                      ),
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            child: pw.Text(
                              '손상 부위',
                            ),
                            padding: pw.EdgeInsets.all(10),
                          ),
                          pw.Padding(
                            child: pw.Text(
                              damagePartView(data),
                            ),
                            padding: pw.EdgeInsets.all(10),
                          ),
                        ],
                      ),
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            child: pw.Text(
                              '메모',
                            ),
                            padding: pw.EdgeInsets.all(10),
                          ),
                          pw.Padding(
                            child: pw.Text(
                              data['memo'],
                            ),
                            padding: pw.EdgeInsets.all(10),
                          ),
                        ],
                      ),
                    ],
                  ),
                ]
              ),
              pw.SizedBox(height: 24,),
              pw.Column(
                  children: [
                    pw.Text('손상 종류 별 개수', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold,
                    ),),
                    pw.SizedBox(
                      height: 14,
                    ),
                    pw.Table(
                      border: pw.TableBorder.all(color: PdfColors.black),
                      children: [
                        pw.TableRow(
                          children: [
                            pw.Padding(
                              child: pw.Text(
                                '스크래치',
                              ),
                              padding: pw.EdgeInsets.all(10),
                            ),
                            pw.Padding(
                              child: pw.Text(
                                '찌그러짐',
                              ),
                              padding: pw.EdgeInsets.all(10),
                            ),
                            pw.Padding(
                              child: pw.Text(
                                '파손',
                              ),
                              padding: pw.EdgeInsets.all(10),
                            ),
                            pw.Padding(
                              child: pw.Text(
                                '이격',
                              ),
                              padding: pw.EdgeInsets.all(10),
                            ),
                          ],
                        ),
                        pw.TableRow(
                          children: [
                            pw.Padding(
                              child: pw.Text(
                                data['scratch'].toString(),
                              ),
                              padding: pw.EdgeInsets.all(10),
                            ),
                            pw.Padding(
                              child: pw.Text(
                                data['crushed'].toString(),
                              ),
                              padding: pw.EdgeInsets.all(10),
                            ),
                            pw.Padding(
                              child: pw.Text(
                                data['breakage'].toString(),
                              ),
                              padding: pw.EdgeInsets.all(10),
                            ),
                            pw.Padding(
                              child: pw.Text(
                                data['separated'].toString(),
                              ),
                              padding: pw.EdgeInsets.all(10),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ]
              ),
            ],
          ),
      ],
      footer: (context) {
        return pw.Container(
          alignment: pw.Alignment.center,
          margin: const pw.EdgeInsets.only(top: 10.0),
          child: pw.Text(
            '${context.pageNumber} / ${context.pagesCount}',
            style: const pw.TextStyle(
              fontSize: 10.0,
              color: PdfColors.grey,
            ), // TextStyle
          ), // Text
        ); // Container
      }, // footer
    )); // Page
    // );
    //
    // );

    return pdf.save();
  }
}