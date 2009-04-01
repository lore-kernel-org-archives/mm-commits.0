From: akpm@linux-foundation.org
Subject: [merged] rtc-parisc-remove-unnecessary-ret-variable.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:42:01 -0700
Message-ID: <200904011842.n31Ig1PB009566@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933983AbZDATnV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:43:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dannf@hp.com, a.zummo@towertech.it, grundler@parisc-linux.org, kyle@mcmartin.ca, matthew@wil.cx, mm-commits@vger.kernel.org


The patch titled
     rtc-parisc: remove unnecessary ret variable
has been removed from the -mm tree.  Its filename was
     rtc-parisc-remove-unnecessary-ret-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-parisc: remove unnecessary ret variable
From: dann frazier <dannf@hp.com>

Signed-off-by: dann frazier <dannf@hp.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/kernel/time.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN arch/parisc/kernel/time.c~rtc-parisc-remove-unnecessary-ret-variable arch/parisc/kernel/time.c
--- a/arch/parisc/kernel/time.c~rtc-parisc-remove-unnecessary-ret-variable
+++ a/arch/parisc/kernel/time.c
@@ -223,10 +223,7 @@ static struct platform_device rtc_parisc
 
 static int __init rtc_init(void)
 {
-	int ret;
