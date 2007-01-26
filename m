From: akpm@osdl.org
Subject: - process-include-linux-if_addrlinkh-with-unifdef.patch removed from -mm tree
Date: Thu, 25 Jan 2007 23:52:25 -0800
Message-ID: <200701260752.l0Q7qPuq010841@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50645 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030796AbXAZHzk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 02:55:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     process include/linux/if_{addr,link}.h with unifdef
has been removed from the -mm tree.  Its filename was
     process-include-linux-if_addrlinkh-with-unifdef.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: process include/linux/if_{addr,link}.h with unifdef
From: Adrian Bunk <bunk@stusta.de>

After commit d3dcc077bf88806201093f86325ec656e4dbfbce,
include/linux/if_{addr,link}.h should be processed with unifdef.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/Kbuild |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/Kbuild~process-include-linux-if_addrlinkh-with-unifdef include/linux/Kbuild
--- a/include/linux/Kbuild~process-include-linux-if_addrlinkh-with-unifdef
+++ a/include/linux/Kbuild
@@ -70,7 +70,6 @@ header-y += hysdn_if.h
 header-y += i2c-dev.h
 header-y += i8k.h
 header-y += icmp.h
-header-y += if_addr.h
 header-y += if_arcnet.h
 header-y += if_arp.h
 header-y += if_bonding.h
@@ -80,7 +79,6 @@ header-y += if_fddi.h
 header-y += if.h
 header-y += if_hippi.h
 header-y += if_infiniband.h
-header-y += if_link.h
 header-y += if_packet.h
 header-y += if_plip.h
 header-y += if_ppp.h
@@ -213,6 +211,7 @@ unifdef-y += hpet.h
 unifdef-y += i2c.h
 unifdef-y += i2o-dev.h
 unifdef-y += icmpv6.h
+unifdef-y += if_addr.h
 unifdef-y += if_bridge.h
 unifdef-y += if_ec.h
 unifdef-y += if_eql.h
@@ -220,6 +219,7 @@ unifdef-y += if_ether.h
 unifdef-y += if_fddi.h
 unifdef-y += if_frad.h
 unifdef-y += if_ltalk.h
+unifdef-y += if_link.h
 unifdef-y += if_pppox.h
 unifdef-y += if_shaper.h
 unifdef-y += if_tr.h
_

Patches currently in -mm which might be from bunk@stusta.de are

knfsd-replace-some-warning-ins-nfsfhh-with-bug_on-or-warn_on.patch
git-acpi.patch
git-alsa.patch
cpu_freq_table-shouldnt-be-a-def_tristate.patch
git-powerpc.patch
drivers-char-drm-drm_mmc-remove-unused-exports.patch
git-dvb.patch
drivers-media-dvb-frontends-make-4-functions-static.patch
git-gfs2-nmw.patch
ia64-add-pci_get_legacy_ide_irq.patch
git-ieee1394.patch
git-libata-all.patch
mips-remove-smp_tune_scheduling.patch
git-mmc.patch
mtd_ck804xrom-must-depend-on-pci.patch
git-ubi.patch
git-netdev-all.patch
remove-one-remaining-define-bcm_tso-1.patch
net-irda-proper-prototypes.patch
net-wanrouter-wanmainc-cleanups.patch
net-uninline-skb_put-fix.patch
git-ocfs2.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
usb_rtl8150-must-select-mii.patch
x86_64-re-add-a-newline-to-restore_context.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
lumpy-reclaim-cleanup.patch
remove-include-linux-byteorder-pdp_endianh.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
drivers-char-vc_screenc-proper-prototypes.patch
add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix.patch
schedule-obsolete-oss-drivers-for-removal-3rd-round.patch
cleanup-linux-byteorder-swabbh.patch
cleanup-include-linux-xattrh.patch
cleanup-include-linux-reiserfs_xattrh.patch
remove-dead-kernel-config-option-aedsp16_mpu401.patch
gtod-persistent-clock-support.patch
i386-use-gtod-persistent-clock-support.patch
extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
clockevents-i383-drivers.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
drivers-isdn-pcbit-proper-prototypes.patch
drivers-isdn-hisax-proper-prototypes.patch
drivers-isdn-sc-proper-prototypes.patch
include-linux-nfsd-consth-remove-nfs_super_magic.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
fbdev-driver-for-s3-trio-virge-cleanups.patch
remove-broken-video-drivers-v4.patch
remove-bogus-con_is_present-prototypes.patch
proper-prototype-for-tosh_smm.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
