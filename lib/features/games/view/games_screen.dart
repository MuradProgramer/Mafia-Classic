import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:async';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/modern-tall-buildings-2.png"), fit: BoxFit.cover, opacity: 0.4),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Games'),
          
          actions: [
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateGameScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.filter_list, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FilterizationScreen()),
                );
              },
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: games.length, 
          itemBuilder: (context, index) {
            return GameCard(game: games[index]);
          },
        ),
      ),
    );
  }
}


////////// GAME CLASSES ////////

class Game {
  final String name;
  final int currentPlayers;
  final int minPlayers;
  final int maxPlayers;
  final String status;
  final List<String> characters;

  Game({
    required this.name,
    required this.currentPlayers,
    required this.minPlayers,
    required this.maxPlayers,
    required this.status,
    required this.characters,
  });
}

List<Game> games = [
  Game(
    name: 'Mafia Game 1',
    currentPlayers: 6,
    minPlayers: 10,
    maxPlayers: 20,
    status: 'Gathering players',
    characters: ['Mafia', 'Doctor', 'Sheriff'],
  ),
  Game(
    name: 'Mafia Game 2',
    currentPlayers: 7,
    minPlayers: 4,
    maxPlayers: 10,
    status: 'Game Started',
    characters: ['Mafia', 'Doctor', 'Sheriff'],
  ),
  Game(
    name: 'Mafia Game 3',
    currentPlayers: 10,
    minPlayers: 5,
    maxPlayers: 15,
    status: 'Gathering players',
    characters: ['Mafia', 'Doctor', 'Sheriff'],
  )
];


////////// GAMECARD ///////////

class GameCard extends StatelessWidget {
  final Game game;

  const GameCard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Card(
        //color: Theme.of(context).cardColor,
        color: Colors.transparent,
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    game.name,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Players: ${game.currentPlayers}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  Text('Min: ${game.minPlayers}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  Text('Max: ${game.maxPlayers}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    game.status,
                    style: TextStyle(
                      fontSize: 12,
                      color: game.status == 'Game Started'
                          ? Colors.red
                          : Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: game.characters
                        .map((character) => const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.0),
                              child: Icon(
                                Icons.person, 
                                size: 24,
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SizedBox(
                        width: 70,
                        child: ElevatedButton(                    
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => const PlayersPopup(),
                            );
                          },
                          child: const Text('Players'),
                        ),
                      ),
                      SizedBox(
                        width: 70,
                        child: Container(
                          margin: const EdgeInsets.only(left: 15),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => GameLobbyScreen(
                                  roomName:  game.name, 
                                  currentPlayers:  game.currentPlayers, 
                                  maxPlayers: 15, 
                                  activeRoles: game.characters
                                )),
                              );
                            },
                            child: const Text('Join'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                ],
              ),
            ],
          ),
        ),
      );
  }
}


class Player {
  final String nickname;
  final String avatarUrl;
  final String status;

  Player({required this.nickname, required this.avatarUrl, required this.status});
}

List<Player> players = [
  Player(nickname: 'Player1', avatarUrl: 'https://example.com/avatar1.png', status: 'Alive'),
  Player(nickname: 'Player2', avatarUrl: 'https://example.com/avatar2.png', status: 'Dead'),
  
];


////////// PLAYER ///////

class PlayersPopup extends StatelessWidget {
  const PlayersPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Players'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: players.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        child: Text(players[index].avatarUrl[0]),
                      ),
                      const SizedBox(width: 8),
                      Text(players[index].nickname, style: const TextStyle(fontSize: 12, color: Colors.black)),
                    ],
                  ),
                  Text(
                    players[index].status,
                    style: TextStyle(
                      fontSize: 12,
                      color: players[index].status == 'Alive'
                          ? Colors.green
                          : Colors.red,
                    ),
                  )
                ],
              )
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}


//////// CREATE GAME /////////

class CreateGameScreen extends StatefulWidget {
  const CreateGameScreen({super.key});

