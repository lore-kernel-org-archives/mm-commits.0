From: akpm@linux-foundation.org
Subject: - make-ipc-utilcsysvipc_find_ipc-static.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:21:17 -0800
Message-ID: <200802070020.m170Kwdl006209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34520 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765970AbYBGApY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:45:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, Nadia.Derbey@bull.net, mm-commits@vger.kernel.org


The patch titled
     make ipc/util.c:sysvipc_find_ipc() static
has been removed from the -mm tree.  Its filename was
     make-ipc-utilcsysvipc_find_ipc-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: make ipc/util.c:sysvipc_find_ipc() static
From: Adrian Bunk <bunk@kernel.org>

sysvipc_find_ipc() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Nadia Derbey <Nadia.Derbey@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN ipc/util.c~make-ipc-utilcsysvipc_find_ipc-static ipc/util.c
--- a/ipc/util.c~make-ipc-utilcsysvipc_find_ipc-static
+++ a/ipc/util.c
@@ -802,8 +802,8 @@ struct ipc_proc_iter {
 /*
  * This routine locks the ipc structure found at least at position pos.
  */
-struct kern_ipc_perm *sysvipc_find_ipc(struct ipc_ids *ids, loff_t pos,
-					loff_t *new_pos)
+static struct kern_ipc_perm *sysvipc_find_ipc(struct ipc_ids *ids, loff_t pos,
+					      loff_t *new_pos)
 {
 	struct kern_ipc_perm *ipc;
 	int total, id;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-acpi.patch
powerpc-vdso_do_func_patch3264-must-be-__init.patch
powerpc-free_property-mustnt-be-__init.patch
hvc_rtas_init-must-be-__init.patch
git-dvb.patch
git-gfs2-nmw.patch
git-mtd.patch
git-ocfs2.patch
if-0-pci_cleanup_aer_correct_error_status.patch
git-scsi-misc.patch
scsi-aic94xx-cleanups.patch
scsi-qlogicptic-section-fixes.patch
usb-make-usb_storage_onetouch-available-with-pm.patch
make-b43_mac_enablesuspend-static.patch
git-xtensa.patch
move-edactxt-two-levels-up.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
kill-udffs_dateversion.patch
the-scheduled-time-option-removal.patch
reiser4.patch
