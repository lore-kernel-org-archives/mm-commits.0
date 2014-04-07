From: akpm@linux-foundation.org
Subject: [folded-merged]
 zram-return-error-valued-pointer-from-zcomp_create-fix-2.patch removed from -mm tree
Date: Mon, 07 Apr 2014 15:14:22 -0700
Message-ID: <5343233e.VS9uhrKVMNaIOntf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40049 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936AbaDGWOX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2014 18:14:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, arnd@arndb.de, sergey.senozhatsky@gmail.com

Subject: [folded-merged] zram-return-error-valued-pointer-from-zcomp_create-fix-2.patch removed from -mm tree
To: sergey.senozhatsky@gmail.com,arnd@arndb.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 07 Apr 2014 15:14:22 -0700


The patch titled
     Subject: zram: include err.h
has been removed from the -mm tree.  Its filename was
     zram-return-error-valued-pointer-from-zcomp_create-fix-2.patch

This patch was dropped because it was folded into zram-return-error-valued-pointer-from-zcomp_create.patch

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: include err.h

[akpm@linux-foundation.org: fix zcomp.h as well]
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c    |    1 +
 drivers/block/zram/zram_drv.c |    1 +
 2 files changed, 2 insertions(+)

diff -puN drivers/block/zram/zram_drv.c~zram-return-error-valued-pointer-from-zcomp_create-fix-2 drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-return-error-valued-pointer-from-zcomp_create-fix-2
+++ a/drivers/block/zram/zram_drv.c
@@ -31,6 +31,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/vmalloc.h>
+#include <linux/err.h>
 
 #include "zram_drv.h"
 
diff -puN drivers/block/zram/zcomp.c~zram-return-error-valued-pointer-from-zcomp_create-fix-2 drivers/block/zram/zcomp.c
--- a/drivers/block/zram/zcomp.c~zram-return-error-valued-pointer-from-zcomp_create-fix-2
+++ a/drivers/block/zram/zcomp.c
@@ -9,6 +9,7 @@
 
 #include <linux/kernel.h>
 #include <linux/string.h>
+#include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/wait.h>
 #include <linux/sched.h>
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

origin.patch
zram-drop-init_done-struct-zram-member.patch
zram-do-not-pass-rw-argument-to-__zram_make_request.patch
zram-remove-good-and-bad-compress-stats.patch
zram-use-atomic64_t-for-all-zram-stats.patch
zram-remove-zram-stats-code-duplication.patch
zram-report-failed-read-and-write-stats.patch
zram-drop-not-used-table-count-member.patch
zram-move-zram-size-warning-to-documentation.patch
zram-document-failed_reads-failed_writes-stats.patch
zram-delete-zram_init_device.patch
zram-introduce-compressing-backend-abstraction.patch
zram-use-zcomp-compressing-backends.patch
zram-factor-out-single-stream-compression.patch
zram-add-multi-stream-functionality.patch
zram-add-set_max_streams-knob.patch
zram-make-compression-algorithm-selection-possible.patch
zram-add-lz4-algorithm-backend.patch
zram-move-comp-allocation-out-of-init_lock.patch
zram-return-error-valued-pointer-from-zcomp_create.patch
zram-propagate-error-to-user.patch
zram-propagate-error-to-user-fix.patch
zram-use-scnprintf-in-attrs-show-methods.patch
zram-support-req_discard.patch
zram-support-req_discard-v4.patch
zram-support-req_discard-v4-fix.patch
vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks.patch
vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks-fix.patch

