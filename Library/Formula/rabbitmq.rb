require 'formula'

class Rabbitmq < Formula
  homepage 'http://www.rabbitmq.com'
  url 'https://www.rabbitmq.com/releases/rabbitmq-server/v3.4.0/rabbitmq-server-3.4.0.tar.gz'
  sha1 'b25351aff4c04e8240e1321f327692b25f6be33d'

  bottle do
    sha1 "38ecb1b3863be6c1c3ef5887774c1fc660326b47" => :yosemite
    sha1 "ef9268ff01b8c08d38090c5186574a612f628d8b" => :mavericks
    sha1 "5a2de56f51462e5ce77d5aea94f6d1027cf4cbcf" => :mountain_lion
  end

  depends_on "xmlto" => :build
  depends_on "erlang"
  depends_on "openssl"
  depends_on 'simplejson' => :python if MacOS.version <= :leopard

  def install
    ENV["XML_CATALOG_FILES"] = Formula["docbook"].etc/"xml/catalog"

    system "make", "install", "TARGET_DIR=#{prefix}",
                              "SBIN_DIR=#{sbin}",
                              "MAN_DIR=#{man}",
                              "DOC_INSTALL_DIR=#{doc}"

    # Setup the lib files
    (var+'lib/rabbitmq').mkpath
    (var+'log/rabbitmq').mkpath

    erlang = Formula["erlang"]
    # Correct SYS_PREFIX for things like rabbitmq-plugins
    inreplace sbin/'rabbitmq-defaults' do |s|
      s.change_make_var! "ERL_DIR", "#{erlang.opt_bin}/"
      s.change_make_var! "SYS_PREFIX", HOMEBREW_PREFIX
      s.change_make_var! "CLEAN_BOOT_FILE", erlang.opt_lib/"erlang/bin/start_clean"
      s.change_make_var! "SASL_BOOT_FILE", erlang.opt_lib/"erlang/bin/start_sasl"
    end

    # Set RABBITMQ_HOME in rabbitmq-env
    inreplace (sbin + 'rabbitmq-env'), 'RABBITMQ_HOME="${SCRIPT_DIR}/.."', "RABBITMQ_HOME=#{prefix}"

    # Create the rabbitmq-env.conf file
    rabbitmq_env_conf = etc+'rabbitmq/rabbitmq-env.conf'
    rabbitmq_env_conf.write rabbitmq_env unless rabbitmq_env_conf.exist?

    # Enable plugins - management web UI and visualiser; STOMP, MQTT, AMQP 1.0 protocols
    enabled_plugins_path = etc+'rabbitmq/enabled_plugins'
    enabled_plugins_path.write '[rabbitmq_management,rabbitmq_management_visualiser,rabbitmq_stomp,rabbitmq_amqp1_0,rabbitmq_mqtt].' unless enabled_plugins_path.exist?

    # Extract rabbitmqadmin and install to sbin
    # use it to generate, then install the bash completion file
    system "/usr/bin/unzip", "-qq", "-j",
           "#{prefix}/plugins/rabbitmq_management-#{version}.ez",
           "rabbitmq_management-#{version}/priv/www/cli/rabbitmqadmin"

    sbin.install 'rabbitmqadmin'
    (sbin/'rabbitmqadmin').chmod 0755
    (bash_completion/'rabbitmqadmin.bash').write `#{sbin}/rabbitmqadmin --bash-completion`
  end

  def caveats; <<-EOS.undent
    Management Plugin enabled by default at http://localhost:15672
    EOS
  end

  def rabbitmq_env; <<-EOS.undent
    CONFIG_FILE=#{etc}/rabbitmq/rabbitmq
    NODE_IP_ADDRESS=127.0.0.1
    NODENAME=rabbit@localhost
    EOS
  end

  plist_options :manual => 'rabbitmq-server'

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>Program</key>
        <string>#{opt_sbin}/rabbitmq-server</string>
        <key>RunAtLoad</key>
        <true/>
        <key>EnvironmentVariables</key>
        <dict>
          <!-- need erl in the path -->
          <key>PATH</key>
          <string>/usr/local/sbin:/usr/bin:/bin:/usr/local/bin</string>
          <!-- specify the path to the rabbitmq-env.conf file -->
          <key>CONF_ENV_FILE</key>
          <string>#{etc}/rabbitmq/rabbitmq-env.conf</string>
        </dict>
      </dict>
    </plist>
    EOS
  end
end
