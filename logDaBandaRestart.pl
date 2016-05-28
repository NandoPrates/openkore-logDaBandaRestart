# logDaBandaRestart plugin by marcelofoxes/revok
#
# 23:42 segunda-feira, 6 de fevereiro de 2012
#	- released !
#
# This source code is licensed under the
# GNU General Public License, Version 2.
# See http://www.gnu.org/licenses/gpl.html

package logDaBandaRestart;

use strict;

use Plugins;
use Commands;
use Log qw( warning message error );
use Settings;
use Globals;
use Misc;
use Utils qw( timeOut getFormattedDate );
use Time::HiRes;

use constant {
	PLUGINNAME				=>	"logDaBandaRestart",
};


#-----------------
# Plugin: settings
#-----------------
Plugins::register(PLUGINNAME, "check your logs folder !", \&unload);

# Log hook
my $logHook = Log::addHook(\&on_Log, PLUGINNAME);



#---------------
# Plugin: unload
#---------------
sub unload {
   Log::delHook($logHook);
   undef $logHook;
}

#-------------
# Log: handler
#-------------

sub on_Log {
	my ($type, $domain, $level, $globalVerbosity, $message, $user_data) = @_;
	
	if ($level <= $globalVerbosity) {
    my $msgColor;
    if (defined $consoleColors{$type}{$domain}) {
            $msgColor = $consoleColors{$type}{$domain};
        } elsif ($type eq "warning") {
            $msgColor = $consoleColors{warning}{default};
        } elsif ($type eq "error") {
            $msgColor = $consoleColors{error}{default};
        } elsif ($type eq "debug") {
            $msgColor = $consoleColors{debug}{default};
        } else {
            $msgColor = 'default';
    }
	
	$message =~ s/\</\&lt\;/g;
	$message =~ s/\>/\&gt\;/g;
	$message =~ s/(\r\n|\n|\r)+/<\/br>/g;
	my $message2 ="<span class=\"".$msgColor."\">[".getFormattedDate(time)."] ".$message."</span>";
	
	open(F, ">>:utf8", "$Settings::logs_folder/console.html");
		if(-z "$Settings::logs_folder/console.html") {
			print F q(
<head><style type="text/css">

body {
	background-color: black;
	font-family: "Lucida Console";
	font-weight: bold;
	font-size: 12px;
}

.default {
	color: #c0c0c0;
}

.yellow {
	color: #ffff00;
}

.darkgreen {
	color: #008000;
}

.green {
	color: #00FF00;
}

.white {
	color: #FFFFFF;
}

.red {
	color: #FF0000;
}

.cyan {
	color: #00FFFF;
}

.darkmagenta {
	color: #800080;
}

.magenta {
	color: #ff00ff;
}

.blue {
	color: #0000ff;
}

.darkcyan {
	color: #008080;
}

.brown {
	color: #808000;
}

 </style>
 <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
 </head>
 );
		}
		print F $message2."\n";
		close(F);
	}
	
}

1;