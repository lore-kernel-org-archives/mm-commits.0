From: akpm@linux-foundation.org
Subject: [merged] mm-update-the-description-for-madvise_remove.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:04:57 -0700
Message-ID: <53e3dbe9.WzV40dV0+MB5u4lg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:36454 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbaHGUE6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:04:58 -0400
Received: by mail-oa0-f74.google.com with SMTP id eb12so843169oac.1
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:04:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shhuiw@gmail.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: update the description for madvise_remove
has been removed from the -mm tree.  Its filename was
     mm-update-the-description-for-madvise_remove.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: mm: update the description for madvise_remove

Currently, we have more filesystems supporting fallocate, e.g ext4/btrfs. 
Remove the outdated comment for madvise_remove.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/madvise.c~mm-update-the-description-for-madvise_remove mm/madvise.c
--- a/mm/madvise.c~mm-update-the-description-for-madvise_remove
+++ a/mm/madvise.c
@@ -292,9 +292,6 @@ static long madvise_dontneed(struct vm_a
 /*
  * Application wants to free up the pages and associated backing store.
  * This is effectively punching a hole into the middle of a file.
- *
- * NOTE: Currently, only shmfs/tmpfs is supported for this operation.
- * Other filesystems return -ENOSYS.
  */
 static long madvise_remove(struct vm_area_struct *vma,
 				struct vm_area_struct **prev,
_

Patches currently in -mm which might be from shhuiw@gmail.com are

origin.patch

