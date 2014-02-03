From: akpm@linux-foundation.org
Subject: +
 lib-kconfigdebug-clarify-config_debug_infos-bloaty-nature-fix.patch added
 to -mm tree
Date: Mon, 03 Feb 2014 14:58:21 -0800
Message-ID: <52f01f0d.eTPhpgRxvkqd2TXN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47159 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbaBCW6W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Feb 2014 17:58:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, bp@suse.de, akpm@linux-foundation.org

Subject: + lib-kconfigdebug-clarify-config_debug_infos-bloaty-nature-fix.patch added to -mm tree
To: akpm@linux-foundation.org,bp@suse.de,rientjes@google.com
From: akpm@linux-foundation.org
Date: Mon, 03 Feb 2014 14:58:21 -0800


The patch titled
     Subject: lib-kconfigdebug-clarify-config_debug_infos-bloaty-nature-fix
has been added to the -mm tree.  Its filename is
     lib-kconfigdebug-clarify-config_debug_infos-bloaty-nature-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-kconfigdebug-clarify-config_debug_infos-bloaty-nature-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-kconfigdebug-clarify-config_debug_infos-bloaty-nature-fix.patch

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
Subject: lib-kconfigdebug-clarify-config_debug_infos-bloaty-nature-fix

clarify text

Cc: Borislav Petkov <bp@suse.de>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN lib/Kconfig.debug~lib-kconfigdebug-clarify-config_debug_infos-bloaty-nature-fix lib/Kconfig.debug
--- a/lib/Kconfig.debug~lib-kconfigdebug-clarify-config_debug_infos-bloaty-nature-fix
+++ a/lib/Kconfig.debug
@@ -128,9 +128,9 @@ config DEBUG_INFO
 	  tools like crash, kgdb, LKCD, gdb, etc on the kernel.
 
 	  If you only want to have resolved symbols in kernel traces and
-	  are not going to need support for those tools above, you don't need
-	  to enable this as it is a huge bloat and build slowdown;
-	  enable CONFIG_KALLSYMS instead.
+	  are not going to need support for the above tools, you don't need
+	  to enable this.  It hugely bloat object files' on-disk sizes and slows
+	  the build.  Enable CONFIG_KALLSYMS instead.
 
 	  If unsure, say N.
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon.patch
numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly-fix.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
lib-kconfigdebug-clarify-config_debug_infos-bloaty-nature-fix.patch
linux-next.patch
linux-next-git-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

