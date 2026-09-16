function unlock --wraps='gocryptfs ~/vault ~/unvault' --description 'alias unlock=gocryptfs ~/vault ~/unvault'
    gocryptfs ~/vault ~/unvault $argv
end
