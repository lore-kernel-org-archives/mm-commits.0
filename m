From: akpm@linux-foundation.org
Subject: [to-be-updated]
 doc-kmemcheck-add-kmemcheck-to-kernel-parameterstxt.patch removed from -mm
 tree
Date: Tue, 21 Jan 2014 11:21:29 -0800
Message-ID: <52dec8b9.jKow9My84VLKz+un%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43885 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbaAUTVa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jan 2014 14:21:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, qiuxishi@huawei.com

Subject: [to-be-updated] doc-kmemcheck-add-kmemcheck-to-kernel-parameterstxt.patch removed from -mm tree
To: qiuxishi@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 21 Jan 2014 11:21:29 -0800


The patch titled
     Subject: doc/kmemcheck: add kmemcheck to kernel-parameters.txt
has been removed from the -mm tree.  Its filename was
     doc-kmemcheck-add-kmemcheck-to-kernel-parameterstxt.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: doc/kmemcheck: add kmemcheck to kernel-parameters.txt

Add kmemcheck to Documentation/kernel-parameters.txt.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN Documentation/kernel-parameters.txt~doc-kmemcheck-add-kmemcheck-to-kernel-parameterstxt Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~doc-kmemcheck-add-kmemcheck-to-kernel-parameterstxt
+++ a/Documentation/kernel-parameters.txt
@@ -1415,6 +1415,13 @@ bytes respectively. Such letter suffixes
 			Valid arguments: on, off
 			Default: on
 
+	kmemcheck=	[KNL] Boot-time kmemcheck enable/disable/one-shot mode
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
linux-next.patch

