From: akpm@linux-foundation.org
Subject: - scsi-remove-the-unused-scsi_qlogic_fc_firmware-option.patch removed from -mm tree
Date: Fri, 03 Oct 2008 14:29:04 -0700
Message-ID: <200810032129.m93LT439016662@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40963 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753255AbYJCV3R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Oct 2008 17:29:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, James.Bottomley@HansenPartnership.com, rpjday@crashcourse.ca, mm-commits@vger.kernel.org


The patch titled
     scsi: remove the unused SCSI_QLOGIC_FC_FIRMWARE option
has been removed from the -mm tree.  Its filename was
     scsi-remove-the-unused-scsi_qlogic_fc_firmware-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi: remove the unused SCSI_QLOGIC_FC_FIRMWARE option
From: Adrian Bunk <bunk@kernel.org>

This option was forgotten when the SCSI_QLOGIC_FC driver was removed.

Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/Kconfig |    8 --------
 1 file changed, 8 deletions(-)

diff -puN drivers/scsi/Kconfig~scsi-remove-the-unused-scsi_qlogic_fc_firmware-option drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig~scsi-remove-the-unused-scsi_qlogic_fc_firmware-option
+++ a/drivers/scsi/Kconfig
@@ -1336,14 +1336,6 @@ config SCSI_QLOGIC_FAS
 	  To compile this driver as a module, choose M here: the
 	  module will be called qlogicfas.
 
-config SCSI_QLOGIC_FC_FIRMWARE
-	bool "Include loadable firmware in driver"
-	depends on SCSI_QLOGIC_FC
-  	help
-	  Say Y to include ISP2X00 Fabric Initiator/Target Firmware, with
-	  expanded LUN addressing and FcTape (FCP-2) support, in the
-	  qlogicfc driver. This is required on some platforms.
-
 config SCSI_QLOGIC_1280
 	tristate "Qlogic QLA 1240/1x80/1x160 SCSI support"
 	depends on PCI && SCSI
_

Patches currently in -mm which might be from bunk@kernel.org are

git-powerpc.patch
git-sparc.patch
git-x86.patch
git-xtensa.patch
git-v4l-dvb.patch
git-scsi.patch
git-net.patch
git-crypto.patch
git-drm.patch
git-security-testing.patch
the-overdue-eepro100-removal.patch
parisc-lib-make-code-static.patch
drivers-parisc-make-code-static.patch
if-0-ses_match_host.patch
drivers-scsi-a2091c-make-2-functions-static.patch
drivers-scsi-a3000c-make-2-functions-static.patch
fs_mbcache-dont-needlessly-make-it-built-in.patch
misdn-dsp_cmxc-fix-size-checks.patch
asm-h8300-mdh-remove-cvs-keyword.patch
alpha-miata-remove-dead-url.patch
uml-remove-the-dead-tty_log-code.patch
include-linux-kernelh-userspace-header-cleanup.patch
maintainers-remove-hga-framebuffer-driver-entry.patch
include-linux-mounth-remove-cvs-keyword.patch
kernel-dmac-remove-a-cvs-keyword.patch
binfmt_somc-add-module_license.patch
make-probe_serial_gsc-static.patch
pnp-remove-printk-with-outdated-version.patch
telephony-remove-cvs-keywords.patch
reiserfs-procfsc-remove-cvs-keywords.patch
quota-remove-cvs-keywords.patch
make-ptrace_untrace-static.patch
fs-partitions-acornc-remove-dead-code.patch
parport-remove-cvs-keywords.patch
make-mm-rmapc-anon_vma_cachep-static.patch
ipc-semc-make-free_un-static.patch
make-fs-proc-proc_sysctlc-grab_header-static.patch
make-hp_wmi_notify-static.patch
make-kprobesc-kretprobe_table_lock-static.patch
acpi-use-bcd2bin-bin2bcd.patch
alpha-use-bcd2bin-bin2bcd.patch
cris-use-bcd2bin-bin2bcd.patch
drivers-rtc-use-bcd2bin-bin2bcd.patch
rtc-use-bcd2bin-bin2bcd.patch
mips-use-bcd2bin-bin2bcd.patch
mn10300-use-bcd2bin-bin2bcd.patch
i2c-use-bcd2bin-bin2bcd.patch
drivers-scsi-sr_vendorc-use-bcd2bin.patch
remove-the-obsolete-bcdbin-binbcd-macros.patch
include-linux-bcdh-remove-comments.patch
reiser4.patch

