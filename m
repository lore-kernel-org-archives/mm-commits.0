From: akpm@linux-foundation.org
Subject: - maintainers-remove-zf-machz-watchdog-entry.patch removed from -mm tree
Date: Tue, 12 Aug 2008 13:34:13 -0700
Message-ID: <200808122034.m7CKYD1r011933@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45113 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751306AbYHLUew (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 16:34:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: remove ZF MACHZ WATCHDOG entry
has been removed from the -mm tree.  Its filename was
     maintainers-remove-zf-machz-watchdog-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: remove ZF MACHZ WATCHDOG entry
From: Adrian Bunk <bunk@kernel.org>

- maintainer has not been active for years
- maintainer email bounces
- URL no longer exists
- covered by the WATCHDOG DEVICE DRIVERS entry

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ------
 1 file changed, 6 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-zf-machz-watchdog-entry MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-zf-machz-watchdog-entry
+++ a/MAINTAINERS
@@ -4703,12 +4703,6 @@ L:	linux-wireless@vger.kernel.org
 L:	zd1211-devs@lists.sourceforge.net (subscribers-only)
 S:	Maintained
 
-ZF MACHZ WATCHDOG
-P:	Fernando Fuganti
-M:	fuganti@netbank.com.br
-W:	http://cvs.conectiva.com.br/drivers/ZFL-watchdog/
-S:	Maintained
-
 ZR36067 VIDEO FOR LINUX DRIVER
 P:	Ronald Bultje
 M:	rbultje@ronald.bitfreak.net
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
feature-removal-scheduletxt-remove-the-ncr53c9x-entry.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
m32r-dont-offer-config_isa.patch
m32r-export-empty_zero_page.patch
m32r-export-__ndelay.patch
m32r-kernel-cleanups.patch
the-overdue-eepro100-removal.patch
ntfs-update-homepage.patch
parisc-lib-make-code-static.patch
drivers-parisc-make-code-static.patch
if-0-ses_match_host.patch
scsi-remove-the-unused-scsi_qlogic_fc_firmware-option.patch
drivers-scsi-a2091c-make-2-functions-static.patch
drivers-scsi-a3000c-make-2-functions-static.patch
fs_mbcache-dont-needlessly-make-it-built-in.patch
git-xtensa.patch
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
drivers-firmware-iscsi_ibftc-make-3-functions-static.patch
ipc-semc-make-free_un-static.patch
acpi-use-bcd2bin-bin2bcd.patch
alpha-use-bcd2bin-bin2bcd.patch
arm-use-bcd2bin-bin2bcd.patch
cris-use-bcd2bin-bin2bcd.patch
drivers-rtc-use-bcd2bin-bin2bcd.patch
rtc-use-bcd2bin-bin2bcd.patch
ia64-use-bcd2bin-bin2bcd.patch
ide-cd-use-bcd2bin-bin2bcd.patch
mips-use-bcd2bin-bin2bcd.patch
mn10300-use-bcd2bin-bin2bcd.patch
powerpc-use-bcd2bin-bin2bcd.patch
i2c-use-bcd2bin-bin2bcd.patch
drivers-scsi-sr_vendorc-use-bcd2bin.patch
sparc64-use-bcd2bin-bin2bcd.patch
remove-the-obsolete-bcdbin-binbcd-macros.patch
include-linux-bcdh-remove-comments.patch
reiser4.patch

