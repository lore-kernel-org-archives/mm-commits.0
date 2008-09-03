From: akpm@linux-foundation.org
Subject: - ntfs-update-homepage.patch removed from -mm tree
Date: Wed, 03 Sep 2008 09:10:57 -0700
Message-ID: <200809031610.m83GAvUH023666@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38227 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751835AbYICQMJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2008 12:12:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     NTFS: update homepage
has been removed from the -mm tree.  Its filename was
     ntfs-update-homepage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: NTFS: update homepage
From: Adrian Bunk <bunk@kernel.org>

Update the location of the NTFS homepage in several files.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/ntfs.txt |    4 ++--
 MAINTAINERS                        |    2 +-
 fs/ntfs/usnjrnl.h                  |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff -puN Documentation/filesystems/ntfs.txt~ntfs-update-homepage Documentation/filesystems/ntfs.txt
--- a/Documentation/filesystems/ntfs.txt~ntfs-update-homepage
+++ a/Documentation/filesystems/ntfs.txt
@@ -40,7 +40,7 @@ Web site
 ========
 
 There is plenty of additional information on the linux-ntfs web site
-at http://linux-ntfs.sourceforge.net/
+at http://www.linux-ntfs.org/
 
 The web site has a lot of additional information, such as a comprehensive
 FAQ, documentation on the NTFS on-disk format, information on the Linux-NTFS
@@ -272,7 +272,7 @@ And you would know that /dev/hda2 has a 
 For Win2k and later dynamic disks, you can for example use the ldminfo utility
 which is part of the Linux LDM tools (the latest version at the time of
 writing is linux-ldm-0.0.8.tar.bz2).  You can download it from:
-	http://linux-ntfs.sourceforge.net/downloads.html
+	http://www.linux-ntfs.org/
 Simply extract the downloaded archive (tar xvjf linux-ldm-0.0.8.tar.bz2), go
 into it (cd linux-ldm-0.0.8) and change to the test directory (cd test).  You
 will find the precompiled (i386) ldminfo utility there.  NOTE: You will not be
diff -puN MAINTAINERS~ntfs-update-homepage MAINTAINERS
--- a/MAINTAINERS~ntfs-update-homepage
+++ a/MAINTAINERS
@@ -3051,7 +3051,7 @@ P:	Anton Altaparmakov
 M:	aia21@cantab.net
 L:	linux-ntfs-dev@lists.sourceforge.net
 L:	linux-kernel@vger.kernel.org
-W:	http://linux-ntfs.sf.net/
+W:	http://www.linux-ntfs.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/aia21/ntfs-2.6.git
 S:	Maintained
 
diff -puN fs/ntfs/usnjrnl.h~ntfs-update-homepage fs/ntfs/usnjrnl.h
--- a/fs/ntfs/usnjrnl.h~ntfs-update-homepage
+++ a/fs/ntfs/usnjrnl.h
@@ -113,7 +113,7 @@ typedef struct {
  * Reason flags (32-bit).  Cumulative flags describing the change(s) to the
  * file since it was last opened.  I think the names speak for themselves but
  * if you disagree check out the descriptions in the Linux NTFS project NTFS
- * documentation: http://linux-ntfs.sourceforge.net/ntfs/files/usnjrnl.html
+ * documentation: http://www.linux-ntfs.org/
  */
 enum {
 	USN_REASON_DATA_OVERWRITE	= const_cpu_to_le32(0x00000001),
@@ -145,7 +145,7 @@ typedef le32 USN_REASON_FLAGS;
  * Source info flags (32-bit).  Information about the source of the change(s)
  * to the file.  For detailed descriptions of what these mean, see the Linux
  * NTFS project NTFS documentation:
- *	http://linux-ntfs.sourceforge.net/ntfs/files/usnjrnl.html
+ *	http://www.linux-ntfs.org/
  */
 enum {
 	USN_SOURCE_DATA_MANAGEMENT	  = const_cpu_to_le32(0x00000001),
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
m32r-dont-offer-config_isa.patch
m32r-export-empty_zero_page.patch
m32r-export-__ndelay.patch
m32r-kernel-cleanups.patch
the-overdue-eepro100-removal.patch
parisc-lib-make-code-static.patch
drivers-parisc-make-code-static.patch
if-0-ses_match_host.patch
scsi-remove-the-unused-scsi_qlogic_fc_firmware-option.patch
drivers-scsi-a2091c-make-2-functions-static.patch
drivers-scsi-a3000c-make-2-functions-static.patch
fs_mbcache-dont-needlessly-make-it-built-in.patch
git-xtensa.patch
misdn-dsp_cmxc-fix-size-checks.patch
fix-pciehp_free_irq.patch
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

