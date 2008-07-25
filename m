From: akpm@linux-foundation.org
Subject: - dell_rbu-use-memory_read_from_buffer-fix.patch removed from -mm tree
Date: Thu, 24 Jul 2008 17:35:23 -0700
Message-ID: <200807250035.m6P0ZNrc014496@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41552 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752860AbYGYAfd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 20:35:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, Abhay_Salunke@dell.com, Matt_Domsch@dell.com, rui.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     fix dell_rbu-use-memory_read_from_buffer.patch
has been removed from the -mm tree.  Its filename was
     dell_rbu-use-memory_read_from_buffer-fix.patch

This patch was dropped because it was folded into dell_rbu-use-memory_read_from_buffer.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix dell_rbu-use-memory_read_from_buffer.patch
From: Akinobu Mita <akinobu.mita@gmail.com>

Now memory_read_from_buffer() belongs in string.h

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Abhay Salunke <Abhay_Salunke@dell.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dell_rbu.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/firmware/dell_rbu.c~dell_rbu-use-memory_read_from_buffer-fix drivers/firmware/dell_rbu.c
--- a/drivers/firmware/dell_rbu.c~dell_rbu-use-memory_read_from_buffer-fix
+++ a/drivers/firmware/dell_rbu.c
@@ -44,7 +44,6 @@
 #include <linux/moduleparam.h>
 #include <linux/firmware.h>
 #include <linux/dma-mapping.h>
-#include <linux/fs.h>
 
 MODULE_AUTHOR("Abhay Salunke <abhay_salunke@dell.com>");
 MODULE_DESCRIPTION("Driver for updating BIOS image on DELL systems");
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
workqueues-do-cpu_up_canceled-if-cpu_up_prepare-fails.patch
ipc-use-simple_read_from_buffer.patch
nwflash-use-simple_read_from_buffer.patch
firmware-use-memory_read_from_buffer.patch
dcdbas-use-memory_read_from_buffer.patch
dell_rbu-use-memory_read_from_buffer.patch
dell_rbu-use-memory_read_from_buffer-fix.patch

