From: akpm@linux-foundation.org
Subject: + pavel-has-moved.patch added to -mm tree
Date: Wed, 18 Feb 2009 10:19:08 -0800
Message-ID: <200902181819.n1IIJ8NW016441@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59911 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754039AbZBRSUI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Feb 2009 13:20:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@suse.cz, jkosina@suse.cz, pavel@ucw.cz


The patch titled
     Pavel has moved
has been added to the -mm tree.  Its filename is
     pavel-has-moved.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Pavel has moved
From: Pavel Machek <pavel@suse.cz>

My @suse.cz address will stop working some day, so put working one into
MAINTAINERS/CREDITS.  It would be cool to get this to 2.6.29...  it should
not really break anything.

Signed-off-by: Pavel Machek <pavel@ucw.cz>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS     |    1 -
 MAINTAINERS |    4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN CREDITS~pavel-has-moved CREDITS
--- a/CREDITS~pavel-has-moved
+++ a/CREDITS
@@ -2166,7 +2166,6 @@ D: Initial implementation of VC's, pty's
 
 N: Pavel Machek
 E: pavel@ucw.cz
-E: pavel@suse.cz
 D: Softcursor for vga, hypertech cdrom support, vcsa bugfix, nbd
 D: sun4/330 port, capabilities for elf, speedup for rm on ext2, USB,
 D: work on suspend-to-ram/disk, killing duplicates from ioctl32
diff -puN MAINTAINERS~pavel-has-moved MAINTAINERS
--- a/MAINTAINERS~pavel-has-moved
+++ a/MAINTAINERS
@@ -2001,7 +2001,7 @@ S:	Maintained
 
 HIBERNATION (aka Software Suspend, aka swsusp)
 P:	Pavel Machek
-M:	pavel@suse.cz
+M:	pavel@ucw.cz
 P:	Rafael J. Wysocki
 M:	rjw@sisk.pl
 L:	linux-pm@lists.linux-foundation.org
@@ -4172,7 +4172,7 @@ SUSPEND TO RAM
 P:	Len Brown
 M:	len.brown@intel.com
 P:	Pavel Machek
-M:	pavel@suse.cz
+M:	pavel@ucw.cz
 P:	Rafael J. Wysocki
 M:	rjw@sisk.pl
 L:	linux-pm@lists.linux-foundation.org
_

Patches currently in -mm which might be from pavel@suse.cz are

pavel-has-moved.patch
linux-next.patch
resume-wait-for-device-probing-to-finish.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code.patch
pm-fix-build-for-config_pm-unset.patch
hp-accelerometer-add-freefall-detection.patch
lis3lv02d-support-both-one-and-two-byte-sensors.patch
lis3lv02d-support-both-one-and-two-byte-sensors-checkpatch-fixes.patch
lis3lv02d-add-axes-knowledge-of-hp-pavilion-dv5-models.patch
ext2-add-blk_issue_flush-to-syncing-paths.patch
nbd-add-locking-to-nbd_ioctl.patch
nbd-add-locking-to-nbd_ioctl-checkpatch-fixes.patch
nbd-add-locking-to-nbd_ioctl-fix.patch
nbd-trivial-cleanups.patch

