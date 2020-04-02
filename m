From: akpm@linux-foundation.org
Subject: [folded-merged]
 hugetlb_cgroup-add-accounting-for-shared-mappings-fix.patch removed from
 -mm tree
Date: Wed, 01 Apr 2020 20:39:16 -0700
Message-ID: <20200402033916.0ZEpcZ5XO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387414AbgDBDjR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 1 Apr 2020 23:39:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, almasrymina@google.com, gthelen@google.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rientjes@google.com, sandipan@linux.ibm.com, sfr@canb.auug.org.au, shakeelb@google.com, shuah@kernel.org


The patch titled
     Subject: hugetlb_cgroup-add-accounting-for-shared-mappings-fix
has been removed from the -mm tree.  Its filename was
     hugetlb_cgroup-add-accounting-for-shared-mappings-fix.patch

This patch was dropped because it was folded into hugetlb_cgroup-add-accounting-for-shared-mappings.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hugetlb_cgroup-add-accounting-for-shared-mappings-fix

forward declare struct file_region

Cc: David Rientjes <rientjes@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Sandipan Das <sandipan@linux.ibm.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb_cgroup.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/hugetlb_cgroup.h~hugetlb_cgroup-add-accounting-for-shared-mappings-fix
+++ a/include/linux/hugetlb_cgroup.h
@@ -19,6 +19,7 @@
 
 struct hugetlb_cgroup;
 struct resv_map;
+struct file_region;
 
 /*
  * Minimum page order trackable by hugetlb cgroup.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

hugetlb_cgroup-add-accounting-for-shared-mappings.patch
