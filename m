From: akpm@linux-foundation.org
Subject: + add-testcases-for-memset16-32-64-fix.patch added to -mm tree
Date: Wed, 02 Aug 2017 13:56:57 -0700
Message-ID: <59823c99.4otBCswHu7PmxNhN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52612 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752616AbdHBU5D (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2017 16:57:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mawilcox@microsoft.com, willy@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: add-testcases-for-memset16-32-64-fix
has been added to the -mm tree.  Its filename is
     add-testcases-for-memset16-32-64-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/add-testcases-for-memset16-32-64-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/add-testcases-for-memset16-32-64-fix.patch

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
Subject: add-testcases-for-memset16-32-64-fix

minor tweaks

Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN lib/string.c~add-testcases-for-memset16-32-64-fix lib/string.c
--- a/lib/string.c~add-testcases-for-memset16-32-64-fix
+++ a/lib/string.c
@@ -1149,7 +1149,6 @@ fail:
 	if (i < 256)
 		return (i << 24) | (j << 16) | k;
 	return 0;
-	return 0;
 }
 
 static __init int string_selftest_init(void)
@@ -1179,4 +1178,4 @@ fail:
 }
 
 module_init(string_selftest_init);
-#endif
+#endif	/* CONFIG_STRING_SELFTEST */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix-fix.patch
mm-thp-enable-thp-migration-in-generic-path-fix-fix.patch
zsmalloc-zs_page_migrate-skip-unnecessary-loops-but-not-return-ebusy-if-zspage-is-not-inuse-fix.patch
nvdimm-avoid-bogus-wmaybe-uninitialized-warning-fix.patch
treewide-remove-gfp_temporary-allocation-flag-fix.patch
treewide-remove-gfp_temporary-allocation-flag-checkpatch-fixes.patch
add-testcases-for-memset16-32-64-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

