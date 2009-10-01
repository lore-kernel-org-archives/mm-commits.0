From: akpm@linux-foundation.org
Subject: + jsm-remove-unused-jsm_channel-ch_wopen-field.patch added to -mm tree
Date: Thu, 01 Oct 2009 13:54:23 -0700
Message-ID: <200910012054.n91KsN67014495@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752084AbZJAUzN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Oct 2009 16:55:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: leitao@linux.vnet.ibm.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, scottk@digi.com


The patch titled
     jsm: remove unused jsm_channel->ch_wopen field
has been added to the -mm tree.  Its filename is
     jsm-remove-unused-jsm_channel-ch_wopen-field.patch

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
Subject: jsm: remove unused jsm_channel->ch_wopen field
From: Breno Leitao <leitao@linux.vnet.ibm.com>

Currently the jsm_channel->ch_wopen field is defined and never used.  So,
this patch removes it.

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
Cc: Greg KH <greg@kroah.com>
Cc: Scott Kilau <scottk@digi.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/jsm/jsm.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/serial/jsm/jsm.h~jsm-remove-unused-jsm_channel-ch_wopen-field drivers/serial/jsm/jsm.h
--- a/drivers/serial/jsm/jsm.h~jsm-remove-unused-jsm_channel-ch_wopen-field
+++ a/drivers/serial/jsm/jsm.h
@@ -213,8 +213,6 @@ struct jsm_channel {
 	u8		ch_stopc;	/* Stop character		*/
 	u8		ch_startc;	/* Start character		*/
 
-	u32		ch_wopen;	/* Waiting for open process cnt */
