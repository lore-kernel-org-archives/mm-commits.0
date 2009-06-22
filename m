From: akpm@linux-foundation.org
Subject: [merged] agpgart-detected-ali-m-chipset-with-m1621.patch removed from -mm tree
Date: Mon, 22 Jun 2009 10:01:10 -0700
Message-ID: <200906221701.n5MH1A32010572@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753896AbZFVRBm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jun 2009 13:01:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rainbow-software.org, mm-commits@vger.kernel.org


The patch titled
     agpgart: detected ALi M???? chipset with M1621
has been removed from the -mm tree.  Its filename was
     agpgart-detected-ali-m-chipset-with-m1621.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