  @override
  State<CreateGameScreen> createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  String roomName = '';
  double minPlayers = 5;
  double maxPlayers = 7;
  Map<String, bool> roles = {
    'Doctor': false,
    'Lover': false,
    'Journalist': false,
    'Bodyguard': false,
    'Spy': false,
    'Terrorist': false,
    'Bartender': false,
    'Informant': false,
  };
  String password = '';

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/modern-tall-buildings-1.png"), fit: BoxFit.cover, opacity: 0.4),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Game'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Room Name',
                    hintStyle: TextStyle(color: Colors.white30)
                  ),
                  onChanged: (value) {
                    setState(() {
                      roomName = value;
                    });
                  },
                  style: const TextStyle(color: Colors.white)
                ),
                const SizedBox(height: 20),
                Text('Players: $minPlayers - $maxPlayers'),
                RangeSlider(
                  values: RangeValues(minPlayers, maxPlayers),
                  min: 5,
                  max: 20,
                  divisions: 15,
                  onChanged: (RangeValues values) {
                    setState(() {
                      minPlayers = values.start;
                      maxPlayers = values.end;
                    });
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Roles',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Column(
                  children: roles.keys.map((role) {
                    return ListTile(
                      leading: const Icon(Icons.person, color: Colors.white), // Замените на иконку роли
                      title: Text(role, style: const TextStyle(color: Colors.white)),
                      trailing: Switch(
                        value: roles[role]!,
                        onChanged: (value) {
                          setState(() {
                            roles[role] = value;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Password (Optional)',
                    hintStyle: TextStyle(color: Colors.white30)
                  ),
                  obscureText: true,
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Логика создания игры с сохранением состояний
                    },
                    child: const Text('Create Game'),
                  ),
                ),
              ],
            ),
          ),
      
        )
      ),
    );
  }
}


////// FILTERIZATION /////////

class FilterizationScreen extends StatefulWidget {
  const FilterizationScreen({super.key});

  @override
  State<FilterizationScreen> createState() => _FilterizationScreenState();
}

class _FilterizationScreenState extends State<FilterizationScreen> {
  bool friendsInRoom = false;
  bool roomsWithSpace = false;
  bool roomsWithoutPassword = false;
  bool roomsWithPassword = false;
  bool noAdditionalRoles = false;

  Map<String, bool> additionalRoles = {
    'Doctor': false,
    'Sheriff': false,
    'Lover': false,
    'Journalist': false,
    'Bodyguard': false,
    'Spy': false,
    'Terrorist': false,
    'Bartender': false,
    'Informant': false,
  };

