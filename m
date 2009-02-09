From: akpm@linux-foundation.org
Subject: + agpgart-detected-ali-m-chipset-with-m1621.patch added to -mm tree
Date: Mon, 09 Feb 2009 14:25:06 -0800
Message-ID: <200902092225.n19MP6TS022731@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37759 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751843AbZBIWZN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 17:25:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@rainbow-software.org


The patch titled
     agpgart: detected ALi M???? chipset with M1621
has been added to the -mm tree.  Its filename is
     agpgart-detected-ali-m-chipset-with-m1621.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: agpgart: detected ALi M???? chipset with M1621
From: Ondrej Zary <linux@rainbow-software.org>

Add M1621 chipset name to ali-agp, preventing "Detected ALi M???? chipset"
message.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/ali-agp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/agp/ali-agp.c~agpgart-detected-ali-m-chipset-with-m1621 drivers/char/agp/ali-agp.c
--- a/drivers/char/agp/ali-agp.c~agpgart-detected-ali-m-chipset-with-m1621
+++ a/drivers/char/agp/ali-agp.c
@@ -346,7 +346,7 @@ found:
 			devs[j].chipset_name = "M1641";
 			break;
 		case 0x43:
-			devs[j].chipset_name = "M????";
+			devs[j].chipset_name = "M1621";
 			break;
 		case 0x47:
 			devs[j].chipset_name = "M1647";
_

Patches currently in -mm which might be from linux@rainbow-software.org are

linux-next.patch
agpgart-detected-ali-m-chipset-with-m1621.patch
pata_it821x-resume-from-hibernation-fails-with-raid-volume.patch

