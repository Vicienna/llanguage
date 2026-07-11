import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/all_tables.dart';

part 'chat_dao.g.dart';

@DriftAccessor(tables: [ChatSessions, ChatMessages])
class ChatDao extends DatabaseAccessor<AppDatabase> with _$ChatDaoMixin {
  final AppDatabase db;

  ChatDao(this.db) : super(db);

  Future<ChatSession> createSession({
    required String title,
    required String modelProvider,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) =>
      db.into(db.chatSessions).insertReturning(ChatSessionsCompanion.insert(
        title: title,
        modelProvider: modelProvider,
        createdAt: createdAt,
        updatedAt: updatedAt,
      ));

  Future<ChatSession?> getSession(int id) =>
      (db.select(db.chatSessions)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<ChatSession>> getAllSessions() => db.select(db.chatSessions).get();

  Future<List<ChatSession>> updateSession(
    int id, {
    String? title,
    DateTime? updatedAt,
  }) =>
      (db.update(db.chatSessions)..where((t) => t.id.equals(id))).writeReturning(
        ChatSessionsCompanion(
          title: title != null ? Value(title!) : Value.absent(),
          updatedAt: updatedAt != null ? Value(updatedAt!) : Value.absent(),
        ),
      );

  Future<int> deleteSession(int id) =>
      (db.delete(db.chatSessions)..where((t) => t.id.equals(id))).go();

  Future<ChatMessage> addMessage({
    required int sessionId,
    required String role,
    required String content,
    required DateTime createdAt,
  }) =>
      db.into(db.chatMessages).insertReturning(ChatMessagesCompanion.insert(
        sessionId: sessionId,
        role: role,
        content: content,
        createdAt: createdAt,
      ));

  Future<List<ChatMessage>> getMessages(int sessionId) =>
      (db.select(db.chatMessages)
        ..where((t) => t.sessionId.equals(sessionId))
        ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
      .get();

  Future<int> deleteMessages(int sessionId) =>
      (db.delete(db.chatMessages)..where((t) => t.sessionId.equals(sessionId))).go();
}
