From: akpm@linux-foundation.org
Subject: [merged] misc-sram-use-set_memoryh-header.patch removed
 from -mm tree
Date: Tue, 09 May 2017 11:03:28 -0700
Message-ID: <20170509180328.yrBrBOmmq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34874 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753824AbdEISD3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 14:03:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: labbott@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/misc/sram-exec.c: use set_memory.h header
has been removed from the -mm tree.  Its filename was
     misc-sram-use-set_memoryh-header.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Laura Abbott <labbott@redhat.com>
Subject: drivers/misc/sram-exec.c: use set_memory.h header

set_memory_* functions have moved to set_memory.h. Switch to this
explicitly.

Link: http://lkml.kernel.org/r/1488920133-27229-15-git-send-email-labbott@redhat.com
Signed-off-by: Laura Abbott <labbott@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sram-exec.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/misc/sram-exec.c~misc-sram-use-set_memoryh-header drivers/misc/sram-exec.c
--- a/drivers/misc/sram-exec.c~misc-sram-use-set_memoryh-header
+++ a/drivers/misc/sram-exec.c
@@ -16,9 +16,10 @@
 
 #include <linux/device.h>
 #include <linux/genalloc.h>
+#include <linux/mm.h>
 #include <linux/sram.h>
 
-#include <asm/cacheflush.h>
+#include <asm/set_memory.h>
 
 #include "sram.h"
 
_

Patches currently in -mm which might be from labbott@redhat.com are


