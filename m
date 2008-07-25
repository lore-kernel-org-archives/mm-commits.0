From: akpm@linux-foundation.org
Subject: - firmware-use-memory_read_from_buffer-fix.patch removed from -mm tree
Date: Thu, 24 Jul 2008 17:34:04 -0700
Message-ID: <200807250034.m6P0Y4iV014470@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37444 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752984AbYGYAeO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 20:34:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, gregkh@suse.de, kay.sievers@vrfy.org, markus.rechberger@amd.com, mm-commits@vger.kernel.org


The patch titled
     fix firmware-use-memory_read_from_buffer.patch
has been removed from the -mm tree.  Its filename was
     firmware-use-memory_read_from_buffer-fix.patch

This patch was dropped because it was folded into firmware-use-memory_read_from_buffer.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix firmware-use-memory_read_from_buffer.patch
From: Akinobu Mita <akinobu.mita@gmail.com>

Now memory_read_from_buffer() belongs in string.h

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Markus Rechberger <markus.rechberger@amd.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/firmware_class.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/base/firmware_class.c~firmware-use-memory_read_from_buffer-fix drivers/base/firmware_class.c
--- a/drivers/base/firmware_class.c~firmware-use-memory_read_from_buffer-fix
+++ a/drivers/base/firmware_class.c
@@ -17,7 +17,6 @@
 #include <linux/bitops.h>
 #include <linux/mutex.h>
 #include <linux/kthread.h>
-#include <linux/fs.h>
 
 #include <linux/firmware.h>
 #include "base.h"
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
workqueues-do-cpu_up_canceled-if-cpu_up_prepare-fails.patch
ipc-use-simple_read_from_buffer.patch
nwflash-use-simple_read_from_buffer.patch
firmware-use-memory_read_from_buffer.patch
firmware-use-memory_read_from_buffer-fix.patch
dcdbas-use-memory_read_from_buffer.patch
dcdbas-use-memory_read_from_buffer-fix.patch
dell_rbu-use-memory_read_from_buffer.patch
dell_rbu-use-memory_read_from_buffer-fix.patch

