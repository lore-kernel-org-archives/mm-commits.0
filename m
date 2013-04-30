From: akpm@linux-foundation.org
Subject: [merged] maintainers-i8k-driver-is-orphan.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:51:05 -0700
Message-ID: <20130430185105.734F731C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:52387 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932669Ab3D3SvG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:51:06 -0400
Received: by mail-qc0-f202.google.com with SMTP id k26so86255qcs.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:51:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, dz@debian.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: i8k driver is orphan
has been removed from the -mm tree.  Its filename was
     maintainers-i8k-driver-is-orphan.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2444,9 +2444,7 @@ S:	Maintained
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

