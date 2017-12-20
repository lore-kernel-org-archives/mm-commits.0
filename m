From: akpm@linux-foundation.org
Subject: [merged] pci-remove-unneeded-kallsyms-include.patch
 removed from -mm tree
Date: Wed, 20 Dec 2017 13:31:03 -0800
Message-ID: <20171220213103.HISW8Lk86%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45308 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756004AbdLTVbE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 20 Dec 2017 16:31:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhelgaas@google.com, mm-commits@vger.kernel.org, sergey.senozhatsky.work@gmail.com, sergey.senozhatsky@gmail.com


The patch titled
     Subject: pci: remove unneeded kallsyms include
has been removed from the -mm tree.  Its filename was
     pci-remove-unneeded-kallsyms-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

zsmalloc-add-fsh-include.patch
mm-remove-unneeded-kallsyms-include.patch
hrtimer-remove-unneeded-kallsyms-include.patch
genirq-remove-unneeded-kallsyms-include.patch

