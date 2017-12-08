From: akpm@linux-foundation.org
Subject: + pci-remove-unneeded-kallsyms-include.patch added to -mm tree
Date: Fri, 08 Dec 2017 14:24:53 -0800
Message-ID: <5a2b1135.U2N5yJQc38p3Kl+T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51396 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753504AbdLHWYy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Dec 2017 17:24:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky.work@gmail.com, bhelgaas@google.com, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pci: remove unneeded kallsyms include
has been added to the -mm tree.  Its filename is
     pci-remove-unneeded-kallsyms-include.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pci-remove-unneeded-kallsyms-include.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pci-remove-unneeded-kallsyms-include.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: pci: remove unneeded kallsyms include

The file was converted from print_fn_descriptor_symbol() to %pF some time
ago in c9bbb4abb658da ("PCI: use %pF instead of
print_fn_descriptor_symbol() in quirks.c").  kallsyms does not seem to be
needed anymore.

Link: http://lkml.kernel.org/r/20171208025616.16267-5-sergey.senozhatsky@gmail.com
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/quirks.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/pci/quirks.c~pci-remove-unneeded-kallsyms-include drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~pci-remove-unneeded-kallsyms-include
+++ a/drivers/pci/quirks.c
@@ -19,7 +19,6 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/acpi.h>
-#include <linux/kallsyms.h>
 #include <linux/dmi.h>
 #include <linux/pci-aspm.h>
 #include <linux/ioport.h>
_

Patches currently in -mm which might be from sergey.senozhatsky.work@gmail.com are

sched-autogroup-remove-unneeded-kallsyms-include.patch
mm-remove-unneeded-kallsyms-include.patch
power-remove-unneeded-kallsyms-include.patch
pci-remove-unneeded-kallsyms-include.patch
pnp-remove-unneeded-kallsyms-include.patch
workqueue-remove-unneeded-kallsyms-include.patch
hrtimer-remove-unneeded-kallsyms-include.patch
genirq-remove-unneeded-kallsyms-include.patch

