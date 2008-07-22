From: akpm@linux-foundation.org
Subject: + qla2xxx-use-memory_read_from_buffer-fix.patch added to -mm tree
Date: Tue, 22 Jul 2008 01:49:23 -0700
Message-ID: <200807220849.m6M8nNXw019446@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42375 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752372AbYGVIt7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jul 2008 04:49:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, James.Bottomley@HansenPartnership.com, andrew.vasquez@qlogic.com, linux-driver@qlogic.com, seokmann.ju@qlogic.com


The patch titled
     fix qla2xxx-use-memory_read_from_buffer.patch
has been added to the -mm tree.  Its filename is
     qla2xxx-use-memory_read_from_buffer-fix.patch

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
Subject: fix qla2xxx-use-memory_read_from_buffer.patch
From: Akinobu Mita <akinobu.mita@gmail.com>

Now memory_read_from_buffer() belongs in string.h

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Andrew Vasquez <linux-driver@qlogic.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Seokmann Ju <seokmann.ju@qlogic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/qla2xxx/qla_attr.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/scsi/qla2xxx/qla_attr.c~qla2xxx-use-memory_read_from_buffer-fix drivers/scsi/qla2xxx/qla_attr.c
--- a/drivers/scsi/qla2xxx/qla_attr.c~qla2xxx-use-memory_read_from_buffer-fix
+++ a/drivers/scsi/qla2xxx/qla_attr.c
@@ -8,7 +8,6 @@
 
 #include <linux/kthread.h>
 #include <linux/vmalloc.h>
-#include <linux/fs.h>
 
 static int qla24xx_vport_disable(struct fc_vport *, bool);
 
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
dell_rbu-use-memory_read_from_buffer.patch
fix-dcdbas-use-memory_read_from_bufferpatch.patch
fix-aty-use-memory_read_from_bufferpatch.patch
fix-firmware-use-memory_read_from_bufferpatch.patch
fix-dell_rbu-use-memory_read_from_bufferpatch.patch

