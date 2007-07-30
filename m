From: akpm@linux-foundation.org
Subject: + mtd-onenand_simc-make-struct-info-static.patch added to -mm tree
Date: Mon, 30 Jul 2007 15:21:19 -0700
Message-ID: <200707302221.l6UMLJ9e001099@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49178 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932801AbXG3WVn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 18:21:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, dwmw2@infradead.org


The patch titled
     MTD onenand_sim.c: make struct info static
has been added to the -mm tree.  Its filename is
     mtd-onenand_simc-make-struct-info-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: MTD onenand_sim.c: make struct info static
From: Adrian Bunk <bunk@stusta.de>

On Wed, Jul 25, 2007 at 04:03:04AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.22-rc6-mm1:
>...
>  git-mtd.patch
>...
>  git trees
>...

This patch makes the needlessly global struct info static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/onenand/onenand_sim.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mtd/onenand/onenand_sim.c~mtd-onenand_simc-make-struct-info-static drivers/mtd/onenand/onenand_sim.c
--- a/drivers/mtd/onenand/onenand_sim.c~mtd-onenand_simc-make-struct-info-static
+++ a/drivers/mtd/onenand/onenand_sim.c
@@ -78,7 +78,7 @@ struct onenand_info {
 	struct onenand_flash	flash;
 };
 
-struct onenand_info *info;
+static struct onenand_info *info;
 
 #define DPRINTK(format, args...)					\
 do {									\
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
drivers-acpi-sbsc-remove-dead-code.patch
make-drivers-acpi-eventcacpi_event_seqnum-static.patch
make-struct-sony_nc_ids-static.patch
git-alsa.patch
kernel-auditscc-fix-an-off-by-one.patch
drivers-base-power-make-2-functions-static.patch
git-drm.patch
git-dvb.patch
drivers-i2c-i2c-corec-make-code-static.patch
git-hwmon.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mmc.patch
git-mtd.patch
mtd-onenand_simc-make-struct-info-static.patch
drivers-net-cxgb3-xgmacc-remove-dead-code.patch
fore200e_param_bs_queue-must-be-__devinit.patch
make-pktgencget_ipsec_sa-static-and-non-inline.patch
make-nf_ct_ipv6_skip_exthdr-static.patch
net-unix-af_unixc-make-code-static.patch
backlight-make-2-structs-static.patch
git-ocfs2.patch
cpqphp_ctrlc-remove-dead-code.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
nsp32_restart_autoscsi-remove-error-check.patch
git-unionfs.patch
drivers-usb-serial-sierrac-make-3-functions-static.patch
git-v9fs.patch
git-ipwireless_cs.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
i386-remove-maccumulate-outgoing-args.patch
arch-i386-mach-generic-probec-make-struct-apic_probe.patch
arch-i386-mach-es7000-es7000platc-cleanups.patch
i386-alternativec-really-stop-mces-during-code.patch
serial-sh-sci-fix-build-failure-from-kgdb-fallout.patch
usb_serial_suspend-buggy-code.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
mm-page_allocc-make-code-static.patch
maps2-add-proc-kpagemap-interface.patch
hugetlbfs-read-support-fix-2.patch
unexport-pm_power_off_prepare.patch
fs-reiserfs-cleanups.patch
anon_inodes-shouldnt-be-user-visible.patch
remove-unsafe-from-module-struct.patch
kernel-rtmutex-debugc-cleanups.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
fs-nfsd-exportc-make-3-functions-static.patch
radeon_driver_vblank_do_wait-static.patch
unexport-fb_prepare_logo.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
e1000-if-0-two-functions.patch
make-scsi_host_link_pm_policy-static.patch
usb-make-dev_attr_authorized_default-static.patch
kernel-printkc-make-2-variables-static.patch
export-v4l2_int_device_unregister.patch
kernel-pidc-remove-unused-exports.patch
security-cleanups.patch
