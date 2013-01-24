# autosnap: automatically take pictures of yourself
This is a self-documentation, post-privacy, psychology and art project by [@scy][twitter].

The code here contains the scripts and tools I use to let several of my devices (laptops, mobile phones, tablets) shoot photos of myself in regular intervals. These photos are then uploaded to The Cloud™.

I held a (German) talk about the project and its psychological implications at the #spack1 in 2012: [Le panoptique, c’est moi][lpcm]. The recordings are not yet available, but [my presentation notes][lpcm-notes] are.

## What does it do?
1. Automatically shoots photos of myself.
2. Automatically uploads these photos to a private Dropbox folder.
3. Automatically renames and archives these photos to a private Google Drive folder.
4. Automatically puts all photos of the current day into a shared Dropbox folder.

## Why?
In short: As an experiment. How does it feel to have photos taken everywhere you are, even in the bathroom. And to show these photos to people, without first selecting which ones to show. You never know _what_ gets photographed.

Long story: Read [my talk description][lpcm], but it’s in German only.

## What do I need?
autosnap is flexible. Feel free to implement your own methods and maybe send me patches.

What you most definitely need: Something that shoots photos of yourself. The code currently supports Android devices running [Tasker][tasker] and [FolderSync][foldersync] (both are paid apps) as well as Macs running [imagesnap][] and Linux boxes with [fswebcam][].

The scripts simply put files into folders or take them from there, all the cloud stuff is done by third party software: FolderSync or the Dropbox or Google Drive clients.

## Basic folder structure
I use Dropbox for incoming photos and Google Drive for permanent archival, but you can use only one of them, if you want to. In fact, autosnap doesn’t depend on cloud storage at all, so if you want to sync via some other method, feel free to do that. autosnap simply stores in files, all the cloud syncing happens outside of it.

    * Google Drive/
      * autosnap/
        * 2012/      (one folder for each year)
          * 10/      (one folder for each month)
            * 31/    (one folder for each day)
              * 2012-10-31_23-50-00_autosnap_crys.jpg
              * (more files named YYYY-MM-DD_hh-mm-ss_autosnap_devicename.jpg)
    * Dropbox/
      * autosnap/
        * incoming/  (where incoming files go to)
        * today/     (the shared folder that contains today’s files)

## Configuring machines
In the following examples, `$HOME/autosnap` always means the directory where this repository is checked out to.

### The maintenance machine
The maintenance machine should optimally be running 24/7. It takes the photos from the incoming folder, renames them, puts them into the correct output folder and maintains the “today” folder.

On my Mac mini, the following cron does that:

    * * * * * "$HOME/autosnap/run-autosnap-maintenance.sh" "$HOME/Dropbox/autosnap" "$HOME/Google Drive/autosnap" > /tmp/autosnap.log 2>&1

Parameters are the input directory (`/incoming` will be appended) and, if you want to, an output directory (the `YYYY/MM/DD` subdirectories will be created there). Else, the input directory is used as output directory as well (which works fine, because input will be in `incoming` and output in the date-based directories).

### A Mac/Linux laptop
On these machines, [imagesnap][] (in [Homebrew][homebrew]) or [fswebcam][] are used to take photos and put them into an output directory. I’m using the following cron:

    */10 * * * * "$HOME/autosnap/autosnap.sh" "$HOME/Dropbox/autosnap/incoming" >/dev/null 2>&1

The parameter is the directory where the files should be put in.

### An Android mobile phone or tablet
On these machines, I use a [Tasker][tasker] script to capture the images and [FolderSync][foldersync] to throw them into Dropbox.

The tasker script is included in this repository as `autosnap.tsk.xml`.

1. Install FolderSync and Tasker.
2. For convenience, put `autosnap.tsk.xml` into whatever you’re going to let your phone (or tablet) push the images to, for example the Dropbox `autosnap/incoming` folder.
3. Start FolderSync and, in the “Accounts” section, add your Dropbox or whatever account.
4. Use the FolderSync file manager to locate and open the `autosnap.tsk.xml` file with Tasker. You should now have an “autosnap” task in Tasker.
5. In Tasker, customize the task. Edit step 6 (“Take Photo”) and choose the right camera (“Front”, I guess), resolution (you can browse for supported ones) and set the filename to `autosnap_devicename`, where `devicename` is a unique name for the device you’re on. The rest of the settings (chronological naming, don’t insert in gallery, discreet) should already be set correctly.
6. In Tasker’s “Profile” section, create a new profile that actually triggers autosnap. Choose a name and use Event/Display/Display On as the triggering event. Then, select “autosnap” as the task to run. That’s it.
7. In FolderSync, get to the “Folder Pairs” section and create a new one for your Dropbox (or whatever) account. The remote folder is `/autosnap/incoming`, if you follow my setup. The local folder would be something like `/storage/sdcard0/DCIM/Tasker`. Type of sync is “to remote folder”. You don't need scheduled syncing, instead select automatic sync and “move source files”. Select whether you only want to sync on WiFi, or on mobile data connections as well.
8. Switch your display off and on again. Tasker should take a photo and FolderSync should upload it moments later.

(Disclaimer: I didn’t test these steps on a new machine. Also, my FolderSync talks German, I’m not sure whether I got the setting names right.)

## What do all the files do?
* **autosnap.sh:** Takes a photo and puts it into the output directory defined as its first parameter (or `$HOME/Dropbox/autosnap/incoming` if you didn’t specify anything). Run this from your crontab.
* **run-autosnap-maintenance.sh:** Runs the renamer, mover and rsyncer in the right order and with the right parameters. See “The maintenance machine” above for usage.
* **autosnap-renamer.sh:** Tasker’s datestamped file names aren’t the best and not even consistent, so this script does some cleanup on the file name in the directory passed in the `AUTOSNAPRNIN` environment variable.
* **autosnap-mover.sh:** Moves the files in `$AUTOSNAPMVFROM` to date-based subdirectories in `$AUTOSNAPMVTO`.
* **autosnap-rsyncer.sh:** Copies the files in today’s date-based subfolder of `$AUTOSNAPRSYNCFROM` over to the `$AUTOSNAPRSYNCTO` folder using rsync. It uses the `--del` flag; everything in the target directory will be deleted!

If you need more information, the code isn’t too hard to read. Alternatively, ask a question, file an issue or send a pull request.

## Known issues

* When Tasker takes a photo, your device may become unresponsive for about three seconds. Also, the system volume may be set to mute, video playback can stop, full-screen apps can exit full-screen mode and, most importantly, the on-screen keyboard can close.

[twitter]:    https://twitter.com/scy
[lpcm]:       http://lanyrd.com/2012/spack1/szdzt/
[lpcm-notes]: https://workflowy.com/shared/ede5f605-4719-fc16-ce77-b08a3169d379/
[imagesnap]:  http://iharder.sourceforge.net/current/macosx/imagesnap/
[fswebcam]:   http://www.firestorm.cx/fswebcam/
[homebrew]:   http://mxcl.github.com/homebrew/
[tasker]:     http://tasker.dinglisch.net/
[foldersync]: http://www.tacit.dk/foldersync
