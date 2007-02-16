From: akpm@linux-foundation.org
Subject: + setstream-param-for-psmouse-tweak.patch added to -mm tree
Date: Fri, 16 Feb 2007 10:20:58 -0800
Message-ID: <200702161820.l1GIKwZc006070@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57252 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946181AbXBPSVM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 13:21:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, andrea@suse.de, dtor@mail.ru, vojtech@suse.cz


The patch titled
     setstream-param-for-psmouse-tweak
has been added to the -mm tree.  Its filename is
     setstream-param-for-psmouse-tweak.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: setstream-param-for-psmouse-tweak
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Andrea Arcangeli <andrea@suse.de>
Cc: Vojtech Pavlik <vojtech@suse.cz>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/mouse/psmouse-base.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/input/mouse/psmouse-base.c~setstream-param-for-psmouse-tweak drivers/input/mouse/psmouse-base.c
--- a/drivers/input/mouse/psmouse-base.c~setstream-param-for-psmouse-tweak
+++ a/drivers/input/mouse/psmouse-base.c
@@ -69,9 +69,9 @@ MODULE_PARM_DESC(resync_time, "How long 
  * The setstream parameter is needed if you have an ACK 580 that stops
  * streaming if you ever enable the streaming mode explicitly.
  */
-static unsigned int psmouse_setstream = 1;
+static unsigned int psmouse_setstream;
 module_param_named(setstream, psmouse_setstream, uint, 0644);
-MODULE_PARM_DESC(setstream, "Turn on streaming mode explicitly, 1 = enabled (default), 0 = disabled.");
+MODULE_PARM_DESC(setstream, "Turn on streaming mode explicitly, 1 = enabled, 0 = disabled (default).");
 
 PSMOUSE_DEFINE_ATTR(protocol, S_IWUSR | S_IRUGO,
 			NULL,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
git-agpgart.patch
git-arm.patch
git-cpufreq.patch
git-powerpc.patch
git-drm.patch
git-dvb.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
sis-warning-fixes.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-md-accel-fix.patch
git-mips-fixup.patch
git-mtd.patch
git-netdev-all.patch
e1000-fix-shared-interrupt-warning-message-fix.patch
Fabric7-VIOC-driver-fixes.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
git-s390.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-unionfs-fixup.patch
after-before-x86_64-mm-mmconfig-share.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
kprobes-list-all-active-probes-in-the-system.patch
reduce-size-of-task_struct-on-64-bit-machines-fix.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-epoll-compat-code-to-kernel-compatc-tidy.patch
genalloc-warning-fixes.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
revert-x86_64-mm-putreg-check.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
git-gccbug-fixup.patch
