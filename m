From: akpm@linux-foundation.org
Subject: [merged] kernel-sysc-remove-obsolete-include-linux-kexech.patch
 removed from -mm tree
Date: Wed, 13 Nov 2013 12:40:02 -0800
Message-ID: <5283e3a2.PloOWfOthliA7vGp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42875 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab3KMUkD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:40:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, holt@sgi.com, geert@linux-m68k.org

Subject: [merged] kernel-sysc-remove-obsolete-include-linux-kexech.patch removed from -mm tree
To: geert@linux-m68k.org,holt@sgi.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:40:02 -0800


The patch titled
     Subject: kernel/sys.c: remove obsolete #include <linux/kexec.h>
has been removed from the -mm tree.  Its filename was
     kernel-sysc-remove-obsolete-include-linux-kexech.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: kernel/sys.c: remove obsolete #include <linux/kexec.h>

15d94b82565ebfb0 ("reboot: move shutdown/reboot related functions to
kernel/reboot.c") moved all kexec-related functionality to
kernel/reboot.c, so kernel/sys.c no longer needs to include
<linux/kexec.h>.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Robin Holt <holt@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/sys.c~kernel-sysc-remove-obsolete-include-linux-kexech kernel/sys.c
--- a/kernel/sys.c~kernel-sysc-remove-obsolete-include-linux-kexech
+++ a/kernel/sys.c
@@ -16,7 +16,6 @@
 #include <linux/perf_event.h>
 #include <linux/resource.h>
 #include <linux/kernel.h>
-#include <linux/kexec.h>
 #include <linux/workqueue.h>
 #include <linux/capability.h>
 #include <linux/device.h>
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
genirq-correct-fuzzy-and-fragile-irq_retval-definition.patch
scsi-do-not-call-do_div-with-a-64-bit-divisor.patch
linux-next.patch
x86-add-missed-pgtable_pmd_page_ctor-dtor-calls-for-preallocated-pmds.patch
m68k-handle-pgtable_page_ctor-fail.patch
m68k-handle-pgtable_page_ctor-fail-fix.patch
m68k-handle-pgtable_page_ctor-fail-fix-fix.patch

