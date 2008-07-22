From: akpm@linux-foundation.org
Subject: + firmware-use-memory_read_from_buffer-fix.patch added to -mm tree
Date: Tue, 22 Jul 2008 01:52:42 -0700
Message-ID: <200807220852.m6M8qgQV019586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48818 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751390AbYGVIxS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jul 2008 04:53:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, gregkh@suse.de, kay.sievers@vrfy.org, markus.rechberger@amd.com


The patch titled
     fix firmware-use-memory_read_from_buffer.patch
has been added to the -mm tree.  Its filename is
     firmware-use-memory_read_from_buffer-fix.patch

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
move-memory_read_from_buffer-from-fsh-to-stringh.patch
linux-next.patch
ipr-use-memory_read_from_buffer.patch
qla2xxx-use-memory_read_from_buffer.patch
qla2xxx-use-memory_read_from_buffer-fix.patch
pm-hibernation-simplify-memory-bitmap.patch
cris-use-simple_read_from_buffer.patch
binfmt_misc-use-simple_read_from_buffer.patch
aty-use-memory_read_from_buffer.patch
aty-use-memory_read_from_buffer-fix.patch
workqueue-proper-error-unwinding-in-cpu-hotplug-error-path.patch
ipc-use-simple_read_from_buffer.patch
nwflash-use-simple_read_from_buffer.patch
firmware-use-memory_read_from_buffer.patch
firmware-use-memory_read_from_buffer-fix.patch
dcdbas-use-memory_read_from_buffer.patch
dcdbas-use-memory_read_from_buffer-fix.patch
dell_rbu-use-memory_read_from_buffer.patch
fix-dell_rbu-use-memory_read_from_bufferpatch.patch

