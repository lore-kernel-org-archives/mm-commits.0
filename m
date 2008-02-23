From: akpm@linux-foundation.org
Subject: - ocfs-make-dlm_do_assert_master-static.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:22:29 -0800
Message-ID: <200802232022.m1NKMTOs013428@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:60022 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762006AbYBWU3B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:29:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mark.fasheh@oracle.com, mm-commits@vger.kernel.org


The patch titled
     ocfs: make dlm_do_assert_master() static
has been removed from the -mm tree.  Its filename was
     ocfs-make-dlm_do_assert_master-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ocfs: make dlm_do_assert_master() static
From: Adrian Bunk <bunk@kernel.org>

Make the needlessly global dlm_do_assert_master() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Mark Fasheh <mark.fasheh@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs-make-dlm_do_assert_master-static fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs-make-dlm_do_assert_master-static
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -1695,9 +1695,9 @@ send_response:
  * can periodically run all locks owned by this node
  * and re-assert across the cluster...
  */
-int dlm_do_assert_master(struct dlm_ctxt *dlm,
-			 struct dlm_lock_resource *res,
-			 void *nodemap, u32 flags)
+static int dlm_do_assert_master(struct dlm_ctxt *dlm,
+				struct dlm_lock_resource *res,
+				void *nodemap, u32 flags)
 {
 	struct dlm_assert_master assert;
 	int to, tmpret;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
sparc-fix-build.patch
git-acpi.patch
git-dvb.patch
git-gfs2-nmw.patch
mtdoopsc-make-struct-oops_cxt-static-again.patch
make-mtd-nand-cs553x_nandcpart_probes-static.patch
git-net.patch
make-s2iocinit_tti-static.patch
git-nfsd.patch
git-ocfs2.patch
pci_alloc_child_bus-mustnt-be-__devinit.patch
pci_scan_device-mustnt-be-__devinit.patch
pci_bus_size_cardbus-mustnt-be-__devinit.patch
pci_setup_bridge-mustnt-be-__devinit.patch
git-scsi-rc-fixes.patch
scsi-aic94xx-cleanups.patch
if-0-ses_match_host.patch
remove-ps2esdi.patch
make-b43_mac_enablesuspend-static.patch
the-scheduled-bcm43xx-removal.patch
the-scheduled-ieee80211-softmac-removal.patch
the-scheduled-rc80211-simplec-removal.patch
ieee80211-fix-broken-error-handling-in-ieee80211_sta_process_addba_request.patch
make-swap_pte_to_pagemap_entry-static.patch
fs-ramfs-extern-cleanup.patch
make-udf_error-static.patch
fs-hfsplus-proper-externs.patch
fs-freevxfs-proper-externs.patch
make-__put_super-static.patch
make-vfs_ioctl-static.patch
fs-fs-writeback-make-2-functions-static.patch
fs-drop_cachesc-make-2-functions-static.patch
fs-aioc-make-3-functions-static.patch
let-log_buf_shift-default-to-17.patch
fs-timerfdc-should-include-linux-syscallsh.patch
remove-generic_commit_write.patch
make-fs-bufferccont_expand_zero-static.patch
make-binfmt_flat-a-bool.patch
remove-mca_is_adapter_used.patch
ipwireless-remove-dead-code.patch
remove-ecryptfs_header_cache_0.patch
make-ds1511_rtc_readset_time-static.patch
pnp-skip-dev-protocol-null-checks.patch
make-ext3_xattr_list-static.patch
make-cgroup_enable_task_cg_lists-static.patch
kernel-cpusetc-make-3-functions-static.patch
make-ext4_xattr_list-static.patch
include-linux-sysctlh-remove-empty-else.patch
remove-aoedev_isbusy.patch
make-marker_debug-static.patch
reiser4.patch
