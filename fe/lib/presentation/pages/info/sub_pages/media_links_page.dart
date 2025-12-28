import 'package:fe/config/app_color.dart';
import 'package:flutter/material.dart';

class MediaLinksPage extends StatefulWidget {
  const MediaLinksPage({super.key});

  @override
  State<MediaLinksPage> createState() => _MediaLinksPageState();
}

class _MediaLinksPageState extends State<MediaLinksPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Media, Links, and Docs"),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.neutral_900),
          onPressed: () => Navigator.pop(context),
        ),
        titleTextStyle: const TextStyle(
          color: AppColors.neutral_900,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.blue_500,
          unselectedLabelColor: AppColors.neutral_500,
          indicatorColor: AppColors.blue_500,
          tabs: const [
            Tab(text: "MEDIA"),
            Tab(text: "LINKS"),
            Tab(text: "DOCS"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMediaGrid(),
          _buildLinksList(),
          _buildDocsList(),
        ],
      ),
    );
  }

  Widget _buildMediaGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: 15, // Dummy
      itemBuilder: (context, index) {
        return Container(
          color: AppColors.neutral_100,
          child: const Icon(Icons.image, color: Colors.grey),
        );
      },
    );
  }

  Widget _buildLinksList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      separatorBuilder: (_,__) => const Divider(),
      itemBuilder: (context, index) {
        return ListTile(
           contentPadding: EdgeInsets.zero,
           leading: Container(
             padding: const EdgeInsets.all(12),
             color: AppColors.neutral_50,
             child: const Icon(Icons.link, color: AppColors.neutral_500),
           ),
           title: Text("https://example.com/link-$index"),
           subtitle: const Text("This is a dummy link description"),
        );
      },
    );
  }

  Widget _buildDocsList() {
     return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      separatorBuilder: (_,__) => const Divider(),
      itemBuilder: (context, index) {
        return ListTile(
           contentPadding: EdgeInsets.zero,
           leading: Container(
             padding: const EdgeInsets.all(12),
             color: Colors.red.withValues(alpha: 0.1),
             child: const Icon(Icons.picture_as_pdf, color: Colors.red),
           ),
           title: Text("Project_Document_$index.pdf"),
           subtitle: const Text("2.4 MB • 2 days ago"),
        );
      },
    );
  }
}
