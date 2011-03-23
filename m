From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-media-path.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:39:52 -0700
Message-ID: <201103232043.p2NKhSsG028868@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933456Ab1CWUn6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:43:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, harryxiyou@gmail.com, maximlevitsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: update media path
has been removed from the -mm tree.  Its filename was
     maintainers-update-media-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: update media path
From: Joe Perches <joe@perches.com>

Commit 52b661449ae ("[media] rc: Rename remote controller type to rc_type
instead of ir_type") moved it around.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Acked-by: Harry Wei <harryxiyou@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-update-media-path MAINTAINERS
--- a/MAINTAINERS~maintainers-update-media-path
+++ a/MAINTAINERS
@@ -2479,8 +2479,7 @@ F:	include/linux/cb710.h
 ENE KB2426 (ENE0100/ENE020XX) INFRARED RECEIVER
 M:	Maxim Levitsky <maximlevitsky@gmail.com>
 S:	Maintained
-F:	drivers/media/IR/ene_ir.c
-F:	drivers/media/IR/ene_ir.h
+F:	drivers/media/rc/ene_ir.*
 
 EPSON 1355 FRAMEBUFFER DRIVER
 M:	Christopher Hoover <ch@murgatroid.com>
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch

