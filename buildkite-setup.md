## Install buildkite (locally)

Don't use brew to install buildkite, because that will install it at the system level, use the master install script:

    TOKEN="SECRET_TOKEN" bash -c "`curl -sL https://raw.githubusercontent.com/buildkite/agent/master/install.sh`"

All of the buildkite directories will now be in the user's home. Most importantly edit `~/.buildkite-agent.cfg` to include `meta-data="queue=sbs"` (or whatever the username is)

The agent can be started on login as described at `https://buildkite.com/docs/agent/osx`

    # Download the launchd config to /Library/LaunchDaemons/
    mkdir -p ~/Library/LaunchAgents
    curl -o ~/Library/LaunchAgents/com.buildkite.buildkite-agent.plist https://raw.githubusercontent.com/buildkite/agent/master/templates/launchd_local_with_gui.plist

    # Set buildkite-agent to be run as the current user (a full user, created via System Prefs)
    sed -i '' "s/your-build-user/$(whoami)/g" ~/Library/LaunchAgents/com.buildkite.buildkite-agent.plist

    # Create the agent's log directory with the correct permissions
    mkdir -p ~/.buildkite-agent/log && chmod 775 ~/.buildkite-agent/log

    # Start the agent
    launchctl load ~/Library/LaunchAgents/com.buildkite.buildkite-agent.plist

    # Check the logs
    tail -f ~/.buildkite-agent/log/buildkite-agent.log
