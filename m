From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-open-firmware-flattened-device-tree-entry.patch removed from -mm tree
Date: Fri, 30 Oct 2009 13:49:57 -0700
Message-ID: <200910302049.n9UKnvrN009446@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757507AbZJ3UuZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Oct 2009 16:50:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: grant.likely@secretlab.ca, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: add Open Firmware / Flattened Device Tree entry
has been removed from the -mm tree.  Its filename was
     maintainers-add-open-firmware-flattened-device-tree-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: add Open Firmware / Flattened Device Tree entry
From: Grant Likely <grant.likely@secretlab.ca>

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN MAINTAINERS~maintainers-add-open-firmware-flattened-device-tree-entry MAINTAINERS
--- a/MAINTAINERS~maintainers-add-open-firmware-flattened-device-tree-entry
+++ a/MAINTAINERS
@@ -3885,6 +3885,15 @@ S:	Maintained
 F:	Documentation/i2c/busses/i2c-ocores
 F:	drivers/i2c/busses/i2c-ocores.c
 
+OPEN FIRMWARE AND FLATTENED DEVICE TREE
+M:	Grant Likely <grant.likely@secretlab.ca>
+L:	devicetree-discuss@lists.ozlabs.org
+W:	http://fdt.secretlab.ca
+S:	Maintained
+F:	drivers/of
+F:	include/linux/of*.h
+K:	of_get_property
+
 OPROFILE
 M:	Robert Richter <robert.richter@amd.com>
 L:	oprofile-list@lists.sf.net
_

Patches currently in -mm which might be from grant.likely@secretlab.ca are

origin.patch
linux-next.patch

