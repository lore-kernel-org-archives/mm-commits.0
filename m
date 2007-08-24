From: akpm@linux-foundation.org
Subject: - ipmi-fix-warning-in-ipmi_si_intfc.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:56:34 -0700
Message-ID: <200708242056.l7OKuYMK014070@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39598 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759882AbXHXVIf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:08:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: safradin@de.ibm.com, cminyard@mvista.com, krafft@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     IPMI: fix warning in ipmi_si_intf.c
has been removed from the -mm tree.  Its filename was
     ipmi-fix-warning-in-ipmi_si_intfc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: IPMI: fix warning in ipmi_si_intf.c
From: Mijo Safradin <safradin@de.ibm.com>

trivial change: fix warning

Signed-off-by: Mijo Safradin <safradin@de.ibm.com>
Acked-by: Christian Krafft <krafft@de.ibm.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-fix-warning-in-ipmi_si_intfc drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-fix-warning-in-ipmi_si_intfc
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -2292,7 +2292,7 @@ static int __devinit ipmi_of_probe(struc
 	info->irq		= irq_of_parse_and_map(dev->node, 0);
 	info->dev		= &dev->dev;
 
-	dev_dbg(&dev->dev, "addr 0x%lx regsize %ld spacing %ld irq %x\n",
+	dev_dbg(&dev->dev, "addr 0x%lx regsize %d spacing %d irq %x\n",
 		info->io.addr_data, info->io.regsize, info->io.regspacing,
 		info->irq);
 
_

Patches currently in -mm which might be from safradin@de.ibm.com are

origin.patch
