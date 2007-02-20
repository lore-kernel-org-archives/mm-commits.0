From: akpm@linux-foundation.org
Subject: - machzwd-warning-fix.patch removed from -mm tree
Date: Tue, 20 Feb 2007 12:08:33 -0800
Message-ID: <200702202008.l1KK8XSb018188@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46819 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965242AbXBTUIj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Feb 2007 15:08:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     machzwd warning fix
has been removed from the -mm tree.  Its filename was
     machzwd-warning-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: machzwd warning fix
From: Andrew Morton <akpm@linux-foundation.org>

drivers/char/watchdog/machzwd.c: In function 'zf_ioctl':
drivers/char/watchdog/machzwd.c:327: warning: passing argument 1 of 'zf_ping' makes integer from pointer without a cast

Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/watchdog/machzwd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/watchdog/machzwd.c~machzwd-warning-fix drivers/char/watchdog/machzwd.c
--- a/drivers/char/watchdog/machzwd.c~machzwd-warning-fix
+++ a/drivers/char/watchdog/machzwd.c
@@ -324,7 +324,7 @@ static int zf_ioctl(struct inode *inode,
 			return put_user(0, p);
 
 		case WDIOC_KEEPALIVE:
-			zf_ping(NULL);
+			zf_ping(0);
 			break;
 
 		default:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
xfs-warning-fix.patch
rework-reserved-major-handling.patch
make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-drm.patch
git-dvb.patch
pvrusb-warning-fix.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
git-libata-all.patch
dmaengine-uninline-large-functions.patch
git-mips-fixup.patch
Fabric7-VIOC-driver-fixes.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
git-parisc.patch
git-parisc-fixup.patch
git-pciseg.patch
git-s390.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-unionfs.patch
git-unionfs-fixup.patch
after-before-x86_64-mm-mmconfig-share.patch
xen-paravirt-core-xen-implementation-fix.patch
mincore-warning-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
kprobes-list-all-active-probes-in-the-system.patch
reduce-size-of-task_struct-on-64-bit-machines-fix.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-epoll-compat-code-to-kernel-compatc-tidy.patch
genalloc-warning-fixes.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
fb-sm501-framebuffer-driver-5-fix.patch
