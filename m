From: akpm@linux-foundation.org
Subject: - add-entries-to-documentation-powerpc.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:04:44 -0700
Message-ID: <200710180704.l9I74iFu031585@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37803 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756100AbXJRHP3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rob@landley.net, mm-commits@vger.kernel.org


The patch titled
     Add entries to Documentation/powerpc
has been removed from the -mm tree.  Its filename was
     add-entries-to-documentation-powerpc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add entries to Documentation/powerpc
From: Rob Landley <rob@landley.net>

Add two missing entries to Documentation/powerpc/00-INDEX

Signed-off-by: Rob Landley <rob@landley.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/powerpc/00-INDEX |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN Documentation/powerpc/00-INDEX~add-entries-to-documentation-powerpc Documentation/powerpc/00-INDEX
--- a/Documentation/powerpc/00-INDEX~add-entries-to-documentation-powerpc
+++ a/Documentation/powerpc/00-INDEX
@@ -5,6 +5,8 @@ please mail me.
 
 00-INDEX
 	- this file
+booting-without-of.txt
+	- Booting the Linux/ppc kernel without Open Firmware
 cpu_features.txt
 	- info on how we support a variety of CPUs with minimal compile-time
 	options.
@@ -14,6 +16,8 @@ hvcs.txt
 	- IBM "Hypervisor Virtual Console Server" Installation Guide
 mpc52xx.txt
 	- Linux 2.6.x on MPC52xx family
+mpc52xx-device-tree-bindings.txt
+	- MPC5200 Device Tree Bindings
 ppc_htab.txt
 	- info about the Linux/PPC /proc/ppc_htab entry
 SBC8260_memory_mapping.txt
_

Patches currently in -mm which might be from rob@landley.net are

origin.patch
comment-typo-in-scripts-kconfig-makefile.patch
