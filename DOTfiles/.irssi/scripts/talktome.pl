##
## Talk To Me is an irssi script which executes a command whenever 
## someone sends you a private message or mentions your name in a channel.
##
## It then stores these messages and unless you interact with irssi
## within 2 minutes, it notifies you of them.
##
## Talk To Me supports both local and remote notification.
## See SETTINGS for more information.
##
##
## See the settings further down.
##
## Put me in ~/.irssi/scripts, and then execute the following in irssi:
##
##       /load perl
##       /script load talktome
##

##
## SETTINGS:
##

## Notification method - local or remote
##
## 1. If irssi is running on your local computer, select 'local' here.
## 2. If irssi is running on a remote computer through e.g. SSH,
##    take a look at http://www.pseudoberries.com/blog/?page_id=87
##    for information on how to set up remote notification.
our $notify_method = 'local';


##
## For LOCAL notification method
#######################################

## Command to execute for every highlighted message
our $ping_cmd	   = 'flash-thinklight.sh & sound_irssi.sh';
#our $ping_cmd	   = 'flash-thinklight.sh';

## Command to execute if there's no activity within $notify_delay seconds.
our $notify_cmd	   = "notify-send -t 0 -i /home/andywxy/.icons/hydroxygen/24x24/status/dialog-question.png";



##
## For REMOTE notification method
#######################################

## Hostname for remote notify service
our $host		   = 'localhost';

## Port for remote notify service
our $port		   = 6666;

## Command used to communicate with the remote 
## notification service
our $rcmd		   = "nc $host $port";



##
## GLOBAL settings
#######################################

## Format for the notification. Will be passed to $notify_cmd.
## The first %s will be replaced by the target (channel/nick), the last
## with the messages. See $notify_msg_format.
our $notify_format = "<span size=\"xx-large\">%s</span>\n%s";

## Message format.
our $notify_msg_format = "<span weight=\"normal\">[%02d:%02d:%02d] &lt; %s&gt; %s</span>";

## Delay for executing the $notify_cmd when there's no activity.
our $notify_delay  = 120;

##
## END OF SETTINGS
##



use Irssi;
use IO::Handle;
use vars qw($VERSION %IRSSI);

$VERSION = '1.2';
%IRSSI = (
	author		=> 'Johannes Jensen',
	contact		=> 'joh@pseudoberries.com',
	name		=> 'Talk To Me',
	description => 'This script notifies you if anyone tries to talk to you',
	license     => 'GNU General Public License',
	url			=> 'http://www.pseudoberries.com/blog/?page_id=87',
	changed 	=> 'Mon Aug 11 2008'
);

our $ltime = time;
our %msgqueue = ();

sub updatetime {
	$ltime = time;
}

sub activity { 
	updatetime;
#	print "Activity, clearing queue" if (keys %msgqueue > 0);
	%msgqueue = ();
}

# Send messages to the remote notification daemon
# TODO: Fork so we don't block.
sub notify_remote {
#	print "notify_remote!";
	
	open(my $fh, "|-", "$rcmd");
	$fh->blocking(0);
	
	foreach (@_) {
#		print "$_";
		print $fh "$_\n";
	}
	print $fh "\n\n\n";
	
	undef $fh;
}

# Notify user of a new message
sub ping {
	if ($notify_method eq 'remote') {
		notify_remote("ping");
	} else {
		system($ping_cmd);
	}
}

# Notify user with list new messages
sub notify {
	my ($msgs) = @_;
	
	if ($notify_method eq 'remote') {
		notify_remote("messages", $msgs);
	} else {
		my @args = split(/ /, $notify_cmd);
		push (@args, $msgs);
		system (@args) == 0 or print "Executing @args failed: $?";
#		print "Executing @args ...";
	}
}

sub event_msg {
	my ($server, $data, $nick) =@_;
	my ($target, $text) = $data =~ /^(\S*)\s:(.*)/;
	
	return if $server->ignore_check($nick, $mask, $target, $text, MSGLEVEL_MSGS);
	return if !$server;
	
	my $mynick = $server->{nick};
	
	# Event if private message or mynick mentioned in a channel
	if ($target !~ /#/ || $text =~ /$mynick/) {
		# Determine whether it's a valid match
		return if $text =~ /[[:alpha:]]+$mynick/;
		return if $text =~ /$mynick[[:alpha:]]+/;
		
		ping();
		
		$text =~ s/</&lt;/g;
		$text =~ s/>/&gt;/g;
		
		($sec,$min,$hour) = localtime();
		$msgqueue{$target} .= "\n" if exists $msgqueue{$target};
		$msgqueue{$target} .= sprintf ($notify_msg_format, $hour, $min, $sec, $nick, $text);
		
		updatetime;
	}
}

sub update { 
	return if keys %msgqueue == 0;
	
	if (time - $ltime > $notify_delay) {
		# $notify_delay seconds since any activity, show notificiation
		my $msgs = '';
		foreach (keys %msgqueue) {
			$msgs .= "\n" if length $msgs > 0;
			$msgs .= sprintf ($notify_format, $_, $msgqueue{$_});
		}
		
		notify($msgs);
		
		# clear message queue
		activity;
	}
}

Irssi::signal_add('event privmsg', 'event_msg');
Irssi::signal_add('gui key pressed', 'activity');
Irssi::timeout_add(1000, 'update', 0);
