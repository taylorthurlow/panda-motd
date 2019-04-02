workflow "Build & Test" {
  on = "push"
  resolves = ["Test"]
}

action "Test" {
  uses = "./action-test/"
  secrets = ["CC_TEST_REPORTER_ID"]
}

workflow "Release Gem" {
  on = "release"
  resolves = ["Release on RubyGems"]
}

action "Release on RubyGems" {
  uses = "./action-release"
  secrets = [
    "RUBYGEMS_API_KEY",
    "GITHUB_TOKEN",
  ]
}
