bool permissionsOkay = false;
bool CheckRequiredPermissions() {
    permissionsOkay = Permissions::PlayLocalMap();
    if (!permissionsOkay) {
        NotifyWarn("Your edition of the game does not support playing playing local maps.\n\nThis plugin won't work, sorry :(.");
