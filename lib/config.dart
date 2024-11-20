class Config {
  static const String _baseFunctionUrl = 'https://daelim-server.fleecy.dev/functions/v1';
  static const String _storagePublicUrl = 'https://daelim-server.fleecy.dev/storage/v1/object/public';

  static const icon = (
    google: '$_storagePublicUrl/icons/google.png',
    apple: '$_storagePublicUrl/icons/apple.png',
    github: '$_storagePublicUrl/icons/github.png',
  );

  static const image = (
    defaultProfile: '$_storagePublicUrl/icons/user.png', //
  );

  static const api = (
    getToken: '$_baseFunctionUrl/auth/get-token',
    getUserData: '$_baseFunctionUrl/auth/my-data',
    setProfileImage: '$_baseFunctionUrl/auth/set-profile-image',
    changePassword: '$_baseFunctionUrl/auth/reset-password',
    getUserList: '$_baseFunctionUrl/users',
  );

  static const storage = ();
}
