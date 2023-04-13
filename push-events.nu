
def get-events [] { 
   	let keywords = [ "made", "left", "joined", "server", "was", "wall", "drowned", "fell", "flames", "swim" ] 
	open log 
	| lines 
	| each { |x| $x | parse "{prefix} [{date} {level}]: {msg}"  }  
	| filter {|x| ($x | length ) > 0  } 
        | each { |x| $x | first }
        | filter { |x| $keywords | any { |keyword| $x.msg | str contains $keyword } }
        | each { |x| insert hash ($x.date + $x.msg|hash sha256) } 
}


def ops [msg: string] {
  let url = https://matrix.martinides.de/webhook/d0350dc8-aa26-46d4-8b3e-28ea5d90900f
  http post -t application/json $url { text: $msg username: unitedtwins }

}

def logger [msg: string] {
  print $msg
}

def msgs-sent-db-exists [] {
  logger "Checking msg db"
  if (echo msgs-sent.db | path exists) { return }
  [{ hash: 0000 }] | into sqlite msgs-sent.db 
  logger "msgs-send.db db created"
}

def was-hash-sent [hash: string] {
   let result_length = (open msgs-sent.db | get main | where hash == $hash | length )
   if ($result_length == 0) { false } else { true }
} 

def send-msg [event: record] {
   logger $"sending ($event.msg) ($event.hash)"
   ops $event.msg
   open msgs-sent.db | query db $"INSERT INTO main \(hash\) VALUES \('($event.hash)'\);"
}

def main [] {
  cd /home/msm/docker-minecraft-server
  docker compose logs | save -f log
  msgs-sent-db-exists 
  get-events | each { |x| if (was-hash-sent $x.hash) == false { send-msg $in }  }
}

