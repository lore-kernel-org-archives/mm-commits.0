From: akpm@linux-foundation.org
Subject: - git-gccbug-fixup.patch removed from -mm tree
Date: Sat, 17 Feb 2007 18:04:45 -0800
Message-ID: <200702180204.l1I24jLP008166@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55508 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161048AbXBRCEr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 21:04:47 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l1I24khB021726
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Sat, 17 Feb 2007 18:04:46 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     git-gccbug-fixup
has been removed from the -mm tree.  Its filename was
     git-gccbug-fixup.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: git-gccbug-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/net/kaweth.c |    4 ----
 kernel/auditfilter.c     |    4 ----
 2 files changed, 8 deletions(-)

diff -puN drivers/usb/net/kaweth.c~git-gccbug-fixup drivers/usb/net/kaweth.c
--- a/drivers/usb/net/kaweth.c~git-gccbug-fixup
+++ a/drivers/usb/net/kaweth.c
@@ -1291,11 +1291,7 @@ static int kaweth_internal_control_msg(s
 {
         struct urb *urb;
         int retv;
-<<<<<<< HEAD/drivers/usb/net/kaweth.c
-        int length = 0; /* shut up GCC */
-=======
         int length = 0;
->>>>>>> /drivers/usb/net/kaweth.c
 
         urb = usb_alloc_urb(0, GFP_NOIO);
         if (!urb)
diff -puN kernel/auditfilter.c~git-gccbug-fixup kernel/auditfilter.c
--- a/kernel/auditfilter.c~git-gccbug-fixup
+++ a/kernel/auditfilter.c
@@ -1604,10 +1604,6 @@ int audit_filter_user(struct netlink_skb
 {
 	enum audit_state state = AUDIT_DISABLED;
 	struct audit_entry *e;
-<<<<<<< HEAD/kernel/auditfilter.c
-=======
-	enum audit_state state = AUDIT_DISABLED;
->>>>>>> /kernel/auditfilter.c
 	int ret = 1;
 
 	rcu_read_lock();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
xfs-warning-fix.patch
machzwd-warning-fix.patch
make-aout-executables-work-again-fix.patch
git-acpi.patch
sony-laptop-fix-uninitialised-variable.patch
git-arm.patch
git-powerpc.patch
git-drm.patch
git-dvb.patch
pvrusb-warning-fix.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
sis-warning-fixes.patch
dmaengine-uninline-large-functions.patch
git-mips-fixup.patch
git-mtd.patch
onenand_base-warning-fix.patch
sc520cdp-warning-fix.patch
netsc520-warning-fix.patch
ck804xrom-warning-fix.patch
esb2rom-warning-fixes.patch
amd76xrom-warning-fix.patch
ichxrom-warning-fix.patch
jffs2-warning-fixes.patch
cafe-warning-fix.patch
git-netdev-all.patch
Fabric7-VIOC-driver-fixes.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
git-parisc.patch
git-pciseg.patch
git-s390.patch
git-scsi-misc.patch
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
linux-kernel-markers-kconfig-menus-fix-4.patch
fb-sm501-framebuffer-driver-5-fix.patch
git-gccbug-fixup.patch
