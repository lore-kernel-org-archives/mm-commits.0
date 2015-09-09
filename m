From: akpm@linux-foundation.org
Subject: [merged] memtest-remove-unused-header-files.patch removed from
 -mm tree
Date: Wed, 09 Sep 2015 12:44:05 -0700
Message-ID: <55f08c05.za5cTDnn9KQmbD3+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38909 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbbIIToF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:44:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vladimir.murzin@arm.com, leon@leon.nu, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memtest: remove unused header files
has been removed from the -mm tree.  Its filename was
     memtest-remove-unused-header-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: memtest: remove unused header files

memtest does not require these headers to be included.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: Leon Romanovsky <leon@leon.nu>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memtest.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN mm/memtest.c~memtest-remove-unused-header-files mm/memtest.c
--- a/mm/memtest.c~memtest-remove-unused-header-files
+++ a/mm/memtest.c
@@ -1,11 +1,6 @@
 #include <linux/kernel.h>
-#include <linux/errno.h>
-#include <linux/string.h>
 #include <linux/types.h>
-#include <linux/mm.h>
-#include <linux/smp.h>
 #include <linux/init.h>
-#include <linux/pfn.h>
 #include <linux/memblock.h>
 
 static u64 patterns[] __initdata = {
_

Patches currently in -mm which might be from vladimir.murzin@arm.com are


