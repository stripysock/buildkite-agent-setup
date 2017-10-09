# buildkite-agent-setup

Assuming that the user account has been set up (and added to the developer
  group) as per

From a remote machine (preferably with access to github/buildkite settings)

    rsync -av .ssh/ user@host:.ssh
    ssh user@host

Following commands are run in the user account of the host agent.


    git clone https://github.com/stripysock/buildkite-agent-setup.git
    cd buildkite-agent-setup
    rbenv install 2.4.0
    rbenv global 2.4.0
    ./unpriviledged-agent-setup.sh
    source ~/.bash_profile
    gem install bundler
    ./generate-github-token.sh [PROJECT_NAME]

Follow the instructions in the output of generate-github-token (which provides
details of what you need to set on github/buildkite etc).

We now should have (read only) access to the correct repo. And buildkite should
be pointed at the repo (in a way that takes into account the deploy token).

The `./generate-github-token.sh` step may need to be run multiple times if there
is more than one git repo/pipeline.

Next step is to set up the buildkite agent. Don't use brew to install buildkite,
because that will install it at the system level, use the master install script:

    TOKEN="BUILDKITE_SECRET_TOKEN" bash -c "`curl -sL https://raw.githubusercontent.com/buildkite/agent/master/install.sh`"

All of the buildkite directories will now be in the user's home. Most
importantly edit `~/.buildkite-agent.cfg` to include `meta-data="queue=sbs"`
 (or whatever the username is)

The agent can be started on login as described at `https://buildkite.com/docs/agent/osx`

    # Download the launchd config to /Library/LaunchDaemons/
    mkdir -p ~/Library/LaunchAgents
    curl -o ~/Library/LaunchAgents/com.buildkite.buildkite-agent.plist https://raw.githubusercontent.com/buildkite/agent/master/templates/launchd_local_with_gui.plist

    # Set buildkite-agent to be run as the current user (a full user, created via System Prefs)
    sed -i '' "s/your-build-user/$(whoami)/g" ~/Library/LaunchAgents/com.buildkite.buildkite-agent.plist

    # Create the agent's log directory with the correct permissions
    mkdir -p ~/.buildkite-agent/log && chmod 775 ~/.buildkite-agent/log

Edit `.buildkite-agent/buildkite-agent.cfg` with a meaningful name and queue.

The following commands wont work in an ssh session, so time to log in at the machine itself.

    # Start the agent
    launchctl load ~/Library/LaunchAgents/com.buildkite.buildkite-agent.plist

    # Check the logs
    tail -f ~/.buildkite-agent/log/buildkite-agent.log
