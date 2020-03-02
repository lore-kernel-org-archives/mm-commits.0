From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-fix-2.patch removed from -mm tree
Date: Mon, 02 Mar 2020 10:59:36 -0800
Message-ID: <20200302185936.JaynzIMUY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726451AbgCBS7h (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 2 Mar 2020 13:59:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-fix-2
has been removed from the -mm tree.  Its filename was
     linux-next-fix-2.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-fix-2

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pinctrl/pinctrl-da9062.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pinctrl/pinctrl-da9062.c~linux-next-fix-2
+++ a/drivers/pinctrl/pinctrl-da9062.c
@@ -25,7 +25,7 @@
  * We need this get the gpio_desc from a <gpio_chip,offset> tuple to decide if
  * the gpio is active low without a vendor specific dt-binding.
  */
-#include <../gpio/gpiolib.h>
+#include "../gpio/gpiolib.h"
 
 #define DA9062_TYPE(offset)		(4 * (offset % 2))
 #define DA9062_PIN_SHIFT(offset)	(4 * (offset % 2))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-numa-fix-bad-pmd-by-atomically-check-for-pmd_trans_huge-when-marking-page-tables-prot_numa-fix.patch
mm.patch
selftest-add-mremap_dontunmap-selftest-fix.patch
selftest-add-mremap_dontunmap-selftest-v7-checkpatch-fixes.patch
hugetlb_cgroup-add-reservation-accounting-for-private-mappings-fix.patch
hugetlb_cgroup-add-accounting-for-shared-mappings-fix.patch
mm-migratec-migrate-pg_readahead-flag-fix.patch
proc-faster-open-read-close-with-permanent-files-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-fix.patch
linux-next-git-rejects.patch
mm-add-vm_insert_pages-fix.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch
drivers-tty-serial-sh-scic-suppress-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
