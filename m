From: akpm@linux-foundation.org
Subject: [merged]
 selftests-vm-point-to-libhugetlbfs-for-regression-testing.patch removed
 from -mm tree
Date: Wed, 09 Sep 2015 12:47:24 -0700
Message-ID: <55f08ccc.2oFrN3FM5gwgksXa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39810 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbbIITrZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:47:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, dave@stgolabs.net, joern@logfs.org, n-horiguchi@ah.jp.nec.com, rientjes@google.com, shuahkh@osg.samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: selftests:vm: point to libhugetlbfs for regression testing
has been removed from the -mm tree.  Its filename was
     selftests-vm-point-to-libhugetlbfs-for-regression-testing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


