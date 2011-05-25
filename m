From: akpm@linux-foundation.org
Subject: [merged] maintainers-orphan-dmfe-move-tobias-ringstrom-to-credits.patch removed from -mm tree
Date: Wed, 25 May 2011 13:31:48 -0700
Message-ID: <201105252030.p4PKUCnv014943@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932207Ab1EYUau (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:30:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: orphan DMFE, move Tobias Ringstrom to CREDITS
has been removed from the -mm tree.  Its filename was
     maintainers-orphan-dmfe-move-tobias-ringstrom-to-credits.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: MAINTAINERS: orphan DMFE, move Tobias Ringstrom to CREDITS
=46rom: Joe Perches <joe@perches.com>

Tobias's email bounces and he hasn't submitted or acked a patch in git
history.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS     |    4 ++++
 MAINTAINERS |    3 +--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff -puN CREDITS~maintainers-orphan-dmfe-move-tobias-ringstrom-to-cred=
its CREDITS
--- a/CREDITS~maintainers-orphan-dmfe-move-tobias-ringstrom-to-credits
+++ a/CREDITS
@@ -2943,6 +2943,10 @@ S: Kasarmikatu 11 A4
 S: 70110 Kuopio
 S: Finland
=20
+N: Tobias Ringstr=C3=B6m
+E: tori@unhappy.mine.nu
+D: Davicom DM9102(A)/DM9132/DM9801 fast ethernet driver
+
 N: Luca Risolia
 E: luca.risolia@studio.unibo.it
 P: 1024D/FCE635A4 88E8 F32F 7244 68BA 3958  5D40 99DA 5D2A FCE6 35A4
diff -puN MAINTAINERS~maintainers-orphan-dmfe-move-tobias-ringstrom-to-=
credits MAINTAINERS
--- a/MAINTAINERS~maintainers-orphan-dmfe-move-tobias-ringstrom-to-cred=
its
+++ a/MAINTAINERS
@@ -2034,9 +2034,8 @@ F:	net/ax25/ax25_timer.c
 F:	net/ax25/sysctl_net_ax25.c
=20
 DAVICOM FAST ETHERNET (DMFE) NETWORK DRIVER
-M:	Tobias Ringstrom <tori@unhappy.mine.nu>
 L:	netdev@vger.kernel.org
-S:	Maintained
+S:	Orphan
 F:	Documentation/networking/dmfe.txt
 F:	drivers/net/tulip/dmfe.c
=20
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
checkpatch-suggest-using-min_t-or-max_t.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
