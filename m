From: akpm@linux-foundation.org
Subject: [merged] ipmi-remove-ipmi_smih-self-include.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:01:39 -0400
Message-ID: <201003150702.o2F72Ch1016853@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54134 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935855Ab0COHCQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:02:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minyard@acm.org, mm-commits@vger.kernel.org


The patch titled
     ipmi: remove ipmi_smi.h self-include
has been removed from the -mm tree.  Its filename was
     ipmi-remove-ipmi_smih-self-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipmi: remove ipmi_smi.h self-include
From: Corey Minyard <minyard@acm.org>

There is no need for linux/ipmi_smi.h to include itself.

Signed-off-by: Corey Minyard <minyard@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipmi_smi.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/ipmi_smi.h~ipmi-remove-ipmi_smih-self-include include/linux/ipmi_smi.h
--- a/include/linux/ipmi_smi.h~ipmi-remove-ipmi_smih-self-include
+++ a/include/linux/ipmi_smi.h
@@ -39,7 +39,6 @@
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
-#include <linux/ipmi_smi.h>
 
 /* This files describes the interface for IPMI system management interface
    drivers to bind into the IPMI message handler. */
_

Patches currently in -mm which might be from minyard@acm.org are

origin.patch

