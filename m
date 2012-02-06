From: akpm@linux-foundation.org
Subject: [merged] maintainers-remove-staging-sections.patch removed from -mm tree
Date: Mon, 06 Feb 2012 12:31:13 -0800
Message-ID: <20120206203113.63DA6A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:39320 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755401Ab2BFUbP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2012 15:31:15 -0500
Received: by lahl5 with SMTP id l5so219273lah.1
        for <mm-commits@vger.kernel.org>; Mon, 06 Feb 2012 12:31:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mchehab@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove staging sections
has been removed from the -mm tree.  Its filename was
     maintainers-remove-staging-sections.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: remove staging sections

Two commits moved files from staging to drivers/media/

commit d6ce55de3abcc ("[media] move cx25821 out of staging")
commit be30497085080 ("[media] move tm6000 to drivers/media/video")

Remove the sections.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 -----
 1 file changed, 5 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-staging-sections MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-staging-sections
+++ a/MAINTAINERS
@@ -6390,11 +6390,6 @@ M:	Omar Ramirez Luna <omar.ramirez@ti.co
 S:	Odd Fixes
 F:	drivers/staging/tidspbridge/
 
-STAGING - TRIDENT TVMASTER TMxxxx USB VIDEO CAPTURE DRIVERS
-L:	linux-media@vger.kernel.org
-S:	Odd Fixes
-F:	drivers/staging/tm6000/
