use strict;
use vars qw($VERSION %IRSSI);

use Irssi;
$VERSION = '0.0.3';
%IRSSI = (
        authors     => 'Chrelad',
        contact     => 'blah@blah.blah',
        name        => 'alert',
        description => 'Play sounds for different events in IRSSI.',
        url         => 'http://google.com',
        license     => 'GNU General Public License',
        changed     => '$Date: 2007-02-07 12:00:00 +0100 (Thu, 7 Feb 2008) $'
);

#--------------------------------------------------------------------
# Created by Chrelad
# Feb 7, 2008
#--------------------------------------------------------------------

#--------------------------------------------------------------------
# The sound playing function for public message
#--------------------------------------------------------------------

sub pub_msg {
        my ($server,$msg,$nick,$address,$target) = @_;
        `mplayer -nolirc -really-quiet ~/Desktop/Sound/Feather_sound_set_v05/new_mail_notification.wav > /dev/null`;
}

#--------------------------------------------------------------------
# Irssi::signal_add_last / Irssi::command_bind
#--------------------------------------------------------------------

Irssi::signal_add_last("message public", "pub_msg");
#- end

