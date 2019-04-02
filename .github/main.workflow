workflow "Build & Test" {
  on = "push"
  resolves = ["Test"]
}

action "Test" {
  uses = "./action-test/"
  secrets = ["CC_TEST_REPORTER_ID"]
}
