From: akpm@linux-foundation.org
Subject: [merged] rtc-parisc-declare-rtc_parisc_dev-as-static.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:41:59 -0700
Message-ID: <200904011841.n31Ifx0S009541@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52075 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933547AbZDASrk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:47:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dannf@hp.com, a.zummo@towertech.it, grundler@parisc-linux.org, kyle@mcmartin.ca, matthew@wil.cx, mm-commits@vger.kernel.org


The patch titled
     rtc-parisc: declare rtc_parisc_dev as static
has been removed from the -mm tree.  Its filename was
     rtc-parisc-declare-rtc_parisc_dev-as-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-parisc: declare rtc_parisc_dev as static
From: dann frazier <dannf@hp.com>

Signed-off-by: dann frazier <dannf@hp.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/kernel/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/parisc/kernel/time.c~rtc-parisc-declare-rtc_parisc_dev-as-static arch/parisc/kernel/time.c
--- a/arch/parisc/kernel/time.c~rtc-parisc-declare-rtc_parisc_dev-as-static
+++ a/arch/parisc/kernel/time.c
@@ -216,7 +216,7 @@ void __init start_cpu_itimer(void)
 	per_cpu(cpu_data, cpu).it_value = next_tick;
 }
 
-struct platform_device rtc_parisc_dev = {
+static struct platform_device rtc_parisc_dev = {
 	.name = "rtc-parisc",
 	.id = -1,
 };
_

Patches currently in -mm which might be from dannf@hp.com are

origin.patch
rtc-parisc-use-rtc_valid_tm-in-parisc_get_time.patch
ipmi-add-oem-message-handling.patch

