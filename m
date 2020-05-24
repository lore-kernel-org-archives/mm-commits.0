From: akpm@linux-foundation.org
Subject: [merged]
 selftests-vm-gitignore-add-mremap_dontunmap.patch removed from -mm tree
Date: Sun, 24 May 2020 16:18:26 -0700
Message-ID: <20200524231826.9cUla6zlH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388202AbgEXXS2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 24 May 2020 19:18:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bgeffon@google.com, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm/.gitignore: add mremap_dontunmap
has been removed from the -mm tree.  Its filename was
     selftests-vm-gitignore-add-mremap_dontunmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/vm/.gitignore: add mremap_dontunmap

Add mremap_dontunmap to .gitignore.

Link: http://lkml.kernel.org/r/20200517002509.362401-2-jhubbard@nvidia.com
Fixes: 0c28759ee3c9 ("selftests: add MREMAP_DONTUNMAP selftest")
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Brian Geffon <bgeffon@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/.gitignore |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/vm/.gitignore~selftests-vm-gitignore-add-mremap_dontunmap
+++ a/tools/testing/selftests/vm/.gitignore
@@ -6,6 +6,7 @@ map_populate
 thuge-gen
 compaction_test
 mlock2-tests
+mremap_dontunmap
 on-fault-limit
 transhuge-stress
 userfaultfd
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-gup-introduce-pin_user_pages_unlocked.patch
ivtv-convert-get_user_pages-pin_user_pages.patch
mm-gup-move-__get_user_pages_fast-down-a-few-lines-in-gupc.patch
mm-gup-refactor-and-de-duplicate-gup_fast-code.patch
mm-gup-refactor-and-de-duplicate-gup_fast-code-fix.patch
mm-gup-introduce-pin_user_pages_fast_only.patch
drm-i915-convert-get_user_pages-pin_user_pages.patch
mm-gup-might_lock_readmmap_sem-in-get_user_pages_fast.patch
khugepaged-add-self-test-fix-3.patch
rapidio-convert-get_user_pages-pin_user_pages.patch
