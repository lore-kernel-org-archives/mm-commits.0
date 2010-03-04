From: akpm@linux-foundation.org
Subject: + ipmi-remove-ipmi_smih-self-include.patch added to -mm tree
Date: Thu, 04 Mar 2010 13:05:14 -0800
Message-ID: <201003042105.o24L5Eqo029778@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46852 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756483Ab0CDVFS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Mar 2010 16:05:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minyard@acm.org


The patch titled
     ipmi: remove ipmi_smi.h self-include
has been added to the -mm tree.  Its filename is
     ipmi-remove-ipmi_smih-self-include.patch

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

ipmi-fix-slave_addrs-setting-to-actually-work.patch
ipmi-remove-ipmi_smih-self-include.patch

