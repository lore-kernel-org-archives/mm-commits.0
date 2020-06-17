From: akpm@linux-foundation.org
Subject: [nacked]
 hugetlb-hugetlbfs_file_operations-can-be-static.patch removed from -mm tree
Date: Tue, 16 Jun 2020 18:26:10 -0700
Message-ID: <20200617012610.hHal2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbgFQB0N (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 16 Jun 2020 21:26:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mike.kravetz@oracle.com, lkp@intel.com


The patch titled
     Subject: fs/hugetlbfs/inode.c: hugetlbfs_file_operations can be static
has been removed from the -mm tree.  Its filename was
     hugetlb-hugetlbfs_file_operations-can-be-static.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: kernel test robot <lkp@intel.com>
Subject: fs/hugetlbfs/inode.c: hugetlbfs_file_operations can be static

Link: http://lkml.kernel.org/r/20200612062853.GA35019@0619708f5df1
Signed-off-by: kernel test robot <lkp@intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/hugetlbfs/inode.c~hugetlb-hugetlbfs_file_operations-can-be-static
+++ a/fs/hugetlbfs/inode.c
@@ -42,7 +42,7 @@
 
 static const struct super_operations hugetlbfs_ops;
 static const struct address_space_operations hugetlbfs_aops;
-const struct file_operations hugetlbfs_file_operations;
+static const struct file_operations hugetlbfs_file_operations;
 static const struct inode_operations hugetlbfs_dir_inode_operations;
 static const struct inode_operations hugetlbfs_inode_operations;
 
_

Patches currently in -mm which might be from lkp@intel.com are
