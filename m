From: akpm@osdl.org
Subject: + sysrq-alphabetize-command-keys-doc.patch added to -mm tree
Date: Mon, 08 Jan 2007 14:50:23 -0800
Message-ID: <200701082250.l08MoNFB021486@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50744 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932176AbXAHWvX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 17:51:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     sysrq: alphabetize command keys doc
has been added to the -mm tree.  Its filename is
     sysrq-alphabetize-command-keys-doc.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysrq: alphabetize command keys doc
From: Randy Dunlap <randy.dunlap@oracle.com>

Alphabetize the sysrq command keys list.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/sysrq.txt |   44 +++++++++++++++++++-------------------
 1 files changed, 22 insertions(+), 22 deletions(-)

diff -puN Documentation/sysrq.txt~sysrq-alphabetize-command-keys-doc Documentation/sysrq.txt
--- a/Documentation/sysrq.txt~sysrq-alphabetize-command-keys-doc
+++ a/Documentation/sysrq.txt
@@ -64,11 +64,6 @@ On all -  write a character to /proc/sys
 
 *  What are the 'command' keys?
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-'r'     - Turns off keyboard raw mode and sets it to XLATE.
-
-'k'     - Secure Access Key (SAK) Kills all programs on the current virtual
-          console. NOTE: See important comments below in SAK section.
-
 'b'     - Will immediately reboot the system without syncing or unmounting
           your disks.
 
@@ -76,21 +71,37 @@ On all -  write a character to /proc/sys
 
 'd'	- Shows all locks that are held.
 
-'o'     - Will shut your system off (if configured and supported).
+'e'     - Send a SIGTERM to all processes, except for init.
 
-'s'     - Will attempt to sync all mounted filesystems.
+'f'	- Will call oom_kill to kill a memory hog process.
 
-'u'     - Will attempt to remount all mounted filesystems read-only.
+'g'	- Used by kgdb on ppc platforms.
 
-'p'     - Will dump the current registers and flags to your console.
+'h'     - Will display help (actually any other key than those listed
+          above will display help. but 'h' is easy to remember :-)
 
-'t'     - Will dump a list of current tasks and their information to your
-          console.
+'i'     - Send a SIGKILL to all processes, except for init.
+
+'k'     - Secure Access Key (SAK) Kills all programs on the current virtual
+          console. NOTE: See important comments below in SAK section.
 
 'm'     - Will dump current memory info to your console.
 
 'n'	- Used to make RT tasks nice-able
 
+'o'     - Will shut your system off (if configured and supported).
+
+'p'     - Will dump the current registers and flags to your console.
+
+'r'     - Turns off keyboard raw mode and sets it to XLATE.
+
+'s'     - Will attempt to sync all mounted filesystems.
+
+'t'     - Will dump a list of current tasks and their information to your
+          console.
+
+'u'     - Will attempt to remount all mounted filesystems read-only.
+
 'v'	- Dumps Voyager SMP processor info to your console.
 
 'w'	- Dumps tasks that are in uninterruptable (blocked) state.
@@ -102,17 +113,6 @@ On all -  write a character to /proc/sys
           it so that only emergency messages like PANICs or OOPSes would
           make it to your console.)
 
-'f'	- Will call oom_kill to kill a memory hog process.
-
-'e'     - Send a SIGTERM to all processes, except for init.
-
-'g'	- Used by kgdb on ppc platforms.
-
-'i'     - Send a SIGKILL to all processes, except for init.
-
-'h'     - Will display help (actually any other key than those listed
-          above will display help. but 'h' is easy to remember :-)
-
 *  Okay, so what can I use them for?
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 Well, un'R'aw is very handy when your X server or a svgalib program crashes.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-alsa.patch
qconf-immediately-update-integer-and-string-values-in-xconfig-display.patch
git-mtd.patch
parisc-fix-module_param-iommu-permission.patch
git-scsi-rc-fixes.patch
megaraid-fix-kernel-doc.patch
kernel-doc-allow-a-little-whitespace.patch
sysrq-showblockedtasks-is-sysrq-w.patch
sysrq-alphabetize-command-keys-doc.patch
reiser4-use-null-for-pointers.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
profile_likely-export-do_check_likely.patch
