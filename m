From: akpm@linux-foundation.org
Subject: - add-documentation-rcu-00-index.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:05:01 -0700
Message-ID: <200710180705.l9I751JW031609@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37551 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761677AbXJRHQU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:16:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rob@landley.net, paulmck@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Add Documentation/RCU/00-Index
has been removed from the -mm tree.  Its filename was
     add-documentation-rcu-00-index.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add Documentation/RCU/00-Index
From: Rob Landley <rob@landley.net>

Add Documentation/RCU/00-INDEX

Signed-off-by: Rob Landley <rob@landley.net>
Acked-by: Paul E. McKenney <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/RCU/00-INDEX |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff -puN /dev/null Documentation/RCU/00-INDEX
--- /dev/null
+++ a/Documentation/RCU/00-INDEX
@@ -0,0 +1,22 @@
+00-INDEX
+	- This file
+arrayRCU.txt
+	- Using RCU to Protect Read-Mostly Arrays
+checklist.txt
+	- Review Checklist for RCU Patches
+listRCU.txt
+	- Using RCU to Protect Read-Mostly Linked Lists
+NMI-RCU.txt
+	- Using RCU to Protect Dynamic NMI Handlers
+rcuref.txt
+	- Reference-count design for elements of lists/arrays protected by RCU
+rcu.txt
+	- RCU Concepts
+RTFP.txt
+	- List of RCU papers (bibliography) going back to 1980.
+torture.txt
+	- RCU Torture Test Operation (CONFIG_RCU_TORTURE_TEST)
+UP.txt
+	- RCU on Uniprocessor Systems
+whatisRCU.txt
+	- What is RCU?
_

Patches currently in -mm which might be from rob@landley.net are

origin.patch
comment-typo-in-scripts-kconfig-makefile.patch
