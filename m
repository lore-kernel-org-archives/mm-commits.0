From: akpm@linux-foundation.org
Subject: - intelfb-the-pseudo_palette-is-only-16-elements-long.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:07:46 -0700
Message-ID: <200707172307.l6HN7kdf012219@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48014 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757890AbXGQXPF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     intelfb: the pseudo_palette is only 16 elements long
has been removed from the -mm tree.  Its filename was
     intelfb-the-pseudo_palette-is-only-16-elements-long.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: intelfb: the pseudo_palette is only 16 elements long
From: "Antonino A. Daplas" <adaplas@gmail.com>

The pseudo_palette is only 16 elements long.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/intelfb/intelfb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/intelfb/intelfb.h~intelfb-the-pseudo_palette-is-only-16-elements-long drivers/video/intelfb/intelfb.h
--- a/drivers/video/intelfb/intelfb.h~intelfb-the-pseudo_palette-is-only-16-elements-long
+++ a/drivers/video/intelfb/intelfb.h
@@ -302,7 +302,7 @@ struct intelfb_info {
 	u32 ring_lockup;
 
 	/* palette */
-	u32 pseudo_palette[17];
+	u32 pseudo_palette[16];
 
 	/* chip info */
 	int pci_chipset;
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
