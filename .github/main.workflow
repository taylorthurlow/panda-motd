workflow "Build & Test" {
  on = "push"
  resolves = ["Test"]
}

action "Test" {
  uses = "./action-test/"
}
