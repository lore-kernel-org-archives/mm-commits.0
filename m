From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-selftest-enable-testing-of-uffdio_zeropage-for-shmem.patch
 removed from -mm tree
Date: Thu, 07 Sep 2017 11:40:34 -0700
Message-ID: <20170907184034.rqKEq6EF-%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57464 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752538AbdIGSkf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:40:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, hillf.zj@alibaba-inc.com, hughd@google.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, rppt@linux.vnet.ibm.com, xemul@virtuozzo.com


The patch titled
     Subject: userfaultfd: selftest: enable testing of UFFDIO_ZEROPAGE for shmem
has been removed from the -mm tree.  Its filename was
     userfaultfd-selftest-enable-testing-of-uffdio_zeropage-for-shmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: userfaultfd: selftest: enable testing of UFFDIO_ZEROPAGE for shmem

Link: http://lkml.kernel.org/r/1497939652-16528-8-git-send-email-rppt@linux.vnet.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftest-enable-testing-of-uffdio_zeropage-for-shmem tools/testing/selftests/vm/userfaultfd.c
--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftest-enable-testing-of-uffdio_zeropage-for-shmem
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -198,7 +198,7 @@ static struct uffd_test_ops anon_uffd_te
 };
 
 static struct uffd_test_ops shmem_uffd_test_ops = {
-	.expected_ioctls = UFFD_API_RANGE_IOCTLS_BASIC,
+	.expected_ioctls = ANON_EXPECTED_IOCTLS,
 	.allocate_area	= shmem_allocate_area,
 	.release_pages	= shmem_release_pages,
 };
_

Patches currently in -mm which might be from rppt@linux.vnet.ibm.com are


