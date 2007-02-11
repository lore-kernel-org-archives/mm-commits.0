From: akpm@linux-foundation.org
Subject: - remove-final-reference-to-superfluous-smp_commence.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:54:48 -0800
Message-ID: <200702112254.l1BMsme8016269@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60541 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932838AbXBKWzC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:55:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, mingo@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Remove final reference to superfluous smp_commence()
has been removed from the -mm tree.  Its filename was
     remove-final-reference-to-superfluous-smp_commence.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove final reference to superfluous smp_commence()
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove the last (and commented out) invocation of the obsolete
smp_commence() call.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Acked-by: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN init/main.c~remove-final-reference-to-superfluous-smp_commence init/main.c
--- a/init/main.c~remove-final-reference-to-superfluous-smp_commence
+++ a/init/main.c
@@ -395,11 +395,6 @@ static void __init smp_init(void)
 	/* Any cleanup work */
 	printk(KERN_INFO "Brought up %ld CPUs\n", (long)num_online_cpus());
 	smp_cpus_done(max_cpus);
-#if 0
-	/* Get other processors into their bootup holding patterns. */
-
-	smp_commence();
-#endif
 }
 
 #endif
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-avr32.patch
git-dvb.patch
kbuild-remove-references-to-deprecated-prepare-all-target.patch
git-mips.patch
git-netdev-all.patch
remove-useless-find_first_bit-macro-from-cardbusc.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
fix-misspelled-usbnet_mii-kernel-config-option.patch
fix-apparent-typo-config_usb_cdcether.patch
ntfs-rename-incorrect-check-of-ntfs_debug-with-just-debug.patch
quota-have-linux-quotah-include-linux-rwsemh-explicitly.patch
isdn-fix-typo-config_hisax_quadro-config_hisax_sct_quadro.patch
isdn-rename-some-debugging-macros-to-not-resemble-config.patch
isdn-rename-debug-option-config_serial_nopause_io.patch
isdn-remove-defunct-test-emulator.patch
isdn-rename-special-macro-config_hisax_hfc4s8s_pcimem.patch
correct-apparent-typo-config_aty_ct-in-aty-video.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
