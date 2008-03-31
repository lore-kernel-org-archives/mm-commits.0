From: akpm@linux-foundation.org
Subject: - sound-oss-ac97_codecc-restore-module_license.patch removed from -mm tree
Date: Mon, 31 Mar 2008 13:18:21 -0700
Message-ID: <200803312018.m2VKILSS024051@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754632AbYCaU2h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 16:28:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, devzero@web.de, mm-commits@vger.kernel.org


The patch titled
     sound/oss/ac97_codec.c: restore MODULE_LICENSE
has been removed from the -mm tree.  Its filename was
     sound-oss-ac97_codecc-restore-module_license.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sound/oss/ac97_codec.c: restore MODULE_LICENSE
From: Adrian Bunk <bunk@kernel.org>

I accidentally removed the MODULE_LICENSE("GPL") from sound/oss/ac97_codec.c

Reported-by: Roland <devzero@web.de>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/oss/ac97_codec.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN sound/oss/ac97_codec.c~sound-oss-ac97_codecc-restore-module_license sound/oss/ac97_codec.c
--- a/sound/oss/ac97_codec.c~sound-oss-ac97_codecc-restore-module_license
+++ a/sound/oss/ac97_codec.c
@@ -1202,3 +1202,5 @@ static int pt101_init(struct ac97_codec 
 
 EXPORT_SYMBOL(ac97_probe_codec);
 
+MODULE_LICENSE("GPL");
+
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-dvb.patch
git-gfs2-nmw.patch
git-dlm.patch
git-hid.patch
mtdoopsc-make-struct-oops_cxt-static-again.patch
make-mtd-nand-cs553x_nandcpart_probes-static.patch
git-udf.patch
git-net.patch
git-nfsd.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-selinux.patch
pci_alloc_child_bus-mustnt-be-__devinit.patch
pci_scan_device-mustnt-be-__devinit.patch
pci_bus_size_cardbus-mustnt-be-__devinit.patch
pci_setup_bridge-mustnt-be-__devinit.patch
scsi-aic94xx-cleanups.patch
if-0-ses_match_host.patch
git-watchdog.patch
make-swap_pte_to_pagemap_entry-static.patch
fs-ramfs-extern-cleanup.patch
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
proper-__do_softirq-prototype.patch
proper-extern-for-late_time_init.patch
remove-ecryptfs_header_cache_0.patch
make-ds1511_rtc_readset_time-static.patch
pnp-skip-dev-protocol-null-checks.patch
make-ext3_xattr_list-static.patch
make-cgroup_enable_task_cg_lists-static.patch
cgroups-kernel-ns_cgroupc-should-include-linux-nsproxyh.patch
kernel-cpusetc-make-3-functions-static.patch
include-linux-sysctlh-remove-empty-else.patch
remove-aoedev_isbusy.patch
make-marker_debug-static.patch
reiser4.patch

