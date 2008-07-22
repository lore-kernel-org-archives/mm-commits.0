From: akpm@linux-foundation.org
Subject: + dcdbas-use-memory_read_from_buffer-fix.patch added to -mm tree
Date: Tue, 22 Jul 2008 01:51:22 -0700
Message-ID: <200807220851.m6M8pMde019539@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751390AbYGVIwT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jul 2008 04:52:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, Douglas_Warzecha@dell.com, Matt_Domsch@dell.com, rui.zhang@intel.com


The patch titled
     fix dcdbas-use-memory_read_from_buffer.patch
has been added to the -mm tree.  Its filename is
     dcdbas-use-memory_read_from_buffer-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
move-memory_read_from_buffer-from-fsh-to-stringh.patch
linux-next.patch
ipr-use-memory_read_from_buffer.patch
qla2xxx-use-memory_read_from_buffer.patch
qla2xxx-use-memory_read_from_buffer-fix.patch
pm-hibernation-simplify-memory-bitmap.patch
cris-use-simple_read_from_buffer.patch
binfmt_misc-use-simple_read_from_buffer.patch
aty-use-memory_read_from_buffer.patch
workqueue-proper-error-unwinding-in-cpu-hotplug-error-path.patch
ipc-use-simple_read_from_buffer.patch
nwflash-use-simple_read_from_buffer.patch
firmware-use-memory_read_from_buffer.patch
dcdbas-use-memory_read_from_buffer.patch
dcdbas-use-memory_read_from_buffer-fix.patch
dell_rbu-use-memory_read_from_buffer.patch
fix-aty-use-memory_read_from_bufferpatch.patch
fix-firmware-use-memory_read_from_bufferpatch.patch
fix-dell_rbu-use-memory_read_from_bufferpatch.patch

