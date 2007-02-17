From: akpm@linux-foundation.org
Subject: + pvrusb-warning-fix.patch added to -mm tree
Date: Sat, 17 Feb 2007 02:36:02 -0800
Message-ID: <200702171037.l1HAbKRj024878@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55281 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965142AbXBQKhe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 05:37:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mchehab@infradead.org


The patch titled
     pvrusb warning fix
has been added to the -mm tree.  Its filename is
     pvrusb-warning-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pvrusb warning fix
From: Andrew Morton <akpm@linux-foundation.org>

drivers/media/video/pvrusb2/pvrusb2-hdw.c: In function 'pvr2_upload_firmware2':
drivers/media/video/pvrusb2/pvrusb2-hdw.c:1269: warning: format '%u' expects type 'unsigned int', but argument 3 has type 'long unsigned int'

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/pvrusb2/pvrusb2-hdw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/pvrusb2/pvrusb2-hdw.c~pvrusb-warning-fix drivers/media/video/pvrusb2/pvrusb2-hdw.c
--- a/drivers/media/video/pvrusb2/pvrusb2-hdw.c~pvrusb-warning-fix
+++ a/drivers/media/video/pvrusb2/pvrusb2-hdw.c
@@ -1268,7 +1268,7 @@ int pvr2_upload_firmware2(struct pvr2_hd
 	if (fw_len % sizeof(u32)) {
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
 			   "size of %s firmware"
-			   " must be a multiple of %u bytes",
+			   " must be a multiple of %zu bytes",
 			   fw_files[fwidx],sizeof(u32));
 		release_firmware(fw_entry);
 		return -1;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
git-arm.patch
git-powerpc.patch
git-drm.patch
git-dvb.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
sis-warning-fixes.patch
dmaengine-uninline-large-functions.patch
git-mips-fixup.patch
git-mtd.patch
git-netdev-all.patch
e1000-fix-shared-interrupt-warning-message-fix.patch
Fabric7-VIOC-driver-fixes.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
git-s390.patch
git-scsi-misc.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
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
revert-x86_64-mm-putreg-check.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
fb-sm501-framebuffer-driver-5-fix.patch
git-gccbug-fixup.patch
pvrusb-warning-fix.patch
