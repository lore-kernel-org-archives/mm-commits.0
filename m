From: akpm@linux-foundation.org
Subject: + kernel-sysc-remove-obsolete-include-linux-kexech.patch added to -mm tree
Date: Thu, 26 Sep 2013 14:50:48 -0700
Message-ID: <5244ac38.rJVCEIWmDDusGM9q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34387 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab3IZVus (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Sep 2013 17:50:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, holt@sgi.com, geert@linux-m68k.org

Subject: + kernel-sysc-remove-obsolete-include-linux-kexech.patch added to -mm tree
To: geert@linux-m68k.org,holt@sgi.com
From: akpm@linux-foundation.org
Date: Thu, 26 Sep 2013 14:50:48 -0700


The patch titled
     Subject: kernel/sys.c: remove obsolete #include <linux/kexec.h>
has been added to the -mm tree.  Its filename is
     kernel-sysc-remove-obsolete-include-linux-kexech.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-sysc-remove-obsolete-include-linux-kexech.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-sysc-remove-obsolete-include-linux-kexech.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-kconfig-fix-grammar-s-an-a.patch
syscallsh-use-gcc-alias-instead-of-assembler-aliases-for-syscalls.patch
scripts-mod-modpostc-handle-non-abs-crc-symbols.patch
kernel-sysc-remove-obsolete-include-linux-kexech.patch
inith-document-the-existence-of-__initconst.patch
linux-next.patch

