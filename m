From: akpm@linux-foundation.org
Subject: + rtc-parisc-remove-unnecessary-ret-variable.patch added to -mm tree
Date: Mon, 26 Jan 2009 13:50:05 -0800
Message-ID: <200901262150.n0QLo5Y4004085@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33994 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754166AbZAZVvE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jan 2009 16:51:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dannf@hp.com, a.zummo@towertech.it, grundler@parisc-linux.org, kyle@mcmartin.ca, matthew@wil.cx


The patch titled
     rtc-parisc: remove unnecessary ret variable
has been added to the -mm tree.  Its filename is
     rtc-parisc-remove-unnecessary-ret-variable.patch

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
