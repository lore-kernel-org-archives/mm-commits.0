From: akpm@linux-foundation.org
Subject: + maintainers-i8k-driver-is-orphan.patch added to -mm tree
Date: Thu, 21 Mar 2013 12:30:02 -0700
Message-ID: <20130321193002.6D2DC31C30E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:40753 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab3CUTaE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 15:30:04 -0400
Received: by mail-vb0-f74.google.com with SMTP id r6so293528vbi.5
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 12:30:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, dz@debian.org


The patch titled
     Subject: MAINTAINERS: i8k driver is orphan
has been added to the -mm tree.  Its filename is
     maintainers-i8k-driver-is-orphan.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jean Delvare <khali@linux-fr.org>
Subject: MAINTAINERS: i8k driver is orphan

Massimo Dal Zotto stopped maintaining the i8k driver several years ago, so
move his name from MAINTAINERS to CREDITS.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Massimo Dal Zotto <dz@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS     |    4 ++++
 MAINTAINERS |    4 +---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff -puN CREDITS~maintainers-i8k-driver-is-orphan CREDITS
--- a/CREDITS~maintainers-i8k-driver-is-orphan
+++ a/CREDITS
@@ -761,6 +761,10 @@ S: Northampton
 S: NN1 3QT
 S: United Kingdom
 
+N: Massimo Dal Zotto
+E: dz@debian.org
+D: i8k Dell laptop SMM driver
+
 N: Uwe Dannowski
 E: Uwe.Dannowski@ira.uka.de
 W: http://i30www.ira.uka.de/~dannowsk/
diff -puN MAINTAINERS~maintainers-i8k-driver-is-orphan MAINTAINERS
--- a/MAINTAINERS~maintainers-i8k-driver-is-orphan
+++ a/MAINTAINERS
@@ -2430,9 +2430,7 @@ S:	Maintained
 F:	drivers/platform/x86/dell-laptop.c
 
 DELL LAPTOP SMM DRIVER
-M:	Massimo Dal Zotto <dz@debian.org>
-W:	http://www.debian.org/~dz/i8k/
-S:	Maintained
+S:	Orphan
 F:	drivers/char/i8k.c
 F:	include/uapi/linux/i8k.h
 
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
linux-next.patch
matroxfb-convert-struct-i2c_msg-initialization-to-c99-format.patch
maintainers-i8k-driver-is-orphan.patch
checkpatch-add-check-for-reuse-of-krealloc-arg.patch

