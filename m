From: akpm@linux-foundation.org
Subject: + arch-s390-include-asm-bitopsh-needs-linux-typesh.patch added to -mm tree
Date: Tue, 06 Sep 2016 12:27:37 -0700
Message-ID: <57cf18a9.nOybJJjMvVpC2/Gd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58057 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941038AbcIFT1i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2016 15:27:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chengang@emindsoft.com.cn, heiko.carstens@de.ibm.com, lkp@intel.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/s390/include/asm/bitops.h needs linux/types.h
has been added to the -mm tree.  Its filename is
     arch-s390-include-asm-bitopsh-needs-linux-typesh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-s390-include-asm-bitopsh-needs-linux-typesh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-s390-include-asm-bitopsh-needs-linux-typesh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: arch/s390/include/asm/bitops.h needs linux/types.h

   In file included from include/linux/bitops.h:36:0,
                    from fs/btrfs/extent_io.c:1:
   arch/s390/include/asm/bitops.h:176:15: error: unknown type name 'bool'
    static inline bool
                  ^
   arch/s390/include/asm/bitops.h:187:15: error: unknown type name 'bool'
    static inline bool

Reported-by: kbuild test robot <lkp@intel.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Chen Gang <chengang@emindsoft.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/bitops.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/s390/include/asm/bitops.h~arch-s390-include-asm-bitopsh-needs-linux-typesh arch/s390/include/asm/bitops.h
--- a/arch/s390/include/asm/bitops.h~arch-s390-include-asm-bitopsh-needs-linux-typesh
+++ a/arch/s390/include/asm/bitops.h
@@ -40,6 +40,7 @@
 #error only <linux/bitops.h> can be included directly
 #endif
 
+#include <linux/types.h>
 #include <linux/typecheck.h>
 #include <linux/compiler.h>
 #include <asm/barrier.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
arch-s390-include-asm-bitopsh-needs-linux-typesh.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-vmalloc-fix-align-value-calculation-error-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix.patch
mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions-checkpatch-fixes.patch
mm-swap-add-swap_cluster_list-checkpatch-fixes.patch
mm-check-that-we-havent-used-more-than-32-bits-in-address_spaceflags.patch
mm-mlock-check-against-vma-for-actual-mlock-size-fix.patch
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix.patch
ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-mlx5-deviceh-kill-build_bug_ons.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

