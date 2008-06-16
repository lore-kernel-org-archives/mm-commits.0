From: akpm@linux-foundation.org
Subject: - agp-add-support-for-radeon-mobility-9000-chipset.patch removed from -mm tree
Date: Sun, 15 Jun 2008 23:02:55 -0700
Message-ID: <200806160602.m5G62unT010494@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51241 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754159AbYFPGDa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jun 2008 02:03:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amit.kucheria@ubuntu.com, airlied@linux.ie, max@stro.at, mm-commits@vger.kernel.org


The patch titled
     agp: add support for Radeon Mobility 9000 chipset
has been removed from the -mm tree.  Its filename was
     agp-add-support-for-radeon-mobility-9000-chipset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: agp: add support for Radeon Mobility 9000 chipset
From: Amit Kucheria <amit.kucheria@ubuntu.com>

Addresses https://bugs.edge.launchpad.net/ubuntu/+source/linux-source-2.6.22/+bug/178634

Signed-off-by: Amit Kucheria <amit.kucheria@ubuntu.com>
Signed-off-by: maximilian attems <max@stro.at>
Acked-by: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/ati-agp.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/char/agp/ati-agp.c~agp-add-support-for-radeon-mobility-9000-chipset drivers/char/agp/ati-agp.c
--- a/drivers/char/agp/ati-agp.c~agp-add-support-for-radeon-mobility-9000-chipset
+++ a/drivers/char/agp/ati-agp.c
@@ -458,6 +458,10 @@ static struct agp_device_ids ati_agp_dev
 		.chipset_name	= "IGP9100/M",
 	},
 	{
+		.device_id	= PCI_DEVICE_ID_ATI_RS350_133,
+		.chipset_name	= "IGP9000/M",
+	},
+	{
 		.device_id	= PCI_DEVICE_ID_ATI_RS350_200,
 		.chipset_name	= "IGP9100/M",
 	},
_

Patches currently in -mm which might be from amit.kucheria@ubuntu.com are

origin.patch

