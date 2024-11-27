class ApiError {
  static const createChatRoom = (
    success: 200, // 채팅방 개설 성공
    requiredUserId: 1001, // 상대방 ID 는 필수입니다.
    cannotMySelf: 1002, // 자기 자신과 대화할 수 없습니다.
    notFound: 1003, // 상대방을 찾을 수 없습니다.
    onlyCanChatbot: 1004, // 챗봇 계정만 대화할 수 있습니다.
    alreadyRoom: 1005, // 이미 생성된 채팅방이 있습니다.
  );
}
