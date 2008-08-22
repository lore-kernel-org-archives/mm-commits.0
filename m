From: akpm@linux-foundation.org
Subject: + drivers-net-wdc-fix-undefined-reference-to-ns8390p_init.patch added to -mm tree
Date: Fri, 22 Aug 2008 11:53:53 -0700
Message-ID: <200808221853.m7MIrrCM010935@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751823AbYHVSys (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Aug 2008 14:54:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jeff@garzik.org


The patch titled
     drivers/net/wd.c: fix "undefined reference to `NS8390p_init'"
has been added to the -mm tree.  Its filename is
     drivers-net-wdc-fix-undefined-reference-to-ns8390p_init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/wd.c: fix "undefined reference to `NS8390p_init'"
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan 'pass the paper bags' Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/wd.c~drivers-net-wdc-fix-undefined-reference-to-ns8390p_init drivers/net/wd.c
--- a/drivers/net/wd.c~drivers-net-wdc-fix-undefined-reference-to-ns8390p_init
+++ a/drivers/net/wd.c
@@ -337,7 +337,7 @@ static int __init wd_probe1(struct net_d
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	dev->poll_controller = ei_poll;
 #endif
-	NS8390p_init(dev, 0);
+	NS8390_init(dev, 0);
 
 #if 1
 	/* Enable interrupt generation on softconfig cards -- M.U */
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

linux-next.patch
v4l1-make-pms-not-autoprobe-when-builtin-update.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
serial-8250-tighten-test-for-using-backup-timer.patch
drivers-net-wdc-fix-undefined-reference-to-ns8390p_init.patch
char-sx-remove-bogus-iomap.patch
fb-push-down-the-bkl-in-the-ioctl-handler.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
ip2-avoid-add_timer-with-pending-timer.patch

