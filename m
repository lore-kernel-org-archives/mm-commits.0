From: akpm@linux-foundation.org
Subject: [merged] nommu-make-config_unevictable_lru-available-when-config_mmu=n.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:38:50 -0700
Message-ID: <200904011838.n31IcovV008419@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58444 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933697AbZDAT3f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:29:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, Enrik.Berkhan@ge.com, a.p.zijlstra@chello.nl, gerg@snapgear.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, riel@redhat.com, mm-


The patch titled
     nommu: make CONFIG_UNEVICTABLE_LRU available when CONFIG_MMU=n
has been removed from the -mm tree.  Its filename was
     nommu-make-config_unevictable_lru-available-when-config_mmu=n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nommu: make CONFIG_UNEVICTABLE_LRU available when CONFIG_MMU=n
From: David Howells <dhowells@redhat.com>

Make CONFIG_UNEVICTABLE_LRU available when CONFIG_MMU=n.  There's no logical
reason it shouldn't be available, and it can be used for ramfs.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Greg Ungerer <gerg@snapgear.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Enrik Berkhan <Enrik.Berkhan@ge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/Kconfig~nommu-make-config_unevictable_lru-available-when-config_mmu=n mm/Kconfig
--- a/mm/Kconfig~nommu-make-config_unevictable_lru-available-when-config_mmu=n
+++ a/mm/Kconfig
@@ -206,7 +206,6 @@ config VIRT_TO_BUS
 config UNEVICTABLE_LRU
 	bool "Add LRU list to track non-evictable pages"
 	default y
-	depends on MMU
 	help
 	  Keeps unevictable pages off of the active and inactive pageout
 	  lists, so kswapd will not waste CPU time or have its balancing
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
linux-next.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
kbuild-make-it-possible-for-the-linker-to-discard-local-symbols-from-vmlinux.patch
xtensa-nommu-support.patch
frv-duplicate-output_buffer-of-e03.patch
flat-fix-data-sections-alignment.patch
flat-fix-data-sections-alignment-update.patch
bin_elf_fdpic-check-the-return-value-of-clear_user.patch
mutex-subsystem-synchro-test-module.patch

