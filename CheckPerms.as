void Main() {
    CheckRequiredPermissions();
}

bool permissionsOkay = false;
void CheckRequiredPermissions() {
    permissionsOkay = Permissions::PlayLocalMap();
    if (!permissionsOkay) {
        NotifyWarn("Your edition of the game does not support playing playing local maps.\n\nThis plugin won't work, sorry :(.");
        while(true) { sleep(10000); }
    }
}