From: akpm@linux-foundation.org
Subject: + fix-alignment-of-ip-config-output.patch added to -mm tree
Date: Wed, 13 Feb 2008 16:53:38 -0800
Message-ID: <200802140053.m1E0rc2L023271@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37151 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765095AbYBNAyL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 19:54:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Uwe.Kleine-Koenig@digi.com, davem@davemloft.net


The patch titled
     fix alignment of IP-Config output
has been added to the -mm tree.  Its filename is
     fix-alignment-of-ip-config-output.patch

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
Subject: fix alignment of IP-Config output
From: Uwe Kleine-Koenig <Uwe.Kleine-Koenig@digi.com>

Make the indented lines aligned in the output (not in the code).

Signed-off-by: Uwe Kleine-Koenig <Uwe.Kleine-Koenig@digi.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv4/ipconfig.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/ipv4/ipconfig.c~fix-alignment-of-ip-config-output net/ipv4/ipconfig.c
--- a/net/ipv4/ipconfig.c~fix-alignment-of-ip-config-output
+++ a/net/ipv4/ipconfig.c
@@ -1390,7 +1390,7 @@ static int __init ip_auto_config(void)
 	 * Clue in the operator.
 	 */
 	printk("IP-Config: Complete:");
-	printk("\n      device=%s", ic_dev->name);
+	printk("\n     device=%s", ic_dev->name);
 	printk(", addr=%u.%u.%u.%u", NIPQUAD(ic_myaddr));
 	printk(", mask=%u.%u.%u.%u", NIPQUAD(ic_netmask));
 	printk(", gw=%u.%u.%u.%u", NIPQUAD(ic_gateway));
_

Patches currently in -mm which might be from Uwe.Kleine-Koenig@digi.com are

fix-alignment-of-ip-config-output.patch
