From: akpm@linux-foundation.org
Subject: + add-documentation-rcu-00-index.patch added to -mm tree
Date: Mon, 15 Oct 2007 13:40:29 -0700
Message-ID: <200710152040.l9FKeTo9024051@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40018 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758729AbXJOUkt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 16:40:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rob@landley.net, paulmck@us.ibm.com


The patch titled
     Add Documentation/RCU/00-Index
has been added to the -mm tree.  Its filename is
     add-documentation-rcu-00-index.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-arm.patch
git-scsi-misc.patch
docs-ramdisk-initrd-initramfs-corrections.patch
documentation-make-headers_installtxt.patch
documentation-add-entries-to-filesystems-00-index-for-several-untracked-files.patch
add-a-missing-00-index-file-for-documentation-vm.patch
add-a-00-index-file-to-documentation-mips.patch
add-a-00-index-file-to-documentation-sysctl.patch
add-a-00-index-file-to-documentation-telephony.patch
tweak-documentation-sm501txt.patch
add-missing-entries-to-top-level-documentation-00-index.patch
add-documentation-w1w1-masters-00-index.patch
add-entries-to-documentation-powerpc.patch
add-documentation-power-00-index.patch
add-recommended-section-ids-to-deviceiobooktmpl.patch
add-documentation-rcu-00-index.patch
