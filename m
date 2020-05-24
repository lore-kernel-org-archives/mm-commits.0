From: akpm@linux-foundation.org
Subject: [merged]
 selftests-vm-write_to_hugetlbfsc-fix-unused-variable-warning.patch removed
 from -mm tree
Date: Sun, 24 May 2020 16:18:28 -0700
Message-ID: <20200524231828.x3yYQnII1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388202AbgEXXSa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 24 May 2020 19:18:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: almasrymina@google.com, bgeffon@google.com, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, rcampbell@nvidia.com, shuah@kernel.org


The patch titled
     Subject: selftests/vm/write_to_hugetlbfs.c: fix unused variable warning
has been removed from the -mm tree.  Its filename was
     selftests-vm-write_to_hugetlbfsc-fix-unused-variable-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/vm/write_to_hugetlbfs.c: fix unused variable warning

Remove unused variable "i", which was triggering a compiler warning.

Link: http://lkml.kernel.org/r/20200517001245.361762-2-jhubbard@nvidia.com
Fixes: 29750f71a9b4 ("hugetlb_cgroup: add hugetlb_cgroup reservation tests")
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-By: Mina Almasry <almasrymina@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/write_to_hugetlbfs.c |    2 --
 1 file changed, 2 deletions(-)

--- a/tools/testing/selftests/vm/write_to_hugetlbfs.c~selftests-vm-write_to_hugetlbfsc-fix-unused-variable-warning
+++ a/tools/testing/selftests/vm/write_to_hugetlbfs.c
@@ -74,8 +74,6 @@ int main(int argc, char **argv)
 	int write = 0;
 	int reserve = 1;
 
-	unsigned long i;
