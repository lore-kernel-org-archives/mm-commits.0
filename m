From: akpm@linux-foundation.org
Subject: - dcdbas-use-memory_read_from_buffer-fix.patch removed from -mm tree
Date: Thu, 24 Jul 2008 17:34:16 -0700
Message-ID: <200807250034.m6P0YGDA014473@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39534 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753056AbYGYAeX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 20:34:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, Douglas_Warzecha@dell.com, Matt_Domsch@dell.com, rui.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     fix dcdbas-use-memory_read_from_buffer.patch
has been removed from the -mm tree.  Its filename was
     dcdbas-use-memory_read_from_buffer-fix.patch

This patch was dropped because it was folded into dcdbas-use-memory_read_from_buffer.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix dcdbas-use-memory_read_from_buffer.patch
From: Akinobu Mita <akinobu.mita@gmail.com>

Now memory_read_from_buffer() belongs in string.h

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Doug Warzecha <Douglas_Warzecha@dell.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dcdbas.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/firmware/dcdbas.c~dcdbas-use-memory_read_from_buffer-fix drivers/firmware/dcdbas.c
--- a/drivers/firmware/dcdbas.c~dcdbas-use-memory_read_from_buffer-fix
+++ a/drivers/firmware/dcdbas.c
@@ -34,7 +34,6 @@
 #include <linux/string.h>
 #include <linux/types.h>
 #include <linux/mutex.h>
-#include <linux/fs.h>
 #include <asm/io.h>
 
 #include "dcdbas.h"
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
workqueues-do-cpu_up_canceled-if-cpu_up_prepare-fails.patch
ipc-use-simple_read_from_buffer.patch
nwflash-use-simple_read_from_buffer.patch
firmware-use-memory_read_from_buffer.patch
dcdbas-use-memory_read_from_buffer.patch
dcdbas-use-memory_read_from_buffer-fix.patch
dell_rbu-use-memory_read_from_buffer.patch
dell_rbu-use-memory_read_from_buffer-fix.patch

