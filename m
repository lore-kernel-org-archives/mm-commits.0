From: akpm@linux-foundation.org
Subject: - tweak-documentation-sm501txt.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:04:38 -0700
Message-ID: <200710180704.l9I74cbm031571@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54737 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763528AbXJRHQZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:16:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rob@landley.net, ben@simtec.co.uk, mm-commits@vger.kernel.org


The patch titled
     Tweak Documentation/SM501.txt
has been removed from the -mm tree.  Its filename was
     tweak-documentation-sm501txt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Tweak Documentation/SM501.txt
From: Rob Landley <rob@landley.net>

The existing Documentation/SM501.txt gives no clue what the chip is or does,
so copy the description from Kconfig help text.

Acked-by: Ben Dooks <ben@simtec.co.uk>
Signed-off-by: Rob Landley <rob@landley.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/SM501.txt |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN Documentation/SM501.txt~tweak-documentation-sm501txt Documentation/SM501.txt
--- a/Documentation/SM501.txt~tweak-documentation-sm501txt
+++ a/Documentation/SM501.txt
@@ -3,6 +3,11 @@
 
 Copyright 2006, 2007 Simtec Electronics
 
+The Silicon Motion SM501 multimedia companion chip is a multifunction device
+which may provide numerous interfaces including USB host controller USB gadget,
+Asyncronous Serial ports, Audio functions and a dual display video interface.
+The device may be connected by PCI or local bus with varying functions enabled.
+
 Core
 ----
 
_

Patches currently in -mm which might be from rob@landley.net are

origin.patch
comment-typo-in-scripts-kconfig-makefile.patch
