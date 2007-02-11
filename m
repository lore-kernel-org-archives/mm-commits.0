From: akpm@linux-foundation.org
Subject: - remove-references-to-obsolete-kernel-config-option-debug_rwsems.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:54:59 -0800
Message-ID: <200702112254.l1BMsxEe016284@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60569 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932849AbXBKWzP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:55:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, dhowells@redhat.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Remove references to obsolete kernel config option DEBUG_RWSEMS
has been removed from the -mm tree.  Its filename was
     remove-references-to-obsolete-kernel-config-option-debug_rwsems.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove references to obsolete kernel config option DEBUG_RWSEMS
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove the few references to the obsolete kernel config option
DEBUG_RWSEMS.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN lib/Kconfig.debug~remove-references-to-obsolete-kernel-config-option-debug_rwsems lib/Kconfig.debug
--- a/lib/Kconfig.debug~remove-references-to-obsolete-kernel-config-option-debug_rwsems
+++ a/lib/Kconfig.debug
@@ -181,19 +181,11 @@ config DEBUG_MUTEXES
 	 This feature allows mutex semantics violations to be detected and
 	 reported.
 
-config DEBUG_RWSEMS
-	bool "RW-sem debugging: basic checks"
-	depends on DEBUG_KERNEL
-	help
-	 This feature allows read-write semaphore semantics violations to
-	 be detected and reported.
-
 config DEBUG_LOCK_ALLOC
 	bool "Lock debugging: detect incorrect freeing of live locks"
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
 	select DEBUG_SPINLOCK
 	select DEBUG_MUTEXES
-	select DEBUG_RWSEMS
 	select LOCKDEP
 	help
 	 This feature will check whether any held lock (spinlock, rwlock,
@@ -209,7 +201,6 @@ config PROVE_LOCKING
 	select LOCKDEP
 	select DEBUG_SPINLOCK
 	select DEBUG_MUTEXES
-	select DEBUG_RWSEMS
 	select DEBUG_LOCK_ALLOC
 	default n
 	help
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
