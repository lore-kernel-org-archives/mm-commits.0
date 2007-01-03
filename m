From: akpm@osdl.org
Subject: + maintainers-tag-pvrusb2-list-as-subscribers-only.patch added to -mm tree
Date: Wed, 03 Jan 2007 13:08:06 -0800
Message-ID: <200701032108.l03L86OX031269@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51477 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932121AbXACVWv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 3 Jan 2007 16:22:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: isely@pobox.com, mchehab@infradead.org


The patch titled
     MAINTAINERS: tag pvrusb2 list as subscribers-only
has been added to the -mm tree.  Its filename is
     maintainers-tag-pvrusb2-list-as-subscribers-only.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: MAINTAINERS: tag pvrusb2 list as subscribers-only
From: Mike Isely <isely@pobox.com>

Posting to the pvrusb2 mailing list is for subscribers only.  Anyone can
subscribe of course.  This is done purely to keep spammers and similar pond
scum from bothering the subscribers of the list.  This patch marks the
pvrusb2 list tag in MAINTAINERS to reflect this situation.

Signed-off-by: Mike Isely <isely@pobox.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 MAINTAINERS |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-tag-pvrusb2-list-as-subscribers-only MAINTAINERS
--- a/MAINTAINERS~maintainers-tag-pvrusb2-list-as-subscribers-only
+++ a/MAINTAINERS
@@ -2633,7 +2633,7 @@ S:	Supported
 PVRUSB2 VIDEO4LINUX DRIVER
 P:	Mike Isely
 M:	isely@pobox.com
-L:	pvrusb2@isely.net
+L:	pvrusb2@isely.net	(subscribers-only)
 L:	video4linux-list@redhat.com
 W:	http://www.isely.net/pvrusb2/
 S:	Maintained
_

Patches currently in -mm which might be from isely@pobox.com are

maintainers-tag-pvrusb2-list-as-subscribers-only.patch
