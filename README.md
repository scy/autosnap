# autosnap: automatically take pictures of yourself
This is a self-documentation, post-privacy, psychology and art project by [@scy][twitter].

The code here contains the scripts and tools I use to let several of my devices (laptops, mobile phones, tablets) shoot photos of myself in regular intervals. These photos are then uploaded to The Cloud™.

I held a (German) talk about the project and its psychological implications at the #spack1 in 2012: [Le panoptique, c’est moi][lpcm]. The recordings are not yet available, but [my presentation notes][lpcm-notes].

## Basic folder structure
I use Dropbox for incoming photos and Google Drive for permanent archival, but you can use only one of them, if you want to. In fact, autosnap doesn’t depend on cloud storage at all, so if you want to sync via some other method, feel free to do that. autosnap simply stores in files, all the cloud stuff happens outside of it.

    * Google Drive
      * autosnap
        * 2012
          * 10
            * 31
              * 2012-10-31_23-50-00_autosnap_crys.jpg
    * Dropbox
      * autosnap
        * incoming
        * today

## Configuring machines
In the following examples, `$HOME/autosnap` always means the directory where this repository is checked out to.

### The maintenance machine
The maintenance machine should optimally be running 24/7. It takes the photos from the incoming folder, renames them, puts them into the correct output folder and maintains the “today” folder.

On my Mac mini, the following cron does that:

    * * * * * "$HOME/autosnap/run-autosnap-maintenance.sh" "$HOME/Dropbox/autosnap" "$HOME/Google Drive/autosnap" > /tmp/autosnap.log 2>&1

Parameters are the input directory and, if you want to, an output directory. Else, the input directory is used.

### A Mac/Linux laptop
On these machines, [imagesnap][] (in [Homebrew][homebrew])or [fswebcam][] are used to take photos and put them into an output directory. I’m using the following cron:

    */10 * * * * "$HOME/autosnap/autosnap.sh" "$HOME/Dropbox/autosnap/incoming" >/dev/null 2>&1

### An Android mobile phone or tablet
On these machines, I use a [Tasker][tasker] script to capture the images and [FolderSync][foldersync] to throw them into Dropbox.

The tasker script is included in this repository as `autosnap.tsk.xml`, FolderSync is configured to sync Tasker’s output directory to Dropbox’s `autosnap/incoming` directory and delete the files on the mobile/tablet afterwards.

(I’ll add more documentation here soon.)

[twitter]:    https://twitter.com/scy
[lpcm]:       http://lanyrd.com/2012/spack1/szdzt/
[lpcm-notes]: https://workflowy.com/shared/ede5f605-4719-fc16-ce77-b08a3169d379/
[imagesnap]:  http://iharder.sourceforge.net/current/macosx/imagesnap/
[fswebcam]:   http://www.firestorm.cx/fswebcam/
[homebrew]:   http://mxcl.github.com/homebrew/
[tasker]:     http://tasker.dinglisch.net/
[foldersync]: http://www.tacit.dk/foldersync
