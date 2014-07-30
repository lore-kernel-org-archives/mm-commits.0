From: akpm@linux-foundation.org
Subject: + update-my-email-addresses-and-related-info.patch added to -mm
 tree
Date: Wed, 30 Jul 2014 14:10:09 -0700
Message-ID: <53d95f31.rLg7uRxK6jJvP4Ie%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:48783 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbaG3VKK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Jul 2014 17:10:10 -0400
Received: by mail-oa0-f74.google.com with SMTP id eb12so545118oac.3
        for <mm-commits@vger.kernel.org>; Wed, 30 Jul 2014 14:10:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: josh@joshtriplett.org, paulmck@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Josh has moved
has been added to the -mm tree.  Its filename is
     update-my-email-addresses-and-related-info.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/update-my-email-addresses-=
and-related-info.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/update-my-email-addresses-=
and-related-info.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Josh Triplett <josh@joshtriplett.org>
Subject: Josh has moved

My IBM email addresses haven't worked for years; also map some
old-but-functional forwarding addresses to my canonical address.

Update my GPG key fingerprint; I moved to 4096R a long time ago.

Update description.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap                |    5 +++++
 CREDITS                 |    7 ++++---
 MAINTAINERS             |    2 +-
 kernel/rcu/rcutorture.c |    4 ++--
 4 files changed, 12 insertions(+), 6 deletions(-)

diff -puN .mailmap~update-my-email-addresses-and-related-info .mailmap
--- a/.mailmap~update-my-email-addresses-and-related-info
+++ a/.mailmap
@@ -62,6 +62,11 @@ Jeff Garzik <jgarzik@pretzel.yyz.us>
 Jens Axboe <axboe@suse.de>
 Jens Osterkamp <Jens.Osterkamp@de.ibm.com>
 John Stultz <johnstul@us.ibm.com>
+<josh@joshtriplett.org> <josh@freedesktop.org>
+<josh@joshtriplett.org> <josh@kernel.org>
+<josh@joshtriplett.org> <josht@linux.vnet.ibm.com>
+<josh@joshtriplett.org> <josht@us.ibm.com>
+<josh@joshtriplett.org> <josht@vnet.ibm.com>
 Juha Yrjola <at solidboot.com>
 Juha Yrjola <juha.yrjola@nokia.com>
 Juha Yrjola <juha.yrjola@solidboot.com>
diff -puN CREDITS~update-my-email-addresses-and-related-info CREDITS
--- a/CREDITS~update-my-email-addresses-and-related-info
+++ a/CREDITS
@@ -3511,10 +3511,11 @@ S: MacGregor A.C.T 2615
 S: Australia
=20
 N: Josh Triplett
-E: josh@freedesktop.org
-P: 1024D/D0FE7AFB B24A 65C9 1D71 2AC2 DE87  CA26 189B 9946 D0FE 7AFB
-D: rcutorture maintainer
+E: josh@joshtriplett.org
+P: 4096R/8AFF873D 758E 5042 E397 4BA3 3A9C  1E67 0ED9 A3DF 8AFF 873D
+D: RCU and rcutorture
 D: lock annotations, finding and fixing lock bugs
+D: kernel tinification
=20
 N: Winfried Tr=C3=BCmper
 E: winni@xpilot.org
diff -puN MAINTAINERS~update-my-email-addresses-and-related-info MAINTA=
INERS
--- a/MAINTAINERS~update-my-email-addresses-and-related-info
+++ a/MAINTAINERS
@@ -7423,7 +7423,7 @@ S:	Orphan
 F:	drivers/net/wireless/ray*
=20
 RCUTORTURE MODULE
-M:	Josh Triplett <josh@freedesktop.org>
+M:	Josh Triplett <josh@joshtriplett.org>
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
 L:	linux-kernel@vger.kernel.org
 S:	Supported
diff -puN kernel/rcu/rcutorture.c~update-my-email-addresses-and-related=
-info kernel/rcu/rcutorture.c
--- a/kernel/rcu/rcutorture.c~update-my-email-addresses-and-related-inf=
o
+++ a/kernel/rcu/rcutorture.c
@@ -18,7 +18,7 @@
  * Copyright (C) IBM Corporation, 2005, 2006
  *
  * Authors: Paul E. McKenney <paulmck@us.ibm.com>
- *	  Josh Triplett <josh@freedesktop.org>
+ *	  Josh Triplett <josh@joshtriplett.org>
  *
  * See also:  Documentation/RCU/torture.txt
  */
@@ -51,7 +51,7 @@
 #include <linux/torture.h>
=20
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com> and Josh Triplett=
 <josh@freedesktop.org>");
+MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com> and Josh Triplett=
 <josh@joshtriplett.org>");
=20
=20
 torture_param(int, fqs_duration, 0,
_

Patches currently in -mm which might be from josh@joshtriplett.org are

update-my-email-addresses-and-related-info.patch
checkpatch-add-an-index-variable-for-fixed-lines.patch
checkpatch-add-ability-to-insert-and-delete-lines-to-patch-file.patch
initramfs-support-initramfs-that-is-bigger-than-2gib.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
