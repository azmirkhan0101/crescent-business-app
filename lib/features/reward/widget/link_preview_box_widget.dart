import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organization/features/widgets/custom_card_widget.dart';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:file_picker/file_picker.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/assets_path.dart';

import '../../../utils/app_text_styles.dart';

class LinkPreviewBox extends StatelessWidget {
  const LinkPreviewBox({super.key, this.textColor});
 final Color?textColor;
  Future<void> _pickFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false, // একবারে একটাই ফাইল সিলেক্ট
      type: FileType.any,   // চাইলে FileType.image / FileType.custom দিতে পারো
      // allowedExtensions: ['jpg', 'pdf', 'doc'], // custom হলে
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Picked file: ${file.name}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      height: 58.h,
      child: Row(
        children: [
          // Link Icon
          const Icon(Icons.link, size: 20, color: Colors.black54),
          const SizedBox(width: 8),

          // লিঙ্ক টেক্সট/প্রিভিউ
          Expanded(
            child: AnyLinkPreview(
              link: "https://google.com/..",
              displayDirection: UIDirection.uiDirectionHorizontal,
              showMultimedia: false,
              bodyMaxLines: 1,
              bodyTextOverflow: TextOverflow.ellipsis,
              removeElevation: true,
              backgroundColor: Colors.transparent,
              errorWidget:  Text(
                "https://google.com/..",
                style: AppTextStyle.mediumStyle.copyWith(fontSize: 12.sp,color:textColor?? AppColors.blackTextColor)
              ),
            ),
          ),

          // ডানপাশে ছোট grey vertical bar
          Container(
            width: 2,
            height: 20,
            color: Colors.grey.shade400,
          ),
          const SizedBox(width: 8),

          // Upload Icon (clickable)

          InkWell(
              onTap: () => _pickFile(context),
              child: Image.asset(AssetsPath.cloudIcon)
          ),


        ],
      ),
    );
  }
}
