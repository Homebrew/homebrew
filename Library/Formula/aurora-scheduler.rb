class AuroraScheduler < Formula
  desc "Apache Aurora Scheduler Client"
  homepage "https://aurora.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=aurora/0.9.0/apache-aurora-0.9.0.tar.gz"
  sha256 "16040866f3a799226452b1541892eb80ed3c61f47c33f1ccb0687fb5cf82767c"

  def install
    # https://issues.apache.org/jira/browse/AURORA-1508
    inreplace ".pantsversion", "0.0.32", "0.0.53"
    tools = <<-EOS.undent
      # common rev for all org.scala-lang%* artifacts
      SCALA_REV = '2.10.4'

      jar_library(name = 'scala-compiler',
                  jars = [
                    jar(org = 'org.scala-lang', name = 'scala-compiler', rev = SCALA_REV),
                  ])

      jar_library(name = 'scala-library',
                  jars = [
                    jar(org = 'org.scala-lang', name = 'scala-library', rev = SCALA_REV),
                  ])

      jar_library(name = 'scala-repl',
                  jars = [
                    jar(org = 'org.scala-lang', name = 'jline', rev = SCALA_REV, intransitive = True),
                  ],
                  dependencies = [
                    ':scala-compiler',
                    ':scala-library',
                  ])
    EOS
    File.open("BUILD.tools", "a+") { |f| f.puts(tools) }
    system "./build-support/python/update-pants-requirements"
    system "./pants", "binary", "src/main/python/apache/aurora/client/cli:kaurora"
    system "./pants", "binary", "src/main/python/apache/aurora/admin:kaurora_admin"
    bin.install "dist/kaurora.pex" => "aurora"
    bin.install "dist/kaurora_admin.pex" => "aurora_admin"
  end

  test do
    ENV["AURORA_CONFIG_ROOT"] = "#{testpath}"
    (testpath/"clusters.json").write <<-EOS.undent
        [{
          "name": "devcluster",
          "slave_root": "/tmp/mesos/",
          "zk": "172.16.64.185",
          "scheduler_zk_path": "/aurora/scheduler",
          "auth_mechanism": "UNAUTHENTICATED"
        }]
    EOS
    system "#{bin}/aurora_admin", "get_cluster_config", "devcluster"
  end
end
