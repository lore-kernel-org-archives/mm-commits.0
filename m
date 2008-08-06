From: akpm@linux-foundation.org
Subject: + m32r-export-empty_zero_page.patch added to -mm tree
Date: Wed, 06 Aug 2008 15:52:48 -0700
Message-ID: <200808062252.m76MqmW5019790@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44079 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754751AbYHFWxK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 18:53:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, takata@linux-m32r.org


The patch titled
     m32r: export empty_zero_page
has been added to the -mm tree.  Its filename is
     m32r-export-empty_zero_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m32r: export empty_zero_page
From: Adrian Bunk <bunk@kernel.org>

ERROR: "empty_zero_page" [fs/ext4/ext4dev.ko] undefined!

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/kernel/m32r_ksyms.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/m32r/kernel/m32r_ksyms.c~m32r-export-empty_zero_page arch/m32r/kernel/m32r_ksyms.c
--- a/arch/m32r/kernel/m32r_ksyms.c~m32r-export-empty_zero_page
+++ a/arch/m32r/kernel/m32r_ksyms.c
@@ -14,6 +14,7 @@
 #include <asm/delay.h>
 #include <asm/irq.h>
 #include <asm/tlbflush.h>
+#include <asm/pgtable.h>
 
 /* platform dependent support */
 EXPORT_SYMBOL(boot_cpu_data);
@@ -65,6 +66,7 @@ EXPORT_SYMBOL(memset);
 EXPORT_SYMBOL(copy_page);
 EXPORT_SYMBOL(clear_page);
 EXPORT_SYMBOL(strlen);
+EXPORT_SYMBOL(empty_zero_page);
 
 EXPORT_SYMBOL(_inb);
 EXPORT_SYMBOL(_inw);
_

Patches currently in -mm which might be from bunk@kernel.org are

feature-removal-scheduletxt-remove-the-ncr53c9x-entry.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
m32r-dont-offer-config_isa.patch
if-0-ses_match_host.patch
scsi-remove-the-unused-scsi_qlogic_fc_firmware-option.patch
git-block.patch
fs_mbcache-dont-needlessly-make-it-built-in.patch
git-xtensa.patch
uml-remove-the-dead-tty_log-code.patch
include-linux-kernelh-userspace-header-cleanup.patch
make-mm-rmapc-anon_vma_cachep-static.patch
drivers-firmware-iscsi_ibftc-make-3-functions-static.patch
reiser4.patch
fs-partitions-acornc-remove-dead-code.patch
the-overdue-eepro100-removal.patch
pnp-remove-printk-with-outdated-version.patch
telephony-remove-cvs-keywords.patch
reiserfs-procfsc-remove-cvs-keywords.patch
parport-remove-cvs-keywords.patch
quota-remove-cvs-keywords.patch
include-linux-mounth-remove-cvs-keyword.patch
kernel-dmac-remove-a-cvs-keyword.patch
asm-h8300-mdh-remove-cvs-keyword.patch
alpha-miata-remove-dead-url.patch
maintainers-remove-zf-machz-watchdog-entry.patch
maintainers-remove-hga-framebuffer-driver-entry.patch
ntfs-update-homepage.patch
drivers-scsi-a2091c-make-2-functions-static.patch
drivers-scsi-a3000c-make-2-functions-static.patch
m32r-export-empty_zero_page.patch
m32r-export-__ndelay.patch
m32r-kernel-cleanups.patch
binfmt_somc-add-module_license.patch
parisc-lib-make-code-static.patch
drivers-parisc-make-code-static.patch
make-probe_serial_gsc-static.patch
make-ptrace_untrace-static.patch
the-scheduled-serial_coldfire-removal.patch

