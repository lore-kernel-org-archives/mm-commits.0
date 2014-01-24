From: akpm@linux-foundation.org
Subject: [merged]
 documentation-cpu-hotplug-fix-the-typo-in-example-code.patch removed from
 -mm tree
Date: Fri, 24 Jan 2014 11:03:22 -0800
Message-ID: <52e2b8fa.NTZ8QmFVz7fBHpZi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43819 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088AbaAXTDW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:03:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com, sangjung.woo@samsung.com

Subject: [merged] documentation-cpu-hotplug-fix-the-typo-in-example-code.patch removed from -mm tree
To: sangjung.woo@samsung.com,srivatsa.bhat@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:03:22 -0800


The patch titled
     Subject: Documentation/cpu-hotplug.txt: fix a typo in example code
has been removed from the -mm tree.  Its filename was
     documentation-cpu-hotplug-fix-the-typo-in-example-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sangjung Woo <sangjung.woo@samsung.com>
Subject: Documentation/cpu-hotplug.txt: fix a typo in example code

As the notifier_block name (i.e.  foobar_cpu_notifer) is different from
the parameter (i.e.foobar_cpu_notifier) of register function, that is
definitely error and it also makes readers confused.

Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cpu-hotplug.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/cpu-hotplug.txt~documentation-cpu-hotplug-fix-the-typo-in-example-code Documentation/cpu-hotplug.txt
--- a/Documentation/cpu-hotplug.txt~documentation-cpu-hotplug-fix-the-typo-in-example-code
+++ a/Documentation/cpu-hotplug.txt
@@ -285,7 +285,7 @@ A: This is what you would need in your k
 		return NOTIFY_OK;
 	}
 
-	static struct notifier_block foobar_cpu_notifer =
+	static struct notifier_block foobar_cpu_notifier =
 	{
 	   .notifier_call = foobar_cpu_callback,
 	};
_

Patches currently in -mm which might be from sangjung.woo@samsung.com are

origin.patch

