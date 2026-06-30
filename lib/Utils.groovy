// lib/Utils.groovy
class Utils {
    static String getGitVersion() {
        try {
            def gitTag = ['git', 'describe', '--tags', '--always'].execute().text.trim()
            return gitTag ?: 'dev'
        } catch (Exception e) {
            return 'unknown'
        }
    }
}
