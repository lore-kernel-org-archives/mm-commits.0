From: akpm@linux-foundation.org
Subject: [merged] test_kasan-just-fix-a-typo.patch removed from -mm tree
Date: Fri, 11 Sep 2015 11:12:05 -0700
Message-ID: <55f31975.IkeZpOir2/f0jhFv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53773 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbbIKSMF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:12:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: long.wanglong@huawei.com, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_kasan.c: fix a typo
has been removed from the -mm tree.  Its filename was
     test_kasan-just-fix-a-typo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wang Long <long.wanglong@huawei.com>
Subject: lib/test_kasan.c: fix a typo

Signed-off-by: Wang Long <long.wanglong@huawei.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/test_kasan.c~test_kasan-just-fix-a-typo lib/test_kasan.c
--- a/lib/test_kasan.c~test_kasan-just-fix-a-typo
+++ a/lib/test_kasan.c
@@ -65,7 +65,7 @@ static noinline void __init kmalloc_node
 	kfree(ptr);
 }
 
-static noinline void __init kmalloc_large_oob_rigth(void)
+static noinline void __init kmalloc_large_oob_right(void)
 {
 	char *ptr;
 	size_t size = KMALLOC_MAX_CACHE_SIZE + 10;
@@ -259,7 +259,7 @@ static int __init kmalloc_tests_init(voi
 	kmalloc_oob_right();
 	kmalloc_oob_left();
 	kmalloc_node_oob_right();
-	kmalloc_large_oob_rigth();
+	kmalloc_large_oob_right();
 	kmalloc_oob_krealloc_more();
 	kmalloc_oob_krealloc_less();
 	kmalloc_oob_16();
_

Patches currently in -mm which might be from long.wanglong@huawei.com are


