From: akpm@linux-foundation.org
Subject: +
 drivers-net-ieee802154-at86rf230c-seq_printf-now-returns-null-fix.patch
 added to -mm tree
Date: Fri, 11 Sep 2015 11:28:20 -0700
Message-ID: <55f31d44.uWEn+7E1IsahJUAV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56142 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbbIKS2V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:28:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.aring@gmail.com, marcel@holtmann.org, sfr@canb.auug.org.au, stefan@osg.samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers-net-ieee802154-at86rf230c-seq_printf-now-returns-null-fix
has been added to the -mm tree.  Its filename is
     drivers-net-ieee802154-at86rf230c-seq_printf-now-returns-null-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-net-ieee802154-at86rf230c-seq_printf-now-returns-null-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-net-ieee802154-at86rf230c-seq_printf-now-returns-null-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Aring <alex.aring@gmail.com>
Subject: drivers-net-ieee802154-at86rf230c-seq_printf-now-returns-null-fix

fix whitespace, unused var `ret'

Signed-off-by: Alexander Aring <alex.aring@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Stefan Schmidt <stefan@osg.samsung.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ieee802154/at86rf230.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/net/ieee802154/at86rf230.c~drivers-net-ieee802154-at86rf230c-seq_printf-now-returns-null-fix drivers/net/ieee802154/at86rf230.c
--- a/drivers/net/ieee802154/at86rf230.c~drivers-net-ieee802154-at86rf230c-seq_printf-now-returns-null-fix
+++ a/drivers/net/ieee802154/at86rf230.c
@@ -1645,15 +1645,14 @@ static struct dentry *at86rf230_debugfs_
 static int at86rf230_stats_show(struct seq_file *file, void *offset)
 {
 	struct at86rf230_local *lp = file->private;
-	int ret;
 
 	seq_printf(file, "SUCCESS:\t\t%8llu\n", lp->trac.success);
 	seq_printf(file, "SUCCESS_DATA_PENDING:\t%8llu\n",
-			 lp->trac.success_data_pending);
+		   lp->trac.success_data_pending);
 	seq_printf(file, "SUCCESS_WAIT_FOR_ACK:\t%8llu\n",
-			 lp->trac.success_wait_for_ack);
+		   lp->trac.success_wait_for_ack);
 	seq_printf(file, "CHANNEL_ACCESS_FAILURE:\t%8llu\n",
-			 lp->trac.channel_access_failure);
+		   lp->trac.channel_access_failure);
 	seq_printf(file, "NO_ACK:\t\t\t%8llu\n", lp->trac.no_ack);
 	seq_printf(file, "INVALID:\t\t%8llu\n", lp->trac.invalid);
 	return 0;
_

Patches currently in -mm which might be from alex.aring@gmail.com are

drivers-net-ieee802154-at86rf230c-seq_printf-now-returns-null-fix.patch

