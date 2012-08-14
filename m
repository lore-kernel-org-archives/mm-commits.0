From: akpm@linux-foundation.org
Subject: + w1-omap-hdq-remove-unnecessary-return.patch added to -mm tree
Date: Tue, 14 Aug 2012 16:12:56 -0700
Message-ID: <20120814231257.97E8120004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:41619 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab2HNXNA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Aug 2012 19:13:00 -0400
Received: by eekd4 with SMTP id d4so45724eek.1
        for <mm-commits@vger.kernel.org>; Tue, 14 Aug 2012 16:12:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbi@ti.com, greg@kroah.com, zbr@ioremap.net


The patch titled
     Subject: drivers/w1/masters/omap_hdq.c: remove unnecessary return
has been added to the -mm tree.  Its filename is
     w1-omap-hdq-remove-unnecessary-return.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Felipe Balbi <balbi@ti.com>
Subject: drivers/w1/masters/omap_hdq.c: remove unnecessary return

Trivial patch, no functional changes.

Signed-off-by: Felipe Balbi <balbi@ti.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/omap_hdq.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/w1/masters/omap_hdq.c~w1-omap-hdq-remove-unnecessary-return drivers/w1/masters/omap_hdq.c
--- a/drivers/w1/masters/omap_hdq.c~w1-omap-hdq-remove-unnecessary-return
+++ a/drivers/w1/masters/omap_hdq.c
@@ -538,8 +538,6 @@ static void omap_w1_write_byte(void *_hd
 		hdq_data->init_trans = 0;
 		mutex_unlock(&hdq_data->hdq_mutex);
 	}
