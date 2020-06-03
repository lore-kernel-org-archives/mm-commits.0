From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] khugepaged-add-self-test-fix-3.patch
 removed from -mm tree
Date: Wed, 03 Jun 2020 15:12:04 -0700
Message-ID: <20200603221204.zRX0sw8xw%akpm@linux-foundation.org>
References: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726354AbgFCWMF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 18:12:05 -0400
In-Reply-To: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bgeffon@google.com, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: khugepaged-add-self-test-fix-3
has been removed from the -mm tree.  Its filename was
     khugepaged-add-self-test-fix-3.patch

This patch was dropped because it was folded into khugepaged-add-self-test.patch

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: khugepaged-add-self-test-fix-3

Add khugepaged to .gitignore.

Link: http://lkml.kernel.org/r/20200517002509.362401-1-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Brian Geffon <bgeffon@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/.gitignore |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/vm/.gitignore~khugepaged-add-self-test-fix-3
+++ a/tools/testing/selftests/vm/.gitignore
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 hugepage-mmap
 hugepage-shm
+khugepaged
 map_hugetlb
 map_populate
 thuge-gen
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-gup-move-__get_user_pages_fast-down-a-few-lines-in-gupc.patch
mm-gup-refactor-and-de-duplicate-gup_fast-code.patch
mm-gup-introduce-pin_user_pages_fast_only.patch
drm-i915-convert-get_user_pages-pin_user_pages.patch
mm-gup-might_lock_readmmap_sem-in-get_user_pages_fast.patch
khugepaged-add-self-test.patch
rapidio-convert-get_user_pages-pin_user_pages.patch
mm-gup-update-pin_user_pagesrst-for-case-3-mmu-notifiers.patch
mm-gup-introduce-pin_user_pages_locked.patch
mm-gup-introduce-pin_user_pages_locked-v2.patch
mm-gup-frame_vector-convert-get_user_pages-pin_user_pages.patch
mm-gup-documentation-fix-for-pin_user_pages-apis.patch
docs-mm-gup-pin_user_pagesrst-add-a-case-5.patch
vhost-convert-get_user_pages-pin_user_pages.patch
