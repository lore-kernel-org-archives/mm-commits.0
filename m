From: akpm@linux-foundation.org
Subject: [merged] pnp-remove-unneeded-kallsyms-include.patch
 removed from -mm tree
Date: Mon, 18 Dec 2017 11:58:29 -0800
Message-ID: <20171218195829.JjmRDIseX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48798 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933023AbdLRT6a (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 18 Dec 2017 14:58:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhelgaas@google.com, mm-commits@vger.kernel.org, sergey.senozhatsky.work@gmail.com, sergey.senozhatsky@gmail.com


The patch titled
     Subject: pnp: remove unneeded kallsyms include
has been removed from the -mm tree.  Its filename was
     pnp-remove-unneeded-kallsyms-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: pnp: remove unneeded kallsyms include

The file was converted from print_fn_descriptor_symbol() to %pF some time
ago in 2e532d68a2b3e2aa ("{pci,pnp} quirks.c: don't use deprecated
print_fn_descriptor_symbol()").  kallsyms does not seem to be needed
anymore.

Link: http://lkml.kernel.org/r/20171208025616.16267-6-sergey.senozhatsky@gmail.com
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/quirks.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/pnp/quirks.c~pnp-remove-unneeded-kallsyms-include drivers/pnp/quirks.c
--- a/drivers/pnp/quirks.c~pnp-remove-unneeded-kallsyms-include
+++ a/drivers/pnp/quirks.c
@@ -21,7 +21,6 @@
 #include <linux/slab.h>
 #include <linux/pnp.h>
 #include <linux/io.h>
-#include <linux/kallsyms.h>
 #include "base.h"
 
 static void quirk_awe32_add_ports(struct pnp_dev *dev,
_

Patches currently in -mm which might be from sergey.senozhatsky.work@gmail.com are

mm-remove-unneeded-kallsyms-include.patch
pci-remove-unneeded-kallsyms-include.patch
hrtimer-remove-unneeded-kallsyms-include.patch
genirq-remove-unneeded-kallsyms-include.patch

