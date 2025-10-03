class LiveStream {
  final String id;
  final String title;
  final String streamerName;
  final String streamerAvatar;
  final String thumbnailUrl;
  final int viewerCount;
  final bool isLive;
  final String category;

  LiveStream({
    required this.id,
    required this.title,
    required this.streamerName,
    required this.streamerAvatar,
    required this.thumbnailUrl,
    required this.viewerCount,
    required this.isLive,
    required this.category,
  });
}

final List<LiveStream> mockStreams = [
  LiveStream(
    id: '1',
    title: 'Jugando Valorant con amigos 🎮',
    streamerName: 'GamerPro',
    streamerAvatar: 'assets/images/logo.svg',
    thumbnailUrl: 'assets/images/logo.svg',
    viewerCount: 1234,
    isLive: true,
    category: 'Gaming',
  ),
  LiveStream(
    id: '2',
    title: 'Cocinando recetas tradicionales',
    streamerName: 'ChefMaria',
    streamerAvatar: 'assets/images/logo.svg',
    thumbnailUrl: 'assets/images/logo.svg',
    viewerCount: 856,
    isLive: true,
    category: 'Cooking',
  ),
  LiveStream(
    id: '3',
    title: 'Música en vivo - Sesión acústica',
    streamerName: 'MusicLover',
    streamerAvatar: 'assets/images/logo.svg',
    thumbnailUrl: 'assets/images/logo.svg',
    viewerCount: 2341,
    isLive: true,
    category: 'Music',
  ),
  LiveStream(
    id: '4',
    title: 'Dibujando personajes anime',
    streamerName: 'ArtistaPro',
    streamerAvatar: 'assets/images/logo.svg',
    thumbnailUrl: 'assets/images/logo.svg',
    viewerCount: 567,
    isLive: true,
    category: 'Art',
  ),
  LiveStream(
    id: '5',
    title: 'Entrenamiento fitness en casa',
    streamerName: 'FitCoach',
    streamerAvatar: 'assets/images/logo.svg',
    thumbnailUrl: 'assets/images/logo.svg',
    viewerCount: 1089,
    isLive: true,
    category: 'Fitness',
  ),
  LiveStream(
    id: '6',
    title: 'Charlando con la comunidad',
    streamerName: 'TalkShow',
    streamerAvatar: 'assets/images/logo.svg',
    thumbnailUrl: 'assets/images/logo.svg',
    viewerCount: 3421,
    isLive: true,
    category: 'Talk',
  ),
];