  void resetFilters() {
    setState(() {
      friendsInRoom = false;
      roomsWithSpace = false;
      roomsWithoutPassword = false;
      roomsWithPassword = false;
      noAdditionalRoles = false;

      additionalRoles.updateAll((key, value) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/modern-tall-buildings-1.png"), fit: BoxFit.cover, opacity: 0.4),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Filter'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                // reset
                ElevatedButton(
                  onPressed: resetFilters,
                  child: const Text('Reset', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 20),
                // friends in games
                ListTile(
                  leading: const Icon(Icons.people, color: Colors.green),
                  title: const Text('Friends in the room', style: TextStyle(color: Colors.white, fontSize: 15)),
                  trailing: Switch(
                    value: friendsInRoom,
                    onChanged: (value) {
                      setState(() {
                        friendsInRoom = value;
                      });
                    },
                  ),
                ),
                // only where places
                ListTile(
                  title: const Text('Only rooms with available space', style: TextStyle(color: Colors.white, fontSize: 15)),
                  trailing: Switch(
                    value: roomsWithSpace,
                    onChanged: (value) {
                      setState(() {
                        roomsWithSpace = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                // without password
                ListTile(
                  title: const Text('Rooms without a password', style: TextStyle(color: Colors.white, fontSize: 15)),
                  trailing: Switch(
                    value: roomsWithoutPassword,
                    onChanged: (value) {
                      setState(() {
                        roomsWithoutPassword = value;
                      });
                    },
                  ),
                ),
                // with password
                ListTile(
                  title: const Text('Rooms with a password', style: TextStyle(color: Colors.white, fontSize: 15)),
                  trailing: Switch(
                    value: roomsWithPassword,
                    onChanged: (value) {
                      setState(() {
                        roomsWithPassword = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                // roles
                const Text(
                  'Additional Roles',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Column(
                  children: additionalRoles.keys.map((role) {
                    return ListTile(
                      leading: const Icon(Icons.person, color: Colors.white),
                      title: Text(role, style: const TextStyle(color: Colors.white, fontSize: 15)),
                      trailing: Switch(
                        value: additionalRoles[role]!,
                        onChanged: (value) {
                          setState(() {
                            additionalRoles[role] = value;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                // without additional roles
                ListTile(
                  title: const Text('Rooms without additional roles', style: TextStyle(color: Colors.white, fontSize: 15)),
                  trailing: Switch(
                    value: noAdditionalRoles,
                    onChanged: (value) {
                      setState(() {
                        noAdditionalRoles = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      //
                    },
                    child: const Text('Apply', style: TextStyle(color: Colors.white)),
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



///////////// GAMESSSS LOBBY SCRENNN ////////////////
/// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


// lobby screen
class GameLobbyScreen extends StatefulWidget {
  final String roomName;
  final int currentPlayers;
  final int maxPlayers;
  final List<String> activeRoles;

  const GameLobbyScreen({
    super.key, 
    required this.roomName,
    required this.currentPlayers,
    required this.maxPlayers,
    required this.activeRoles,
  });

  @override
  State<GameLobbyScreen> createState() => _GameLobbyScreenState();
}

class _GameLobbyScreenState extends State<GameLobbyScreen> {
  final List<ChatMessage> messages = [];
  late Timer _timer;
  int remainingTime = 60;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          timer.cancel();
          // Logic start after time ends
          startGame();
        }
      });
    });
  }

  void startGame() {
    log('Игра началась!');
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void sendMessage(String text) {
    if (text.isNotEmpty) {
      setState(() {
        messages.add(ChatMessage(
          nickname: 'Мой Никнейм',
          avatarUrl: 'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg',
          text: text,
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/modern-tall-buildings-1.png"), fit: BoxFit.cover, opacity: 0.4),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.roomName),
          actions: [
            Row(
              children: widget.activeRoles.map((role) => const Icon(Icons.person)).toList(),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(30.0),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text('Игроков в Комнате [${widget.currentPlayers}/${widget.maxPlayers}]'),
            ),
          ),
        ),
        body: Column(
          children: [
            // Тimer: before the game starts
      
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'Осталось времени: $remainingTime секунд',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(
                  width: 50,
                  height: 50,
                  child: ElevatedButton(                    
                    onPressed: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GameScreen(title: 'game name')),
                    );
                    },
                    child: const Text('Join'),
                  ),
                ),
              ],
            ),
      
            // Player list
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: const PlayerTableWidget(),
              ),
            ),
      
            // Chat
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: ChatWidget(messages: messages),
              ),
            ),
      
            // Message enter
            Container(
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              child: MessageInputField(onSend: sendMessage),
            ),
          ],
        ),
      ),
    );
  }
}

class RoleIcon {
  final IconData icon;
  RoleIcon(this.icon);
}



// Player List
class PlayerTableWidget extends StatefulWidget {
  const PlayerTableWidget({super.key});

  @override
  State<PlayerTableWidget> createState() => _PlayerTableWidgetState();
}

class _PlayerTableWidgetState extends State<PlayerTableWidget> {
  final List<Player> players = [
    Player(nickname: 'Игрок 1', avatarUrl: 'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg', status: 'alive'),
    Player(nickname: 'Игрок 2', avatarUrl: 'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg', status: 'alive'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: players.length,
      itemBuilder: (context, index) {
        final player = players[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(player.avatarUrl),
          ),
          title: Text(player.nickname, style: const TextStyle(color: Colors.white)),
        );
      },
    );
  }
}



// chat 
class ChatWidget extends StatefulWidget {
  final List<ChatMessage> messages;

  const ChatWidget({super.key, required this.messages});

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant ChatWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        final message = widget.messages[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(message.avatarUrl),
          ),
          title: Text(message.nickname, style: TextStyle(color: Colors.lightBlue[300])),
          subtitle: Text(message.text, style: const TextStyle(color: Colors.white)),
        );
      },
    );
  }
}

class ChatMessage {
  final String nickname;
  final String avatarUrl;
  final String text;

  ChatMessage({required this.nickname, required this.avatarUrl, required this.text});
}

class MessageInputField extends StatefulWidget {
  final Function(String) onSend;

  const MessageInputField({super.key, required this.onSend});

  @override
  State<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            style: const TextStyle(color: Colors.white),
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Введите сообщение...',
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              widget.onSend(_controller.text);
              _controller.clear();
            }
          },
        ),
      ],
    );
  }
}




///////////// GAME /////////

class GameScreen extends StatefulWidget {
  final String title;

  const GameScreen({super.key, required this.title});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle())
      ),
      body: Container(

      )
    
    );
  }
}