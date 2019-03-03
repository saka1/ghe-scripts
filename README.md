
# ghe-ops-scripts

## About
Misc scripts for operations of GitHub Enterprise.

## Requirements
- Ruby & bundler


## Install

```
$ bundle install
```

Then, create your `.env` file.

```
cp .env.sample .env
vi .env # edit
```


## Usage

### Scheduled maintainance

Check if [chronic](https://github.com/mojombo/chronic) can parse the argument.

```
$ bundle exec ./test_chronic.rb 'today 14:50'
```

Enable a scheduled maintainance.

```
$ bundle exec ./schedule_maintainance.rb 'today 14:50'
```

