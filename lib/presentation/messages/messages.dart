import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/conversation_item_widget.dart';
import './widgets/empty_messages_widget.dart';
import './widgets/search_bar_widget.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredConversations = [];
  bool _isSearching = false;

  // Mock conversations data
  final List<Map<String, dynamic>> _conversations = [
    {
      "id": 1,
      "contactName": "Sarah Johnson",
      "avatar":
          "https://img.rocket.new/generatedImages/rocket_gen_img_11b715d60-1762273834012.png",
      "semanticLabel":
          "Professional headshot of a woman with shoulder-length brown hair wearing a navy blazer",
      "lastMessage":
          "Great! I'll meet you at the coffee shop tomorrow at 2 PM for the book exchange.",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 15)),
      "unreadCount": 2,
      "isTradeInProgress": true,
    },
    {
      "id": 2,
      "contactName": "Michael Chen",
      "avatar":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1f3d1cbe1-1762274610155.png",
      "semanticLabel":
          "Portrait of an Asian man with short black hair wearing a white collared shirt",
      "lastMessage":
          "The guitar is in excellent condition. Would you like to see more photos?",
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
      "unreadCount": 1,
      "isTradeInProgress": true,
    },
    {
      "id": 3,
      "contactName": "Emma Rodriguez",
      "avatar":
          "https://images.unsplash.com/photo-1587110107796-1acdcd466b58",
      "semanticLabel":
          "Smiling woman with long dark hair wearing a light blue denim jacket outdoors",
      "lastMessage":
          "Thanks for the trade! The vintage camera works perfectly.",
      "timestamp": DateTime.now().subtract(const Duration(hours: 5)),
      "unreadCount": 0,
      "isTradeInProgress": false,
    },
    {
      "id": 4,
      "contactName": "David Thompson",
      "avatar":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1e4929231-1762274177522.png",
      "semanticLabel":
          "Professional photo of a man with beard wearing a dark suit jacket",
      "lastMessage":
          "I'm interested in your bicycle. Is it still available for trade?",
      "timestamp": DateTime.now().subtract(const Duration(days: 1)),
      "unreadCount": 0,
      "isTradeInProgress": false,
    },
    {
      "id": 5,
      "contactName": "Lisa Park",
      "avatar":
          "https://images.unsplash.com/photo-1662128294645-c071c1bed330",
      "semanticLabel":
          "Young woman with short blonde hair wearing a red sweater smiling at camera",
      "lastMessage":
          "The art supplies are exactly what I needed. Thank you so much!",
      "timestamp": DateTime.now().subtract(const Duration(days: 2)),
      "unreadCount": 0,
      "isTradeInProgress": false,
    },
    {
      "id": 6,
      "contactName": "James Wilson",
      "avatar":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1fd9c338e-1762273340548.png",
      "semanticLabel":
          "Middle-aged man with gray hair and glasses wearing a casual button-up shirt",
      "lastMessage":
          "Could we arrange a time to meet this weekend for the furniture exchange?",
      "timestamp": DateTime.now().subtract(const Duration(days: 3)),
      "unreadCount": 0,
      "isTradeInProgress": false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _filteredConversations = List.from(_conversations);
    _sortConversations();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _sortConversations() {
    _filteredConversations.sort((a, b) {
      // First, sort by trade in progress
      final aInProgress = a['isTradeInProgress'] as bool? ?? false;
      final bInProgress = b['isTradeInProgress'] as bool? ?? false;

      if (aInProgress && !bInProgress) return -1;
      if (!aInProgress && bInProgress) return 1;

      // Then by unread count
      final aUnread = a['unreadCount'] as int? ?? 0;
      final bUnread = b['unreadCount'] as int? ?? 0;

      if (aUnread > 0 && bUnread == 0) return -1;
      if (aUnread == 0 && bUnread > 0) return 1;

      // Finally by timestamp
      final aTime = a['timestamp'] as DateTime?;
      final bTime = b['timestamp'] as DateTime?;

      if (aTime == null && bTime == null) return 0;
      if (aTime == null) return 1;
      if (bTime == null) return -1;

      return bTime.compareTo(aTime);
    });
  }

  void _filterConversations(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        _filteredConversations = List.from(_conversations);
      } else {
        _filteredConversations = _conversations.where((conversation) {
          final contactName =
              (conversation['contactName'] as String? ?? '').toLowerCase();
          final lastMessage =
              (conversation['lastMessage'] as String? ?? '').toLowerCase();
          final searchQuery = query.toLowerCase();

          return contactName.contains(searchQuery) ||
              lastMessage.contains(searchQuery);
        }).toList();
      }
      _sortConversations();
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _filterConversations('');
  }

  Future<void> _refreshConversations() async {
    // Simulate network refresh
    await Future.delayed(const Duration(seconds: 1));

    // In a real app, this would fetch latest conversations from server
    setState(() {
      // Update timestamps to simulate new activity
      for (var conversation in _conversations) {
        if ((conversation['unreadCount'] as int? ?? 0) > 0) {
          conversation['timestamp'] = DateTime.now()
              .subtract(Duration(minutes: DateTime.now().minute % 30));
        }
      }
      _filteredConversations = List.from(_conversations);
      _sortConversations();
    });
  }

  void _navigateToChat(Map<String, dynamic> conversation) {
    // In a real app, this would navigate to chat detail screen
    // For now, we'll show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening chat with ${conversation['contactName']}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _markAsRead(Map<String, dynamic> conversation) {
    setState(() {
      conversation['unreadCount'] = 0;
      _sortConversations();
    });
  }

  void _markAsUnread(Map<String, dynamic> conversation) {
    setState(() {
      conversation['unreadCount'] = 1;
      _sortConversations();
    });
  }

  void _archiveConversation(Map<String, dynamic> conversation) {
    setState(() {
      _conversations.remove(conversation);
      _filteredConversations.remove(conversation);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Conversation with ${conversation['contactName']} archived'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _conversations.add(conversation);
              _filterConversations(_searchController.text);
            });
          },
        ),
      ),
    );
  }

  void _deleteConversation(Map<String, dynamic> conversation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Conversation'),
        content: Text(
            'Are you sure you want to delete this conversation with ${conversation['contactName']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _conversations.remove(conversation);
                _filteredConversations.remove(conversation);
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Conversation with ${conversation['contactName']} deleted'),
                ),
              );
            },
            child: Text(
              'Delete',
              style: TextStyle(color: AppTheme.errorLight),
            ),
          ),
        ],
      ),
    );
  }

  void _muteConversation(Map<String, dynamic> conversation) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${conversation['contactName']} muted'),
      ),
    );
  }

  void _blockUser(Map<String, dynamic> conversation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Block User'),
        content: Text(
            'Are you sure you want to block ${conversation['contactName']}? They won\'t be able to message you anymore.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _conversations.remove(conversation);
                _filteredConversations.remove(conversation);
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${conversation['contactName']} blocked'),
                ),
              );
            },
            child: Text(
              'Block',
              style: TextStyle(color: AppTheme.errorLight),
            ),
          ),
        ],
      ),
    );
  }

  void _reportUser(Map<String, dynamic> conversation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report User'),
        content: Text(
            'Report ${conversation['contactName']} for inappropriate behavior?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${conversation['contactName']} reported'),
                ),
              );
            },
            child: Text(
              'Report',
              style: TextStyle(color: AppTheme.errorLight),
            ),
          ),
        ],
      ),
    );
  }

  void _startNewConversation() {
    // In a real app, this would open user search screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening user search...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Messages',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: _startNewConversation,
            icon: CustomIconWidget(
              iconName: 'edit',
              color: theme.colorScheme.onSurface,
              size: 6.w,
            ),
            tooltip: 'New message',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          SearchBarWidget(
            controller: _searchController,
            hintText: 'Search conversations...',
            onChanged: _filterConversations,
            onClear: _clearSearch,
          ),

          // Conversations List
          Expanded(
            child: _filteredConversations.isEmpty
                ? _isSearching
                    ? _buildNoSearchResults()
                    : const EmptyMessagesWidget()
                : RefreshIndicator(
                    onRefresh: _refreshConversations,
                    child: SlidableAutoCloseBehavior(
                      child: ListView.builder(
                        itemCount: _filteredConversations.length,
                        itemBuilder: (context, index) {
                          final conversation = _filteredConversations[index];

                          return ConversationItemWidget(
                            conversation: conversation,
                            onTap: () => _navigateToChat(conversation),
                            onMarkRead: () {
                              final unreadCount =
                                  conversation['unreadCount'] as int? ?? 0;
                              if (unreadCount > 0) {
                                _markAsRead(conversation);
                              } else {
                                _markAsUnread(conversation);
                              }
                            },
                            onArchive: () => _archiveConversation(conversation),
                            onDelete: () => _deleteConversation(conversation),
                            onMute: () => _muteConversation(conversation),
                            onBlock: () => _blockUser(conversation),
                            onReport: () => _reportUser(conversation),
                          );
                        },
                      ),
                    ),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomBar(
        currentIndex: 3, // Messages tab
        variant: CustomBottomBarVariant.marketplace,
      ),
      floatingActionButton: _filteredConversations.isNotEmpty
          ? FloatingActionButton(
              onPressed: _startNewConversation,
              tooltip: 'New message',
              child: CustomIconWidget(
                iconName: 'add',
                color: Colors.white,
                size: 6.w,
              ),
            )
          : null,
    );
  }

  Widget _buildNoSearchResults() {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: theme.colorScheme.onSurfaceVariant,
              size: 15.w,
            ),
            SizedBox(height: 2.h),
            Text(
              'No conversations found',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Try searching with different keywords',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
