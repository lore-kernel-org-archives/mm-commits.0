From: akpm@linux-foundation.org
Subject: + selftests-vm-point-to-libhugetlbfs-for-regression-testing.patch added to -mm tree
Date: Wed, 05 Aug 2015 13:42:57 -0700
Message-ID: <55c27551.vH3JivgK9Da8SaXv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37952 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628AbbHEUm6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Aug 2015 16:42:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, dave@stgolabs.net, joern@logfs.org, n-horiguchi@ah.jp.nec.com, rientjes@google.com, shuahkh@osg.samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: selftests:vm: point to libhugetlbfs for regression testing
has been added to the -mm tree.  Its filename is
     selftests-vm-point-to-libhugetlbfs-for-regression-testing.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-point-to-libhugetlbfs-for-regression-testing.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-point-to-libhugetlbfs-for-regression-testing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: selftests:vm: point to libhugetlbfs for regression testing

The hugetlb selftests provide minimal coverage.  Have run script point
people at libhugetlbfs for better regression testing.

Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Joern Engel <joern@logfs.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/run_vmtests |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN tools/testing/selftests/vm/run_vmtests~selftests-vm-point-to-libhugetlbfs-for-regression-testing tools/testing/selftests/vm/run_vmtests
--- a/tools/testing/selftests/vm/run_vmtests~selftests-vm-point-to-libhugetlbfs-for-regression-testing
+++ a/tools/testing/selftests/vm/run_vmtests
@@ -75,6 +75,10 @@ else
 	echo "[PASS]"
 fi
 
+echo "NOTE: The above hugetlb tests provide minimal coverage.  Use"
+echo "      https://github.com/libhugetlbfs/libhugetlbfs.git for"
+echo "      hugetlb regression testing."
+
 echo "--------------------"
 echo "running userfaultfd"
 echo "--------------------"
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-make-the-function-vma_shareable-bool.patch
mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add.patch
mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add-fix.patch
mm-hugetlb-add-region_del-to-delete-a-specific-range-of-entries.patch
mm-hugetlb-expose-hugetlb-fault-mutex-for-use-by-fallocate.patch
hugetlbfs-hugetlb_vmtruncate_list-needs-to-take-a-range-to-delete.patch
hugetlbfs-truncate_hugepages-takes-a-range-of-pages.patch
mm-hugetlb-vma_has_reserves-needs-to-handle-fallocate-hole-punch.patch
mm-hugetlb-alloc_huge_page-handle-areas-hole-punched-by-fallocate.patch
hugetlbfs-new-huge_add_to_page_cache-helper-routine.patch
hugetlbfs-add-hugetlbfs_fallocate.patch
hugetlbfs-add-hugetlbfs_fallocate-fix.patch
mm-madvise-allow-remove-operation-for-hugetlbfs.patch
reverted-selftests-add-hugetlbfstest.patch
selftests-vm-point-to-libhugetlbfs-for-regression-testing.patch
documentation-update-libhugetlbfs-location-and-use-for-testing.patch

