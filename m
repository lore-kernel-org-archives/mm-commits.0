From: akpm@linux-foundation.org
Subject: + memtest-remove-unused-header-files.patch added to -mm tree
Date: Tue, 14 Jul 2015 12:16:43 -0700
Message-ID: <55a5601b.FxX+Q1lUBmx6Rrpa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38196 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbbGNTQo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jul 2015 15:16:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vladimir.murzin@arm.com, leon@leon.nu, mm-commits@vger.kernel.org


The patch titled
     Subject: memtest: remove unused header files
has been added to the -mm tree.  Its filename is
     memtest-remove-unused-header-files.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memtest-remove-unused-header-files.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memtest-remove-unused-header-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: memtest: remove unused header files

memtest does not require these headers to be included.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: Leon Romanovsky <leon@leon.nu>
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

memtest-use-kstrtouint-instead-of-simple_strtoul.patch
memtest-cleanup-log-messages.patch
memtest-remove-unused-header-files.patch

