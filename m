From: akpm@linux-foundation.org
Subject: [merged] pavel-has-moved.patch removed from -mm tree
Date: Thu, 19 Feb 2009 11:16:32 -0800
Message-ID: <200902191916.n1JJGW3i016258@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753464AbZBSTQo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 14:16:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@suse.cz, jkosina@suse.cz, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     Pavel has moved
has been removed from the -mm tree.  Its filename was
     pavel-has-moved.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
resume-wait-for-device-probing-to-finish.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code.patch
ext2-add-blk_issue_flush-to-syncing-paths.patch
nbd-add-locking-to-nbd_ioctl.patch
nbd-add-locking-to-nbd_ioctl-checkpatch-fixes.patch
nbd-add-locking-to-nbd_ioctl-fix.patch
nbd-trivial-cleanups.patch

