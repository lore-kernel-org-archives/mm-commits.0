From: akpm@linux-foundation.org
Subject: + maintainers-add-open-firmware-flattened-device-tree-entry.patch added to -mm tree
Date: Mon, 12 Oct 2009 16:17:33 -0700
Message-ID: <200910122317.n9CNHXv4013016@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57427 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758170AbZJLXSM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Oct 2009 19:18:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: grant.likely@secretlab.ca, joe@perches.com


The patch titled
     MAINTAINERS: add Open Firmware / Flattened Device Tree entry
has been added to the -mm tree.  Its filename is
     maintainers-add-open-firmware-flattened-device-tree-entry.patch

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
Subject: MAINTAINERS: add Open Firmware / Flattened Device Tree entry
From: Grant Likely <grant.likely@secretlab.ca>

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN MAINTAINERS~maintainers-add-open-firmware-flattened-device-tree-entry MAINTAINERS
--- a/MAINTAINERS~maintainers-add-open-firmware-flattened-device-tree-entry
+++ a/MAINTAINERS
@@ -3918,6 +3918,15 @@ S:	Maintained
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

linux-next.patch
maintainers-add-open-firmware-flattened-device-tree-entry.patch

