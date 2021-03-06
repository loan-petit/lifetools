/// Every possible types of environments.
enum EnvironmentType { DEV, PROD }

/// Define the environment used by the whole app depending on [EnvironmentType].
class Environment {
  /// Environment variables.
  static Map<String, dynamic> vars;

  /// Type of the current environment.
  static EnvironmentType env;

  /// Initialize a development environment.
  static void dev() {
    env = EnvironmentType.DEV;
    vars = {
      'apiEndpoint': 'http://localhost:4000/',
    };
  }

  /// Initialize a production environment.
  static void prod() {
    env = EnvironmentType.PROD;
    vars = {
      'apiEndpoint': 'https://www.lifetools.loanpetit.com:4000/',
    };
  }
}
