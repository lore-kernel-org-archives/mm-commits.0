From: akpm@linux-foundation.org
Subject: [merged] jsm-remove-ch_cpstime-field.patch removed from -mm tree
Date: Fri, 09 Oct 2009 15:05:38 -0700
Message-ID: <200910092205.n99M5c50021818@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38633 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934699AbZJIWGf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Oct 2009 18:06:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: leitao@linux.vnet.ibm.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, scottk@digi.com, mm-commits@vger.kernel.org


The patch titled
     jsm: remove ch_cpstime field
has been removed from the -mm tree.  Its filename was
     jsm-remove-ch_cpstime-field.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jsm: remove ch_cpstime field
From: Breno Leitao <leitao@linux.vnet.ibm.com>

Currently the field jsm_channel->ch_cpstime is defined but never used, so
this patch removes it.

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
Cc: Greg KH <greg@kroah.com>
Cc: Scott Kilau <scottk@digi.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/jsm/jsm.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/serial/jsm/jsm.h~jsm-remove-ch_cpstime-field drivers/serial/jsm/jsm.h
--- a/drivers/serial/jsm/jsm.h~jsm-remove-ch_cpstime-field
+++ a/drivers/serial/jsm/jsm.h
@@ -206,8 +206,6 @@ struct jsm_channel {
 
 	u64		ch_close_delay;	/* How long we should drop RTS/DTR for */
 
-	u64		ch_cpstime;	/* Time for CPS calculations	*/
