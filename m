From: akpm@linux-foundation.org
Subject: [merged] eisaids-add-network-peripherals-fddi-boards.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:37:46 -0700
Message-ID: <200906171837.n5HIbkQn003792@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55028 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760364AbZFQSit (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:38:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, maz@misterjones.org, mm-commits@vger.kernel.org


The patch titled
     eisa.ids: add Network Peripherals FDDI boards
has been removed from the -mm tree.  Its filename was
     eisaids-add-network-peripherals-fddi-boards.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eisa.ids: add Network Peripherals FDDI boards
From: "Maciej W. Rozycki" <macro@linux-mips.org>

Add EISA IDs for Network Peripherals FDDI boards.  Descriptions taken from
the respective EISA configuration files.

It's unlikely we'll ever support these cards, the problem being the lack
of documentation.  Assuming the policy for the EISA ID database is the
same as for PCI I'm sending these entries for the sake of completeness.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Marc Zyngier <maz@misterjones.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/eisa/eisa.ids |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/eisa/eisa.ids~eisaids-add-network-peripherals-fddi-boards drivers/eisa/eisa.ids
--- a/drivers/eisa/eisa.ids~eisaids-add-network-peripherals-fddi-boards
+++ a/drivers/eisa/eisa.ids
@@ -1140,6 +1140,11 @@ NON0301 "c't Universale Graphic Adapter"
 NON0401 "c't Universal Ethernet Adapter"
 NON0501 "c't Universal 16-Bit Sound Adapter"
 NON0601 "c't Universal 8-Bit Adapter"
+NPI0120 "Network Peripherals NP-EISA-1 FDDI Interface"
+NPI0221 "Network Peripherals NP-EISA-2 FDDI Interface"
+NPI0223 "Network Peripherals NP-EISA-2E Enhanced FDDI Interface"
+NPI0301 "Network Peripherals NP-EISA-3 FDDI Interface"
+NPI0303 "Network Peripherals NP-EISA-3E Enhanced FDDI Interface"
 NSS0011 "Newport Systems Solutions WNIC Adapter"
 NVL0701 "Novell NE3200 Bus Master Ethernet"
 NVL0702 "Novell NE3200T Bus Master Ethernet"
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
linux-next.patch
serial-fix-off-by-one-errors.patch

