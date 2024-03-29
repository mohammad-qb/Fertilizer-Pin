import 'package:fertilizer_pin/common/colors.dart';
import 'package:fertilizer_pin/config/config.dart';
import 'package:fertilizer_pin/controllers/account/account.dart';
import 'package:fertilizer_pin/controllers/post/post.dart';
import 'package:fertilizer_pin/widgets/fertilizer_text.dart';
import 'package:fertilizer_pin/widgets/image.dart';
import 'package:fertilizer_pin/widgets/post.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: GREY_BG_COLOR,
          appBar: AppBar(
            backgroundColor: WIHTE_COLOR,
            title: GetBuilder<AccountController>(
              builder: (controller) => FertilizerImage(
                  image: controller.account.image.length != 0,
                  width: 40,
                  height: 40,
                  networkImage: "$IMAGE_URL/" + controller.account.image),
            ),
            actions: [
              Image.asset(
                'assets/images/logoIcon.png',
                width: 40,
                height: 40,
              ),
            ],
          ),
          body: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: GetX<PostController>(
              init: PostController(),
              builder: (controller) => Container(
                child: controller.loading.value
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              GREEN_GRADIENT_DARK),
                        ),
                      )
                    : controller.posts.length == 0
                        ? Center(
                            child: FertilizerText(
                            text: "لا يوجد منشورات للان",
                            fontSize: 12,
                          ))
                        : Column(
                            children: [
                              Column(
                                children: controller.posts.value
                                    .map(
                                      (element) => Column(
                                        children: [
                                          Post(
                                              title: element.title,
                                              content: element.description,
                                              date: DateTime.parse(
                                                  element.createdAt)),
                                          SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      ),
                                    )
                                    .toList(),
                              ),
                              Visibility(
                                  visible: controller.loadingPosts.value,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          GREEN_GRADIENT_DARK),
                                    ),
                                  )),
                              Visibility(
                                  visible: controller.postSuccess.response
                                              .results.length >
                                          30 &&
                                      !controller.loadingPosts.value,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: GestureDetector(
                                      child: FertilizerText(
                                        text: 'تحميل المزيد؟',
                                        fontSize: 12,
                                        color: LINK_COLOR,
                                      ),
                                      onTap: () =>
                                          controller.getAllPosts(false),
                                    ),
                                  ))
                            ],
                          ),
              ),
            ),
          )),
        ));
  }
}
