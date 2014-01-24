From: akpm@linux-foundation.org
Subject: [merged] doc-kmemcheck-add-kmemcheck-to-kernel-parameters.patch
 removed from -mm tree
Date: Fri, 24 Jan 2014 10:59:35 -0800
Message-ID: <52e2b817.blmNQDs5RyXBzf+R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43348 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbaAXS7f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 13:59:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vegardno@ifi.uio.no, rob@landley.net, penberg@kernel.org, qiuxishi@huawei.com

Subject: [merged] doc-kmemcheck-add-kmemcheck-to-kernel-parameters.patch removed from -mm tree
To: qiuxishi@huawei.com,penberg@kernel.org,rob@landley.net,vegardno@ifi.uio.no,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 10:59:35 -0800


The patch titled
     Subject: doc/kmemcheck: add kmemcheck to kernel-parameters
has been removed from the -mm tree.  Its filename was
     doc-kmemcheck-add-kmemcheck-to-kernel-parameters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1445,6 +1445,13 @@ bytes respectively. Such letter suffixes
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

origin.patch

