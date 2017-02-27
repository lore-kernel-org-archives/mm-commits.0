From: akpm@linux-foundation.org
Subject: [merged] mm-fix-comments-for-mmap_init.patch removed from -mm
 tree
Date: Mon, 27 Feb 2017 12:25:08 -0800
Message-ID: <58b48b24.ij1i5/RHPzFyoPa3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34544 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751605AbdB0Ujs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:39:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamyooon@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix comments for mmap_init()
has been removed from the -mm tree.  Its filename was
     mm-fix-comments-for-mmap_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "seokhoon.yoon" <iamyooon@gmail.com>
Subject: mm: fix comments for mmap_init()

mmap_init() is no longer associated with VMA slab. so fix it.

Link: http://lkml.kernel.org/r/1485182601-9294-1-git-send-email-iamyooon@gmail.com
Signed-off-by: seokhoon.yoon <iamyooon@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c  |    2 +-
 mm/nommu.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/mmap.c~mm-fix-comments-for-mmap_init mm/mmap.c
--- a/mm/mmap.c~mm-fix-comments-for-mmap_init
+++ a/mm/mmap.c
@@ -3446,7 +3446,7 @@ void mm_drop_all_locks(struct mm_struct
 }
 
 /*
- * initialise the VMA slab
+ * initialise the percpu counter for VM
  */
 void __init mmap_init(void)
 {
diff -puN mm/nommu.c~mm-fix-comments-for-mmap_init mm/nommu.c
--- a/mm/nommu.c~mm-fix-comments-for-mmap_init
+++ a/mm/nommu.c
@@ -517,7 +517,7 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 }
 
 /*
- * initialise the VMA and region record slabs
+ * initialise the percpu counter for VM and region record slabs
  */
 void __init mmap_init(void)
 {
_

Patches currently in -mm which might be from iamyooon@gmail.com are


