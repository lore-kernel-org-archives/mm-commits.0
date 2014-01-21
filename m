From: akpm@linux-foundation.org
Subject: + doc-kmemcheck-add-kmemcheck-to-kernel-parameters.patch added to -mm tree
Date: Tue, 21 Jan 2014 11:20:59 -0800
Message-ID: <52dec89b.uG+Ik5PuXTWrzuMU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43881 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbaAUTVA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jan 2014 14:21:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vegardno@ifi.uio.no, rob@landley.net, penberg@kernel.org, qiuxishi@huawei.com

Subject: + doc-kmemcheck-add-kmemcheck-to-kernel-parameters.patch added to -mm tree
To: qiuxishi@huawei.com,penberg@kernel.org,rob@landley.net,vegardno@ifi.uio.no
From: akpm@linux-foundation.org
Date: Tue, 21 Jan 2014 11:20:59 -0800


The patch titled
     Subject: doc/kmemcheck: add kmemcheck to kernel-parameters
has been added to the -mm tree.  Its filename is
     doc-kmemcheck-add-kmemcheck-to-kernel-parameters.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/doc-kmemcheck-add-kmemcheck-to-kernel-parameters.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/doc-kmemcheck-add-kmemcheck-to-kernel-parameters.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: doc/kmemcheck: add kmemcheck to kernel-parameters

Add "kmemcheck=xx" to Documentation/kernel-parameters.txt.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Cc: Vegard Nossum <vegardno@ifi.uio.no>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Rob Landley <rob@landley.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN Documentation/kernel-parameters.txt~doc-kmemcheck-add-kmemcheck-to-kernel-parameters Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~doc-kmemcheck-add-kmemcheck-to-kernel-parameters
+++ a/Documentation/kernel-parameters.txt
@@ -1438,6 +1438,13 @@ bytes respectively. Such letter suffixes
 			Valid arguments: on, off
 			Default: on
 
+	kmemcheck=	[X86] Boot-time kmemcheck enable/disable/one-shot mode
+			Valid arguments: 0, 1, 2
+			kmemcheck=0 (disabled)
+			kmemcheck=1 (enabled)
+			kmemcheck=2 (one-shot mode)
+			Default: 2 (one-shot mode)
+
 	kstack=N	[X86] Print N words from the kernel stack
 			in oops dumps.
 
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

lib-show_memc-show-num_poisoned_pages-when-oom.patch
mm-do_mincore-cleanup.patch
mm-nobootmem-free_all_bootmem-again.patch
doc-kmemcheck-add-kmemcheck-to-kernel-parameters.patch
doc-kmemcheck-add-kmemcheck-to-kernel-parameterstxt.patch
linux-next.patch

