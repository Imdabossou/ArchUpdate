#! /bin/bash


post_install () {
	systemctl enable --now archupdate.timer
	systemctl enable --user --global archupdate-notifier.service
}


post_upgrade () {
	systemctl --system daemon-reload
	systemctl restart archupdate.timer
	systemctl enable --user --global archupdate-notifier.service
}


pre_remove () {
	systemctl disable --user --global archupdate-notifier.service
	systemctl disable --now archupdate.timer
}


post_remove () {
	systemctl --system daemon-reload
}
