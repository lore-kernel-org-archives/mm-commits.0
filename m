From: akpm@linux-foundation.org
Subject: + sys_sysfs-add-config_sysfs_syscall-fix.patch added to -mm tree
Date: Thu, 13 Feb 2014 14:22:15 -0800
Message-ID: <52fd4597.I9erDiUEQfo0rU7x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36764 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaBMWWQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Feb 2014 17:22:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rdunlap@infradead.org, fabf@skynet.be, akpm@linux-foundation.org

Subject: + sys_sysfs-add-config_sysfs_syscall-fix.patch added to -mm tree
To: akpm@linux-foundation.org,fabf@skynet.be,rdunlap@infradead.org
From: akpm@linux-foundation.org
Date: Thu, 13 Feb 2014 14:22:15 -0800


The patch titled
     Subject: sys_sysfs-add-config_sysfs_syscall-fix
has been added to the -mm tree.  Its filename is
     sys_sysfs-add-config_sysfs_syscall-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sys_sysfs-add-config_sysfs_syscall-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sys_sysfs-add-config_sysfs_syscall-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: sys_sysfs-add-config_sysfs_syscall-fix

tweak Kconfig help text

Cc: Fabian Frederick <fabf@skynet.be>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN init/Kconfig~sys_sysfs-add-config_sysfs_syscall-fix init/Kconfig
--- a/init/Kconfig~sys_sysfs-add-config_sysfs_syscall-fix
+++ a/init/Kconfig
@@ -1294,9 +1294,9 @@ config SYSFS_SYSCALL
 	bool "Sysfs syscall support" if EXPERT
 	default y
 	---help---
-	  sys_sysfs is an obsolete system call no longer supported in
-	  libc.Note that disabling this option while being more secure breaks
-	  compatibility with other systems.
+	  sys_sysfs is an obsolete system call no longer supported in libc.
+	  Note that disabling this option is more secure but might break
+	  compatibility with some systems.
 
 	  If unsure say Y here.
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
jffs2-avoid-soft-lockup-in-jffs2_reserve_space_gc.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
drop_caches-add-some-documentation-and-info-message.patch
include-linux-syscallsh-add-sys32_quotactl-prototype-fix.patch
sys_sysfs-add-config_sysfs_syscall-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-spi-spic-fix-max-warning.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

