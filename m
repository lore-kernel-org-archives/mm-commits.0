From: akpm@linux-foundation.org
Subject: + agp-add-support-for-radeon-mobility-9000-chipset.patch added to -mm tree
Date: Fri, 06 Jun 2008 13:41:53 -0700
Message-ID: <200806062041.m56KfrLx018382@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55643 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933151AbYFFUmV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jun 2008 16:42:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amit.kucheria@ubuntu.com, airlied@linux.ie, max@stro.at


The patch titled
     agp: add support for Radeon Mobility 9000 chipset
has been added to the -mm tree.  Its filename is
     agp-add-support-for-radeon-mobility-9000-chipset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: agp: add support for Radeon Mobility 9000 chipset
From: Amit Kucheria <amit.kucheria@ubuntu.com>

Bug: 178634

Signed-off-by: Amit Kucheria <amit.kucheria@ubuntu.com>
Signed-off-by: maximilian attems <max@stro.at>
Cc: Dave Airlie <airlied@linux.ie>
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

agp-add-support-for-radeon-mobility-9000-chipset.patch

