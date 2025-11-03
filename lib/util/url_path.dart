class UrlPath {
  static const LoginUrl loginUrl = LoginUrl();
}

class LoginUrl {
  const LoginUrl();
  final String sendOTP = '/sentOTP';
  final String login = '/auth/onBoarding/login';
  final String getStore = '/store/getStores';
  final String getProduct = '/masterAdminProducts/get';
  final String addProduct = '/gsm/product';
  final String gsmProduct = '/gsm/getByUser';
}
