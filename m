From: akpm@linux-foundation.org
Subject: + mmfork-introduce-madv_wipeonfork-fix.patch added to -mm tree
Date: Tue, 05 Sep 2017 16:15:46 -0700
Message-ID: <59af3022.s9KSujD6NfCBDaBp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39766 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753115AbdIEXPr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Sep 2017 19:15:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, deller@gmx.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mmfork-introduce-madv_wipeonfork-fix
has been added to the -mm tree.  Its filename is
     mmfork-introduce-madv_wipeonfork-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmfork-introduce-madv_wipeonfork-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmfork-introduce-madv_wipeonfork-fix.patch

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
Subject: mmfork-introduce-madv_wipeonfork-fix

numerically order arch/parisc/include/uapi/asm/mman.h #defines

Cc: Helge Deller <deller@gmx.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/include/uapi/asm/mman.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/parisc/include/uapi/asm/mman.h~mmfork-introduce-madv_wipeonfork-fix arch/parisc/include/uapi/asm/mman.h
--- a/arch/parisc/include/uapi/asm/mman.h~mmfork-introduce-madv_wipeonfork-fix
+++ a/arch/parisc/include/uapi/asm/mman.h
@@ -57,12 +57,12 @@
 					   overrides the coredump filter bits */
 #define MADV_DODUMP	70		/* Clear the MADV_NODUMP flag */
 
-#define MADV_HWPOISON     100		/* poison a page for testing */
-#define MADV_SOFT_OFFLINE 101		/* soft offline page for testing */
-
 #define MADV_WIPEONFORK 71		/* Zero memory on fork, child only */
 #define MADV_KEEPONFORK 72		/* Undo MADV_WIPEONFORK */
 
+#define MADV_HWPOISON     100		/* poison a page for testing */
+#define MADV_SOFT_OFFLINE 101		/* soft offline page for testing */
+
 /* compatibility flags */
 #define MAP_FILE	0
 #define MAP_VARIABLE	0
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix-fix.patch
mm-thp-enable-thp-migration-in-generic-path-fix-fix.patch
mm-page_owner-make-init_pages_in_zone-faster-fix-checkpatch-fixes.patch
zsmalloc-zs_page_migrate-skip-unnecessary-loops-but-not-return-ebusy-if-zspage-is-not-inuse-fix.patch
userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist-fix.patch
mm-swap-add-swap-readahead-hit-statistics-fix.patch
swap-choose-swap-device-according-to-numa-node-v2-fix.patch
mmfork-introduce-madv_wipeonfork-fix.patch
mm-change-the-call-sites-of-numa-statistics-items-checkpatch-fixes.patch
add-testcases-for-memset16-32-64-fix.patch
vga-optimise-console-scrolling-fix.patch
lib-add-test-for-bitmap_parselist-fix.patch
bitmap-introduce-bitmap_from_u64-checkpatch-fixes.patch
bitmap-introduce-bitmap_from_u64-checkpatch-fixes-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
zram-mm-vs-block.patch
drivers-media-cec-cec-adapc-fix-build-with-gcc-444.patch
treewide-remove-gfp_temporary-allocation-flag-fix.patch
treewide-remove-gfp_temporary-allocation-flag-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

