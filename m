From: akpm@linux-foundation.org
Subject: + mm-update-the-description-for-madvise_remove.patch added to -mm tree
Date: Tue, 24 Jun 2014 14:47:38 -0700
Message-ID: <53a9f1fa.N2SMmaVRrG9h4hRc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37071 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbaFXVrj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jun 2014 17:47:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shhuiw@gmail.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: update the description for madvise_remove
has been added to the -mm tree.  Its filename is
     mm-update-the-description-for-madvise_remove.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-update-the-description-for-madvise_remove.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-update-the-description-for-madvise_remove.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-update-the-description-for-madvise_remove.patch

