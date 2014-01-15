From: akpm@linux-foundation.org
Subject: + documentation-cpu-hotplug-fix-the-typo-in-example-code.patch
 added to -mm tree
Date: Wed, 15 Jan 2014 15:33:34 -0800
Message-ID: <52d71ace.az550RD+ckzvIRdN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44880 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbaAOXde (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Jan 2014 18:33:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com, sangjung.woo@samsung.com

Subject: + documentation-cpu-hotplug-fix-the-typo-in-example-code.patch added to -mm tree
To: sangjung.woo@samsung.com,srivatsa.bhat@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Wed, 15 Jan 2014 15:33:34 -0800


The patch titled
     Subject: Documentation/cpu-hotplug.txt: fix a typo in example code
has been added to the -mm tree.  Its filename is
     documentation-cpu-hotplug-fix-the-typo-in-example-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-cpu-hotplug-fix-the-typo-in-example-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-cpu-hotplug-fix-the-typo-in-example-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

documentation-cpu-hotplug-fix-the-typo-in-example-code.patch

