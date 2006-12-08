From: akpm@osdl.org
Subject: + proc_misc-build-fix.patch added to -mm tree
Date: Fri, 08 Dec 2006 02:37:04 -0700
Message-ID: <200612080937.kB89b6bX015135@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:41746 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425290AbWLHJhI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 04:37:08 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id kB89b6ID023886
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 8 Dec 2006 01:37:07 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@osdl.org


The patch titled

     proc_misc build fix

has been added to the -mm tree.  Its filename is

     proc_misc-build-fix.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: proc_misc build fix
From: Andrew Morton <akpm@osdl.org>


fs/proc/proc_misc.c: In function `version_read_proc':
fs/proc/proc_misc.c:256: warning: implicit declaration of function `utsname'


Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/proc/proc_misc.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN fs/proc/proc_misc.c~proc_misc-build-fix fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~proc_misc-build-fix
+++ a/fs/proc/proc_misc.c
@@ -39,6 +39,7 @@
 #include <linux/seq_file.h>
 #include <linux/times.h>
 #include <linux/profile.h>
+#include <linux/utsname.h>
 #include <linux/blkdev.h>
 #include <linux/hugetlb.h>
 #include <linux/jiffies.h>
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
tty-signal-tty-locking.patch
pktcdvd-bio-write-congestion-using-blk_congestion_wait.patch
fsstack-introduce-fsstack_copy_attrinode_.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel.patch
add-process_session-helper-routine-deprecate-old-field.patch
mxser-session-warning-fix.patch
mxser-workqueue-fixes.patch
tty-switch-to-ktermios-and-new-framework.patch
tty-switch-to-ktermios.patch
tty_ioctl-use-termios-for-the-old-structure-and-termios2.patch
drivers-isdn-handcrafted-min-max-macro-removal.patch
fault-injection-capabilities-infrastructure.patch
fault-injection-Kconfig-cleanup.patch
fault-injection-stacktrace-filtering-kconfig-fix.patch
sysctl-fix-sys_sysctl-interface-of-ipc-sysctls.patch
video-get-the-default-mode-from-the-right-database.patch
various-fbdev-files-mark-structs.patch
backlight-lcd-remove-dependenct-from-the-framebuffer-layer.patch
gxfb-fixups-for-the-amd-geode-gx.patch
gxfb-support-flat-panel-timings.patch
gxfb-support-command-line-options.patch
proc_misc-build-fix.patch

