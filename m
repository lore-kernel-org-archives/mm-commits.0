From: akpm@linux-foundation.org
Subject: [merged]
 maintainers-update-ivtv-mailing-lists-as-subscriber-only.patch removed from -mm tree
Date: Thu, 11 Dec 2014 11:05:14 -0800
Message-ID: <5489eaea.AalLEbCz872qLaDe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45655 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaLKTFP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:05:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, awalls@md.metrocast.net, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update ivtv mailing lists as subscriber-only
has been removed from the -mm tree.  Its filename was
     maintainers-update-ivtv-mailing-lists-as-subscriber-only.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: update ivtv mailing lists as subscriber-only

Mark these as subscriber-only mailing lists.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Walls <awalls@md.metrocast.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-update-ivtv-mailing-lists-as-subscriber-only MAINTAINERS
--- a/MAINTAINERS~maintainers-update-ivtv-mailing-lists-as-subscriber-only
+++ a/MAINTAINERS
@@ -2723,7 +2723,7 @@ F:	drivers/net/wireless/cw1200/
 
 CX18 VIDEO4LINUX DRIVER
 M:	Andy Walls <awalls@md.metrocast.net>
-L:	ivtv-devel@ivtvdriver.org (moderated for non-subscribers)
+L:	ivtv-devel@ivtvdriver.org (subscribers-only)
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
 W:	http://linuxtv.org
@@ -5209,7 +5209,7 @@ F:	drivers/media/tuners/it913x*
 
 IVTV VIDEO4LINUX DRIVER
 M:	Andy Walls <awalls@md.metrocast.net>
-L:	ivtv-devel@ivtvdriver.org (moderated for non-subscribers)
+L:	ivtv-devel@ivtvdriver.org (subscribers-only)
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
 W:	http://www.ivtvdriver.org
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf.patch
linux-next.patch

