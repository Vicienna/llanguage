import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:llanguage/data/database/app_database.dart';
import 'package:llanguage/data/database/daos/chat_dao.dart';
import 'package:llanguage/data/database/tables/all_tables.dart';

void main() {
  late AppDatabase database;
  late ChatDao dao;

  setUp(() {
    database = AppDatabase.forTest(NativeDatabase.memory());
    dao = ChatDao(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('ChatDao', () {
    test('createSession creates a chat session', () async {
      final now = DateTime.now();
      final session = await dao.createSession(
        title: 'Grammar Help',
        modelProvider: 'gpt-4',
        createdAt: now,
        updatedAt: now,
      );
      expect(session.id, isNotNull);
      expect(session.title, equals('Grammar Help'));
    });

    test('getSession retrieves by id', () async {
      final now = DateTime.now();
      final created = await dao.createSession(title: 'Test', modelProvider: 'gpt-4', createdAt: now, updatedAt: now);
      final retrieved = await dao.getSession(created.id);
      expect(retrieved, isNotNull);
    });

    test('getAllSessions returns all sessions', () async {
      final now = DateTime.now();
      await dao.createSession(title: 'A', modelProvider: 'gpt-4', createdAt: now, updatedAt: now);
      await dao.createSession(title: 'B', modelProvider: 'claude', createdAt: now, updatedAt: now);
      final sessions = await dao.getAllSessions();
      expect(sessions.length, equals(2));
    });

    test('updateSession updates title and updatedAt', () async {
      final now = DateTime.now();
      final created = await dao.createSession(title: 'Old', modelProvider: 'gpt-4', createdAt: now, updatedAt: now);
      final later = now.add(const Duration(hours: 1));
      final updated = await dao.updateSession(created.id, title: 'New', updatedAt: later);
      expect(updated.first.title, equals('New'));
    });

    test('deleteSession removes session', () async {
      final now = DateTime.now();
      final created = await dao.createSession(title: 'To Delete', modelProvider: 'gpt-4', createdAt: now, updatedAt: now);
      await dao.deleteSession(created.id);
      final retrieved = await dao.getSession(created.id);
      expect(retrieved, isNull);
    });

    test('addMessage creates a message in a session', () async {
      final now = DateTime.now();
      final session = await dao.createSession(title: 'S', modelProvider: 'gpt-4', createdAt: now, updatedAt: now);
      final msg = await dao.addMessage(
        sessionId: session.id,
        role: 'user',
        content: 'Hello',
        createdAt: now,
      );
      expect(msg.id, isNotNull);
      expect(msg.role, equals('user'));
      expect(msg.content, equals('Hello'));
    });

    test('getMessages returns messages for a session ordered by createdAt', () async {
      final now = DateTime.now();
      final session = await dao.createSession(title: 'S', modelProvider: 'gpt-4', createdAt: now, updatedAt: now);
      await dao.addMessage(sessionId: session.id, role: 'user', content: 'Hi', createdAt: now);
      await dao.addMessage(sessionId: session.id, role: 'assistant', content: 'Hello!', createdAt: now.add(const Duration(seconds: 1)));
      final messages = await dao.getMessages(session.id);
      expect(messages.length, equals(2));
      expect(messages.first.role, equals('user'));
      expect(messages.last.role, equals('assistant'));
    });

    test('deleteMessages deletes all messages in a session', () async {
      final now = DateTime.now();
      final session = await dao.createSession(title: 'S', modelProvider: 'gpt-4', createdAt: now, updatedAt: now);
      await dao.addMessage(sessionId: session.id, role: 'user', content: 'Hi', createdAt: now);
      await dao.deleteMessages(session.id);
      final messages = await dao.getMessages(session.id);
      expect(messages, isEmpty);
    });
  });
}
