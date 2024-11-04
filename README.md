# Harvest Notifier

<!-- markdownlint-disable MD033 -->
<div align="center">
    <a href="https://augustash.com" target="_blank">
        <picture>
            <source media="(prefers-color-scheme: dark)" srcset="https://augustash.s3.amazonaws.com/logos/ash-inline-invert-500.png">
            <source media="(prefers-color-scheme: light)" srcset="https://augustash.s3.amazonaws.com/logos/ash-inline-color-500.png">
            <img alt="Shows a theme-dependent version of the AAI company logo." src="https://augustash.s3.amazonaws.com/logos/ash-inline-color-500.png">
        </picture>
    </a>
</div>

<div align="center">
    <a href="https://augustash.semaphoreci.com/projects/harvest-notifier" target="_blank"><img src="https://augustash.semaphoreci.com/badges/harvest-notifier/branches/master.svg?style=shields&key=a4e5e3c5-b65b-4de2-bbbc-1756d2768995" alt="Build Status" /></a>
    <a href="https://github.com/augustash/harvest-notifier/graphs/commit-activity" target="_blank"><img src="https://img.shields.io/badge/maintained%3F-yes-brightgreen.svg?style=flat-square" alt="Maintained - Yes" /></a>
    <a href="https://opensource.org/licenses/MIT" target="_blank"><img alt="MIT" src="https://img.shields.io/badge/license-MIT-blue.svg" /></a>
</div>

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/augustash/harvest-notifier)

The Harvest Notifier app is an integration between Harvest and Slack which automatically reminds users who forget to mark their working hours in Harvest.

## Information

- This is a Ruby 3.3.5 application.
- Meant for installation on Heroku triggered by Daily Heroku Scheduler.
- Notification is determined by time data from the Harvest V2 API.

## Features

There are two types of reports: **Daily** and **Weekly**.

- The **Daily Report** is generated on all weekdays (except Monday) and shows those users who did not fill in their time for that day.
- The **Weekly Report** is generated every Monday and shows those users who still need to report the required working hours for previous week.

This app integration allows:

- Configure a whitelist of Harvest users who don't need to be notified in Slack.
- Mention users in the Slack channel.
- Quickly report the working hours from the included link.
- Refresh report results.
- Set up a custom report schedule.

![Example](https://user-images.githubusercontent.com/49876756/86122099-e32be700-badf-11ea-8c0a-7cd86d047948.png)

## Quick Start

### Prepare integration access tokens

- Create a [Personal Access Token](https://id.getharvest.com/developers) on [Harvest](https://getharvest.com).
- Create a [Slack app](https://api.slack.com/apps). You may want to [follow the official guide](https://slack.com/intl/en-ru/resources/using-slack/app-launch).
- Add the following scopes to OAuth & Permissions > Bot Token Scopes:

    ```bash
    chat:write
    users:read
    users:read.email
    ```

- Install the App to your Workspace.
  - Generates a Bot User OAuth Token.

### Deploy to Heroku

The easiest way to deploy this app is to [use the Heroku button](https://heroku.com/deploy?template=https://github.com/augustash/harvest-notifier).

### Configure ENV Variables

```bash
# heroku config:set EMAILS_WHITELIST=harvest@augustash.com
# EMAILS_WHITELIST is a list of emails separated by commas, which don't need to be notified in Slack.
heroku config:set HARVEST_ACCOUNT_ID=harvest-account-id
heroku config:set HARVEST_TOKEN=harvest-token
heroku config:set HARVEST_URL=https://augustash.harvestapp.com
# MISSING_HOURS_THRESHOLD indicates the minimum threshold of hours at which the employee will not be notified in Slack.
heroku config:set MISSING_HOURS_THRESHOLD=4.0
heroku config:set SLACK_CHANNEL=slack-notifications-channel
heroku config:set SLACK_TOKEN=slack-bot-user-oauth-token
heroku config:set EMAILS_WHITELIST=user1@example.com, user2@example.com, user3@example.com
# ROLLBAR_ACCESS_TOKEN is a token for Rollbar error tracking.
# heroku config:set ROLLBAR_ACCESS_TOKEN=rollbar-access-token
# DEADMANSSNITCH_API_KEY is a token for Dead Man Snitch to monitor Heroku Scheduler runs.
# heroku config:set DEADMANSSNITCH_API_KEY=dead-mean-snitch-access-token
```

### Configure Heroku Scheduler

- ```bin/rake reports:daily``` for daily report
- ```bin/rake reports:weekly``` for weekly report

## Quality tools

- `bin/quality` based on [RuboCop](https://github.com/bbatsov/rubocop)
- `.rubocop.yml` describes active checks

## Local Development

### Сlone the GitHub Repo

```bash
git clone git@github.com:augustash/harvest-notifier.git
cd harvest-notifier
```

### Prepare and Run the Environment

```bash
docker build -t heroku-notifier .
docker run -it -v .:/app --rm heroku-notifier /bin/bash
```

### Setup Project

```bash
bin/setup
```

### Check Specs and Run Quality Tools

```bash
bin/build
```

## Credits

It was written by [Flatstack](http://www.flatstack.com) with the help of our
[contributors](http://github.com/fs/ruby-base/contributors).
