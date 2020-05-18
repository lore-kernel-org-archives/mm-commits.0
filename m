From: Andrew Morton <akpm@linux-foundation.org>
Subject: + khugepaged-add-self-test-fix-3.patch added to -mm tree
Date: Mon, 18 May 2020 15:05:05 -0700
Message-ID: <20200518220505.6b3V-_3ne%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726378AbgERWFG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 May 2020 18:05:06 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bgeffon@google.com, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: khugepaged-add-self-test-fix-3
has been added to the -mm tree.  Its filename is
     khugepaged-add-self-test-fix-3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/khugepaged-add-self-test-fix-3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/khugepaged-add-self-test-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

rapidio-fix-an-error-in-get_user_pages_fast-error-handling.patch
selftests-vm-gitignore-add-mremap_dontunmap.patch
mm-gup-introduce-pin_user_pages_unlocked.patch
ivtv-convert-get_user_pages-pin_user_pages.patch
khugepaged-add-self-test-fix-3.patch
rapidio-convert-get_user_pages-pin_user_pages.patch
