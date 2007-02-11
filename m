From: akpm@linux-foundation.org
Subject: - fix-apparent-typo-config_lockdep_debug.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:55:16 -0800
Message-ID: <200702112255.l1BMtG2f016305@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60607 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932872AbXBKWzg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:55:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Fix apparent typo CONFIG_LOCKDEP_DEBUG
has been removed from the -mm tree.  Its filename was
     fix-apparent-typo-config_lockdep_debug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix apparent typo CONFIG_LOCKDEP_DEBUG
From: "Robert P. J. Day" <rpjday@mindspring.com>

Replace the apparent typo CONFIG_LOCKDEP_DEBUG with the correct
CONFIG_DEBUG_LOCKDEP.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/lockdep_proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/lockdep_proc.c~fix-apparent-typo-config_lockdep_debug kernel/lockdep_proc.c
--- a/kernel/lockdep_proc.c~fix-apparent-typo-config_lockdep_debug
+++ a/kernel/lockdep_proc.c
@@ -244,7 +244,7 @@ static int lockdep_stats_show(struct seq
 
 		sum_forward_deps += count_forward_deps(class);
 	}
-#ifdef CONFIG_LOCKDEP_DEBUG
+#ifdef CONFIG_DEBUG_LOCKDEP
 	DEBUG_LOCKS_WARN_ON(debug_atomic_read(&nr_unused_locks) != nr_unused);
 #endif
 	seq_printf(m, " lock-classes:                  %11lu [max: %lu]\n",
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
