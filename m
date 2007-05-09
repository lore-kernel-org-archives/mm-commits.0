From: akpm@linux-foundation.org
Subject: - documentation-cciss-detecting-failed-drives.patch removed from -mm tree
Date: Tue, 08 May 2007 19:50:13 -0700
Message-ID: <200705090250.l492oDUK009325@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56584 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969819AbXEICuR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:50:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steve.cameron@hp.com, mm-commits@vger.kernel.org


The patch titled
     Documentation: cciss: detecting failed drives
has been removed from the -mm tree.  Its filename was
     documentation-cciss-detecting-failed-drives.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Documentation: cciss: detecting failed drives
From: Stephen M. Cameron <steve.cameron@hp.com>

Document how to detect drive failures for cciss

Signed-off-by: Stephen M. Cameron <steve.cameron@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cciss.txt |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN Documentation/cciss.txt~documentation-cciss-detecting-failed-drives Documentation/cciss.txt
--- a/Documentation/cciss.txt~documentation-cciss-detecting-failed-drives
+++ a/Documentation/cciss.txt
@@ -22,14 +22,21 @@ This driver is known to work with the fo
 	* SA E200i
 	* SA E500
 
-If nodes are not already created in the /dev/cciss directory, run as root:
+Detecting drive failures:
+-------------------------
 
-# cd /dev
-# ./MAKEDEV cciss
+To get the status of logical volumes and to detect physical drive
+failures, you can use the cciss_vol_status program found here:
+http://cciss.sourceforge.net/#cciss_utils
 
 Device Naming:
 --------------
 
+If nodes are not already created in the /dev/cciss directory, run as root:
+
+# cd /dev
+# ./MAKEDEV cciss
+
 You need some entries in /dev for the cciss device.  The MAKEDEV script
 can make device nodes for you automatically.  Currently the device setup
 is as follows:
_

Patches currently in -mm which might be from steve.cameron@hp.com are

origin.patch
