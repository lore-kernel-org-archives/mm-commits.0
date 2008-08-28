From: akpm@linux-foundation.org
Subject: - drivers-net-wdc-fix-undefined-reference-to-ns8390p_init.patch removed from -mm tree
Date: Thu, 28 Aug 2008 14:49:17 -0700
Message-ID: <200808282149.m7SLnH3t016175@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755937AbYH1Vui (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Aug 2008 17:50:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     drivers/net/wd.c: fix "undefined reference to `NS8390p_init'"
has been removed from the -mm tree.  Its filename was
     drivers-net-wdc-fix-undefined-reference-to-ns8390p_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
serial-8250-tighten-test-for-using-backup-timer.patch
linux-next.patch
v4l1-make-pms-not-autoprobe-when-builtin-update.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
pata_sil680-convert-config_ppc_merge-to-config_ppc.patch
acpi_pmc-use-proper-read-function-also-in-errata-mode.patch
acpi_pmc-check-for-monotonicity.patch
char-sx-remove-bogus-iomap.patch
serial-mpc52xx_uart-remove-code-associated-with-config_ppc_merge.patch
fb-push-down-the-bkl-in-the-ioctl-handler.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
tty-fix-loss-of-echoed-characters.patch
tty-minor-code-efficiency-and-style-cleanup.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
ip2-avoid-add_timer-with-pending-timer.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
char-moxac-sparse-annotation.patch

