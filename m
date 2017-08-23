From: akpm@linux-foundation.org
Subject: + vga-optimise-console-scrolling-fix.patch added to -mm tree
Date: Wed, 23 Aug 2017 15:13:30 -0700
Message-ID: <599dfe0a.19xdPykXvPnFCB7x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45550 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751020AbdHWWNb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Aug 2017 18:13:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mawilcox@microsoft.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: vga-optimise-console-scrolling-fix
has been added to the -mm tree.  Its filename is
     vga-optimise-console-scrolling-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vga-optimise-console-scrolling-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vga-optimise-console-scrolling-fix.patch

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
Subject: vga-optimise-console-scrolling-fix

Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vt_buffer.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/vt_buffer.h~vga-optimise-console-scrolling-fix include/linux/vt_buffer.h
--- a/include/linux/vt_buffer.h~vga-optimise-console-scrolling-fix
+++ a/include/linux/vt_buffer.h
@@ -13,6 +13,7 @@
 #ifndef _LINUX_VT_BUFFER_H_
 #define _LINUX_VT_BUFFER_H_
 
+#include <linux/string.h>
 
 #if defined(CONFIG_VGA_CONSOLE) || defined(CONFIG_MDA_CONSOLE)
 #include <asm/vga.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix-fix.patch
mm-thp-enable-thp-migration-in-generic-path-fix-fix.patch
zsmalloc-zs_page_migrate-skip-unnecessary-loops-but-not-return-ebusy-if-zspage-is-not-inuse-fix.patch
userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist-fix.patch
mm-swap-add-swap-readahead-hit-statistics-fix.patch
swap-choose-swap-device-according-to-numa-node-v2-fix.patch
add-testcases-for-memset16-32-64-fix.patch
vga-optimise-console-scrolling-fix.patch
lib-add-test-for-bitmap_parselist-fix.patch
bitmap-introduce-bitmap_from_u64-checkpatch-fixes.patch
bitmap-introduce-bitmap_from_u64-checkpatch-fixes-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
treewide-remove-gfp_temporary-allocation-flag-fix.patch
treewide-remove-gfp_temporary-allocation-flag-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

