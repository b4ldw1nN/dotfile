function lock --wraps='fusermount -u ~/unvault' --description 'alias lock=fusermount -u ~/unvault'
    fusermount -u ~/unvault $argv
end
