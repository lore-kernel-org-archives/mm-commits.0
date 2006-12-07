From: akpm@osdl.org
Subject: - swsusp-fix-coding-style-in-suspendc.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:59:48 -0800
Message-ID: <200612072259.kB7MxmEg029552@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51087 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163698AbWLGW76 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:59:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, nigel@suspend2.net, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     swsusp: Fix coding style in suspend.c
has been removed from the -mm tree.  Its filename was
     swsusp-fix-coding-style-in-suspendc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: swsusp: Fix coding style in suspend.c
From: "Rafael J. Wysocki" <rjw@sisk.pl>

Fix coding style in suspend.c.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Nigel Cunningham <nigel@suspend2.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/power/snapshot.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/power/snapshot.c~swsusp-fix-coding-style-in-suspendc kernel/power/snapshot.c
--- a/kernel/power/snapshot.c~swsusp-fix-coding-style-in-suspendc
+++ a/kernel/power/snapshot.c
@@ -85,7 +85,8 @@ unsigned long get_safe_page(gfp_t gfp_ma
 	return (unsigned long)get_image_page(gfp_mask, PG_SAFE);
 }
 
-static struct page *alloc_image_page(gfp_t gfp_mask) {
+static struct page *alloc_image_page(gfp_t gfp_mask)
+{
 	struct page *page;
 
 	page = alloc_page(gfp_mask);
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
git-acpi.patch
md-change-lifetime-rules-for-md-devices.patch

